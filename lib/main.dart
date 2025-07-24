import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotações de Moedas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CotacoesPage(),
    );
  }
}

class CotacoesPage extends StatefulWidget {
  const CotacoesPage({super.key});

  @override
  State<CotacoesPage> createState() => _CotacoesPageState();
}

class _CotacoesPageState extends State<CotacoesPage> {
  late Future<Map<String, dynamic>> futureRates;

  @override
  void initState() {
    super.initState();
    futureRates = ApiService.fetchExchangeRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cotações de Moedas')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureRates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            final rates = snapshot.data!;
            final moedas = rates.keys.toList();

            return ListView.builder(
              itemCount: moedas.length,
              itemBuilder: (context, index) {
                final moeda = moedas[index];
                final valor = rates[moeda];
                return ListTile(
                  title: Text('$moeda'),
                  subtitle: Text('1 USD = $valor $moeda'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesMoeda(moeda: moeda, valor: valor),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class DetalhesMoeda extends StatelessWidget {
  final String moeda;
  final dynamic valor;

  const DetalhesMoeda({super.key, required this.moeda, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes de $moeda')),
      body: Center(
        child: Text('1 USD = $valor $moeda', style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
