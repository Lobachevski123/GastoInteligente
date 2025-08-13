import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import '../providers/budget_provider.dart';
import 'add_expense_screen.dart';
import 'update_money_screen.dart';
import '../widgets/powered_by_footer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Color _colorForState(String state) {
    switch (state) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BudgetProvider>();
    final pct = provider.percentSpent.clamp(0, 100);
    final color = _colorForState(provider.alertState);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gasto Inteligente'),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.restart_alt),
              onPressed: () => Phoenix.rebirth(context),
            ),
        ],
      ),
      bottomNavigationBar: const PoweredByFooter(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (provider.alertState != 'green')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: color.withOpacity(0.2),
                child: Row(
                  children: [
                    Icon(provider.alertState == 'red'
                        ? Icons.error
                        : Icons.warning, color: color),
                    const SizedBox(width: 8),
                    Expanded(child: Text(provider.alertMessage())),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Text('Dinero inicial: ${provider.currency} ${provider.initialMoney.toStringAsFixed(2)}'),
            Text('Total gastado: ${provider.currency} ${provider.totalSpent.toStringAsFixed(2)}'),
            Text('Saldo estimado: ${provider.currency} ${(provider.initialMoney - provider.totalSpent).toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: provider.initialMoney == 0 ? 0 : pct / 100,
              color: color,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 10),
            Text('Porcentaje gastado: ${pct.toStringAsFixed(1)}%'),
            const SizedBox(height: 20),
            Text('Racha de registro: ${provider.streak} días'),
            Text('Nivel: ${provider.level}'),
            Text('Puntos: ${provider.points}'),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: provider.initialMoney == 0
                      ? null
                      : () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const AddExpenseScreen()));
                        },
                  child: const Text('Añadir gasto'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const UpdateMoneyScreen()));
                  },
                  child: const Text('Actualizar dinero'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (provider.alertState == 'red' && !provider.challengeActive)
              ElevatedButton(
                onPressed: provider.startChallenge,
                child: const Text('Iniciar reto 48h'),
              ),
            if (provider.challengeActive)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reto activo. Tiempo restante: '
                      '${provider.challengeRemaining?.inHours ?? 0}h'),
                  if ((provider.challengeRemaining ?? Duration.zero) ==
                      Duration.zero)
                    ElevatedButton(
                      onPressed: provider.completeChallenge,
                      child: const Text('Completar reto'),
                    )
                ],
              ),
          ],
        ),
      ),
    );
  }
}