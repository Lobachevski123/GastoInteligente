import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/budget_provider.dart';
import 'dashboard_screen.dart';
import '../widgets/powered_by_footer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _currencyController = TextEditingController(text: 'USD');
  final _reminderController = TextEditingController(text: '7');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      bottomNavigationBar: const PoweredByFooter(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v == null || v.isEmpty ? 'Ingresa tu nombre' : null,
              ),
              TextFormField(
                controller: _currencyController,
                decoration: const InputDecoration(labelText: 'Moneda (ej. USD)'),
                validator: (v) => v == null || v.isEmpty ? 'Ingresa moneda' : null,
              ),
              TextFormField(
                controller: _reminderController,
                decoration: const InputDecoration(labelText: 'Recordatorio cada X días'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Ingresa días' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final provider =
                        Provider.of<BudgetProvider>(context, listen: false);
                    provider.updateSettings(
                      newName: _nameController.text,
                      newCurrency: _currencyController.text,
                      newReminderDays: int.parse(_reminderController.text),
                    );
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const DashboardScreen()));
                  }
                },
                child: const Text('Comenzar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}