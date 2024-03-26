import 'package:cliente_flutter/view/search_provider.dart';
import 'package:cliente_flutter/view/search_result_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
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
                      icon: const Icon(Icons.search, color: Colors.deepPurple),
                      onPressed: () {
                        Provider.of<SearchProvider>(context, listen: false)
                            .performSearch(searchController.text);
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.clear, color: Colors.deepPurple),
                      onPressed: () {
                        searchController.clear();
                      },
                    ),
            ),
            onChanged: (value) {
              setState(() {});
            },
            onSubmitted: (value) {
              Provider.of<SearchProvider>(context, listen: false)
                  .performSearch(value);
            },
          ),
        ),
        Consumer<SearchProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.errorMessage.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.error_outline, color: Colors.red),
                    title: Text(
                      provider.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              );
            } else {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: provider.searchResults.length,
                itemBuilder: (context, index) {
                  return SearchResultTile(
                    searchResult: provider.searchResults[index],
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
