import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/search_result.dart';

class SearchResultTile extends StatelessWidget {
  final SearchResult searchResult;

  SearchResultTile({required this.searchResult});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.link, color: Colors.deepPurple),
        title: Text(searchResult.title),
        subtitle: Text(
          searchResult.link,
          style: TextStyle(color: Colors.blue.shade900),
        ),
        onTap: () async {
          final Uri url = Uri.parse(searchResult.link);
          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Não foi possível abrir o link.')),
            );
          }
        },
      ),
    );
  }
}
