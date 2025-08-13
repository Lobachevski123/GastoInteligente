import 'package:flutter/material.dart';

class PoweredByFooter extends StatelessWidget {
  const PoweredByFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false, // solo nos importa el borde inferior
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        'Powered by Colegio Pitágoras',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}
