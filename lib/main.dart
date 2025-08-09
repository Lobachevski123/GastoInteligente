import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/budget_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = BudgetProvider();
  await provider.load();
  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context);
    return MaterialApp(
      title: 'Gasto inteligente',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: provider.name.isEmpty
          ? const OnboardingScreen()
          : const DashboardScreen(),
    );
  }
}
