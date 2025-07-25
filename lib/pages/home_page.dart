import 'package:flutter/material.dart';
import '../models/rate_model.dart';
import '../services/api_service.dart';
import 'details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<RateModel>> futureRates;

  @override
  void initState() {
    super.initState();
    futureRates = ApiService.fetchRates('USD');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotações do dólar americano'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<RateModel>>(
        future: futureRates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final rates = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: rates.length,
            itemBuilder: (context, index) {
              final rate = rates[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: const Icon(Icons.currency_exchange, color: Colors.indigo, size: 32),
                  title: Text(
                    '${rate.base} → ${rate.target}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text('Taxa: ${rate.rate.toStringAsFixed(2)}'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.indigo),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(base: rate.base, target: rate.target),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
