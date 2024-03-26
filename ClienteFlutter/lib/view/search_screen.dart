import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/search_result.dart';
import '../services/api_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<SearchResult> searchResults = [];
  bool isLoading = false;
  String errorMessage = '';

  void performSearch() async {
    if (searchController.text.isEmpty) {
      setState(() {
        errorMessage = 'Por favor, insira um termo de pesquisa.';
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    final String userQuery = Uri.encodeComponent(searchController.text);
    try {
      searchResults = await Provider.of<ApiService>(context, listen: false).fetchGoogleResults(userQuery);
      if (searchResults.isEmpty) {
        errorMessage = 'Nenhum resultado encontrado.';
      } else {
        errorMessage = '';
      }
    } catch (e) {
      errorMessage = 'Erro ao buscar resultados.';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisa.com'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Faça sua pesquisa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: performSearch,
                  ),
                ),
                onSubmitted: (value) => performSearch(),
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(child: Text(errorMessage)),
                ],
              ),
            )
                : AnimatedOpacity(
              opacity: isLoading ? 0.5 : 1.0,
              duration: Duration(milliseconds: 500),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      leading: Icon(Icons.link, color: Colors.deepPurple),
                      title: Text(searchResults[index].title),
                      subtitle: Text(searchResults[index].link, style: TextStyle(color: Colors.blue)),
                      onTap: () async {
                        final Uri url = Uri.parse(searchResults[index].link);
                        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Não foi possível abrir o link.')),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
