import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/budget_provider.dart';
import '../widgets/powered_by_footer.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _category = 'Comida';

  @override
  Widget build(BuildContext context) {
    final categories = ['Comida', 'Transporte', 'Ocio', 'Otros'];
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir gasto')),
      bottomNavigationBar: const PoweredByFooter(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Ingresa monto' : null,
              ),
              DropdownButtonFormField<String>(
                value: _category,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v ?? 'Comida'),
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Nota'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final provider =
                        Provider.of<BudgetProvider>(context, listen: false);
                    provider.addExpense(
                      amount: double.parse(_amountController.text),
                      category: _category,
                      note: _noteController.text.isEmpty
                          ? null
                          : _noteController.text,
                    );
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