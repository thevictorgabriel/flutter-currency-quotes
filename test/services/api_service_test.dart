import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:flutter_currency_quotes/services/api_service.dart';
import 'package:flutter_currency_quotes/models/rate_model.dart';

import '../mocks/mock_http_client.mocks.dart';

void main() {
  late MockClient mockClient;

  setUp(() {
    print('\n=== Configurando mockClient ===');
    mockClient = MockClient();
  });

  group('ApiService.fetchRates', () {
    test('retorna uma lista de RateModel quando status 200', () async {
      print('\n[TESTE] fetchRates - Status 200 - Início');
      const baseCode = 'USD';
      final mockResponse = {
        "conversion_rates": {
          "EUR": 0.85,
          "BRL": 5.3,
        }
      };

      print('Configurando mock para URL: https://v6.exchangerate-api.com/v6/${ApiService.apiKey}/latest/$baseCode');
      when(mockClient.get(
        Uri.parse('https://v6.exchangerate-api.com/v6/${ApiService.apiKey}/latest/$baseCode'),
      )).thenAnswer((_) async {
        print('Mock HTTP GET retornando resposta simulada (status 200)');
        return http.Response(jsonEncode(mockResponse), 200);
      });

      print('Chamando ApiService.fetchRates...');
      final result = await ApiService.fetchRates(baseCode, client: mockClient);
      print('Resultado recebido: $result');

      print('Verificando expectativas...');
      expect(result, isA<List<RateModel>>());
      expect(result.length, 2);
      expect(result.first.target, 'EUR');
      expect(result.first.rate, 0.85);
      print('[TESTE] fetchRates - Status 200 - Todos os testes passaram!');
    });

    test('lança uma exceção quando a resposta não é 200', () async {
      print('\n[TESTE] fetchRates - Erro 500 - Início');
      const baseCode = 'USD';

      print('Configurando mock para retornar erro 500');
      when(mockClient.get(
        Uri.parse('https://v6.exchangerate-api.com/v6/${ApiService.apiKey}/latest/$baseCode'),
      )).thenAnswer((_) async {
        print('Mock HTTP GET retornando erro simulado (status 500)');
        return http.Response('Erro', 500);
      });

      print('Verificando se a exceção é lançada...');
      expect(() => ApiService.fetchRates(baseCode, client: mockClient), throwsException);
      print('[TESTE] fetchRates - Erro 500 - Teste de exceção passou!');
    });
  });

  group('ApiService.fetchDetails', () {
    test('retorna mapa com detalhes quando status 200', () async {
      print('\n[TESTE] fetchDetails - Status 200 - Início');
      const base = 'USD';
      const target = 'EUR';

      final mockResponse = {
        "result": "success",
        "conversion_rate": 0.85,
        "base_code": base,
        "target_code": target
      };

      print('Configurando mock para URL: https://v6.exchangerate-api.com/v6/${ApiService.apiKey}/pair/$base/$target');
      when(mockClient.get(
        Uri.parse('https://v6.exchangerate-api.com/v6/${ApiService.apiKey}/pair/$base/$target'),
      )).thenAnswer((_) async {
        print('Mock HTTP GET retornando resposta simulada (status 200)');
        return http.Response(jsonEncode(mockResponse), 200);
      });

      print('Chamando ApiService.fetchDetails...');
      final result = await ApiService.fetchDetails(base, target, client: mockClient);
      print('Resultado recebido: $result');

      print('Verificando expectativas...');
      expect(result['result'], 'success');
      expect(result['conversion_rate'], 0.85);
      print('[TESTE] fetchDetails - Status 200 - Todos os testes passaram!');
    });

    test('lança uma exceção quando a resposta não é 200', () async {
      print('\n[TESTE] fetchDetails - Erro 404 - Início');
      const base = 'USD';
      const target = 'EUR';

      print('Configurando mock para retornar erro 404');
      when(mockClient.get(
        Uri.parse('https://v6.exchangerate-api.com/v6/${ApiService.apiKey}/pair/$base/$target'),
      )).thenAnswer((_) async {
        print('Mock HTTP GET retornando erro simulado (status 404)');
        return http.Response('Erro', 404);
      });

      print('Verificando se a exceção é lançada...');
      expect(() => ApiService.fetchDetails(base, target, client: mockClient), throwsException);
      print('[TESTE] fetchDetails - Erro 404 - Teste de exceção passou!');
    });
  });

  print('\n=== Todos os testes foram concluídos ===');
}