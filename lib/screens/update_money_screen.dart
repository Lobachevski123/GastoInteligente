import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/budget_provider.dart';

class UpdateMoneyScreen extends StatefulWidget {
  const UpdateMoneyScreen({super.key});

  @override
  State<UpdateMoneyScreen> createState() => _UpdateMoneyScreenState();
}

class _UpdateMoneyScreenState extends State<UpdateMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actualizar dinero')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Monto disponible'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Ingresa monto' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final provider =
                        Provider.of<BudgetProvider>(context, listen: false);
                    provider.setInitialMoney(
                        double.parse(_amountController.text));
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Guardar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}