import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_currency_quotes/models/rate_model.dart';

void main() {
  group('RateModel', () {
    test('deve criar uma instância corretamente', () {
      print('\n=== Teste: Criação de RateModel ===');
      
      // Dados de teste
      const base = 'USD';
      const target = 'BRL';
      const rate = 5.25;
      
      print('Criando RateModel com:');
      print(' - base: $base');
      print(' - target: $target');
      print(' - rate: $rate');
      
      final model = RateModel(base, target, rate);

      print('\nVerificando propriedades...');
      expect(model.base, base, reason: 'Base deve ser "USD"');
      print('✓ base OK');
      
      expect(model.target, target, reason: 'Target deve ser "BRL"');
      print('✓ target OK');
      
      expect(model.rate, rate, reason: 'Rate deve ser 5.25');
      print('✓ rate OK');
      
      print('\nTeste concluído com sucesso!');
    });

    test('deve permitir comparar instâncias com os mesmos valores', () {
      print('\n=== Teste: Comparação de RateModels ===');
      
      // Dados de teste
      const base = 'USD';
      const target = 'BRL';
      const rate = 5.25;
      
      print('Criando duas instâncias idênticas com:');
      print(' - base: $base');
      print(' - target: $target');
      print(' - rate: $rate');
      
      final a = RateModel(base, target, rate);
      final b = RateModel(base, target, rate);

      print('\nVerificando igualdade...');
      expect(a.base, b.base, reason: 'Bases devem ser iguais');
      print('✓ bases iguais');
      
      expect(a.target, b.target, reason: 'Targets devem ser iguais');
      print('✓ targets iguais');
      
      expect(a.rate, b.rate, reason: 'Rates devem ser iguais');
      print('✓ rates iguais');
      
      print('\nTeste de comparação concluído com sucesso!');
    });
  });
}