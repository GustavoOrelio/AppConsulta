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
      searchResults = await Provider.of<ApiService>(context, listen: false)
          .fetchGoogleResults(userQuery);
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.deepPurple.shade200,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.deepPurple.shade400,
                      width: 2,
                    ),
                  ),
                  suffixIcon: searchController.text.isEmpty
                      ? IconButton(
                    icon: Icon(Icons.search, color: Colors.deepPurple),
                    onPressed: performSearch,
                  )
                      : IconButton(
                    icon: Icon(Icons.clear, color: Colors.deepPurple),
                    onPressed: () {
                      searchController.clear();
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
                onSubmitted: (value) => performSearch(),
              ),
            ),

            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.error_outline, color: Colors.red),
                    title:
                        Text(errorMessage, style: TextStyle(color: Colors.red)),
                  ),
                ),
              )
            else
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.link, color: Colors.deepPurple),
                      title: Text(searchResults[index].title),
                      subtitle: Text(
                        searchResults[index].link,
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                      onTap: () async {
                        final Uri url = Uri.parse(searchResults[index].link);
                        if (!await launchUrl(url,
                            mode: LaunchMode.externalApplication)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Não foi possível abrir o link.')),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
