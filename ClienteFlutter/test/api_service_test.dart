import 'package:cliente_flutter/models/search_result.dart';
import 'package:cliente_flutter/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'mocks.mocks.dart';

void main() {
  group('Busca de Resultados no Google', () {
    test(
        'retorna uma Lista de ResultadoPesquisa se a chamada HTTP completa com sucesso',
        () async {
      final clienteMock = MockClient();
      ApiService servicoApi = ApiService(client: clienteMock);
      when(clienteMock
              .get(Uri.parse('http://10.0.2.2:5000/pesquisa?query=teste')))
          .thenAnswer((_) async => http.Response(
              '[{"titulo": "Teste", "url": "http://exemplo.com"}]', 200));

      expect(await servicoApi.fetchGoogleResults('teste'),
          isA<List<SearchResult>>());
    });

    test('lança uma exceção se a chamada HTTP completa com erro', () {
      final clienteMock = MockClient();
      ApiService servicoApi = ApiService(client: clienteMock);
      when(clienteMock
              .get(Uri.parse('http://10.0.2.2:5000/pesquisa?query=teste')))
          .thenAnswer((_) async => http.Response('Não Encontrado', 404));

      expect(servicoApi.fetchGoogleResults('teste'), throwsException);
    });
  });
}
