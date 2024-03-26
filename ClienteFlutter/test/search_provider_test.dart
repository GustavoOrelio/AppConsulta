import 'package:cliente_flutter/models/search_result.dart';
import 'package:cliente_flutter/view/search_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.mocks.dart';

void main() {
  group('SearchProvider Tests', () {
    late MockApiService mockApiService;
    late SearchProvider searchProvider;

    setUp(() {
      mockApiService = MockApiService();
      searchProvider = SearchProvider(apiService: mockApiService);
    });

    test(
        'Deve preencher a lista de resultados e não ter mensagem de erro se a busca for bem-sucedida',
        () async {
      when(mockApiService.fetchGoogleResults(any)).thenAnswer((_) async =>
          [SearchResult(title: 'Teste', link: 'http://example.com')]);

      await searchProvider.performSearch('teste');

      expect(searchProvider.searchResults.isNotEmpty, true);
      expect(searchProvider.errorMessage, '');
    });

    test('Deve exibir mensagem de erro quando a busca falhar', () async {
      when(mockApiService.fetchGoogleResults(any))
          .thenThrow(Exception('Erro ao buscar resultados.'));

      await searchProvider.performSearch('falha');

      expect(searchProvider.searchResults.isEmpty, true);
      expect(searchProvider.errorMessage, 'Erro ao buscar resultados.');
    });

    test(
        'Deve definir mensagem de erro adequada quando não houver termo de pesquisa',
        () async {
      await searchProvider.performSearch('');

      expect(searchProvider.searchResults.isEmpty, true);
      expect(searchProvider.errorMessage,
          'Por favor, insira um termo de pesquisa.');
    });

    test(
        'Deve exibir mensagem de que nenhum resultado foi encontrado quando a busca retornar vazia',
        () async {
      when(mockApiService.fetchGoogleResults(any))
          .thenAnswer((_) async => <SearchResult>[]);

      await searchProvider.performSearch('nada');

      expect(searchProvider.searchResults.isEmpty, true);
      expect(searchProvider.errorMessage, 'Nenhum resultado encontrado.');
    });
  });
}
