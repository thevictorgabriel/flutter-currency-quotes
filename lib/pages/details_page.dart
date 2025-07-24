import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DetailsPage extends StatelessWidget {
  final String base;
  final String target;

  const DetailsPage({super.key, required this.base, required this.target});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes $base → $target')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.fetchDetails(base, target),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Erro: ${snapshot.error}'));

          final data = snapshot.data!;
          final targetData = data['target_data'] ?? {};

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text('Taxa: ${data['conversion_rate']}', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text('Atualizado: ${data['time_last_update_utc']}'),
                Text('Próxima atualização: ${data['time_next_update_utc']}'),
                const Divider(),
                Text('Moeda: ${targetData['currency_name']} (${targetData['currency_name_short']})'),
                Text('País: ${targetData['locale']} (${targetData['two_letter_code']})'),
                if (targetData['flag_url'] != null)
                  Image.network(targetData['flag_url']),
                const Divider(),
                Text('Documentação: ${data['documentation']}'),
                Text('Termos de uso: ${data['terms_of_use']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
