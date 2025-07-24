import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://open.er-api.com/v6/latest/USD';

  static Future<Map<String, dynamic>> fetchExchangeRates() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['rates'];
    } else {
      throw Exception('Falha ao carregar cotações');
    }
  }
}
