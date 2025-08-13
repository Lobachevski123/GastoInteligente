import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/budget_provider.dart';
import '../widgets/powered_by_footer.dart';
import 'dashboard_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showShield = false;
  bool _moveShield = false;
  bool _showBrand = false;

  @override
  void initState() {
    super.initState();
    _runAnimation();
  }

  Future<void> _runAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => _showShield = true);

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _moveShield = true;
      _showBrand = true; // aquí empezará el fade-in + slide de la marca
    });

    await Future.delayed(const Duration(seconds: 1));
    final provider = context.read<BudgetProvider>();
    final next = provider.name.isEmpty
        ? const OnboardingScreen()
        : const DashboardScreen();
    if (!mounted) return;
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => next));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ESCUDO
            AnimatedSlide(
              duration: const Duration(milliseconds: 500),
              offset: _moveShield ? const Offset(-0.5, 0) : Offset.zero,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _showShield ? 1 : 0,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 500),
                  scale: _showShield ? 1 : 0.8,
                  child: SvgPicture.asset(
                    'assets/escudo.svg',
                    width: 100,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // MARCA — reservado el espacio + invisible al inicio
            SizedBox(
              width: 160, // reservamos el ancho para que no se “corte”
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showBrand ? 1 : 0, // evita ver media marca al inicio
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  // desplazamiento corto para no partir fuera del área visible
                  offset: _showBrand ? Offset.zero : const Offset(0.25, 0),
                  child: SvgPicture.asset(
                    'assets/marca.svg',
                    width: 160,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          LinearProgressIndicator(),
          PoweredByFooter(),
        ],
      ),
    );
  }
}
