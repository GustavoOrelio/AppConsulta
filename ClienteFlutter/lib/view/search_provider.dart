import 'package:flutter/material.dart';

import '../models/search_result.dart';
import '../services/api_service.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService _apiService;

  SearchProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  List<SearchResult> searchResults = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> performSearch(String searchTerm) async {
    if (searchTerm.isEmpty) {
      errorMessage = 'Por favor, insira um termo de pesquisa.';
      isLoading = false;
      notifyListeners();
      return;
    }
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      searchResults = await _apiService.fetchGoogleResults(searchTerm);
      if (searchResults.isEmpty) {
        errorMessage = 'Nenhum resultado encontrado.';
      }
    } catch (e) {
      errorMessage = 'Erro ao buscar resultados.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
