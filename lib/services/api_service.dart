import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rate_model.dart';

class ApiService {
  static const String apiKey = 'f8ebbebeef7965b3fdb21438';

  static Future<List<RateModel>> fetchRates(String baseCode, {http.Client? client}) async {
    client ??= http.Client(); // se não passar um client, usa o padrão
    final url = Uri.parse('https://v6.exchangerate-api.com/v6/$apiKey/latest/$baseCode');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final rates = data['conversion_rates'] as Map<String, dynamic>;

      return rates.entries.map((e) => RateModel(baseCode, e.key, e.value.toDouble())).toList();
    } else {
      throw Exception('Erro ao carregar as cotações');
    }
  }

  static Future<Map<String, dynamic>> fetchDetails(String base, String target, {http.Client? client}) async {
    client ??= http.Client();
    final url = Uri.parse('https://v6.exchangerate-api.com/v6/$apiKey/pair/$base/$target');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao carregar detalhes');
    }
  }
}
