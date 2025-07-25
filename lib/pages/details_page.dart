import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DetailsPage extends StatelessWidget {
  final String base;
  final String target;

  const DetailsPage({super.key, required this.base, required this.target});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes $base → $target'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.fetchDetails(base, target),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final targetData = data['target_data'] ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.deepPurple.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text('1 $base =', style: TextStyle(fontSize: 18, color: Colors.deepPurple)),
                        Text(
                          '${data['conversion_rate']} $target',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        ),
                        const SizedBox(height: 10),
                        if (targetData['flag_url'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              targetData['flag_url'],
                              width: 64,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Última atualização:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(data['time_last_update_utc']),
                      const SizedBox(height: 8),
                      Text('Próxima atualização:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(data['time_next_update_utc']),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Documentação:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(data['documentation'], style: TextStyle(color: Colors.blue)),
                      const SizedBox(height: 8),
                      Text('Termos de uso:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(data['terms_of_use'], style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
