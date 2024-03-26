import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/search_result.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<SearchResult>> fetchGoogleResults(String searchTerm) async {
    final Uri apiUrl =
        Uri.parse('http://10.0.2.2:5000/pesquisa?query=$searchTerm');
    final http.Response apiResponse = await client.get(apiUrl);

    if (apiResponse.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(apiResponse.body);
      return jsonResponse.map((item) => SearchResult.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar resultados da pesquisa.');
    }
  }
}
