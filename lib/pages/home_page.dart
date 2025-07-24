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
    futureRates = ApiService.fetchRates('USD'); // ou outro base
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cotações')),
      body: FutureBuilder<List<RateModel>>(
        future: futureRates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Erro: ${snapshot.error}'));

          final rates = snapshot.data!;
          return ListView.builder(
            itemCount: rates.length,
            itemBuilder: (context, index) {
              final rate = rates[index];
              return ListTile(
                title: Text('${rate.base} → ${rate.target}'),
                subtitle: Text('Taxa: ${rate.rate.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DetailsPage(base: rate.base, target: rate.target),
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
