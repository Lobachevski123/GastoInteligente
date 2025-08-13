import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'providers/budget_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  final provider = BudgetProvider();
  await provider.load();
  runApp(
      Phoenix(
      child: ChangeNotifierProvider.value(
        value: provider,
        child: const MyApp(),
      ),
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
