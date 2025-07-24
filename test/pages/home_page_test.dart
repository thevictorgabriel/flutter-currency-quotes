import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_currency_quotes/pages/home_page.dart';
import 'package:flutter_currency_quotes/models/rate_model.dart';
import 'package:flutter_currency_quotes/services/api_service.dart';

// Mock para ApiService
class MockApiService extends Mock implements ApiService {}

// Mock para Navigator
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockApiService mockApiService;
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockApiService = MockApiService();
    mockObserver = MockNavigatorObserver();
  });

  // ...
}