import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnia_app/state/app_state.dart';

/// Splash screen con logo, contraste accesible y transición <2s.
///
/// Req 2 (splash con Auth Guard) y Req 17.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  final bool _error = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _iniciarAuthGuard();
    });
  }

  Future<void> _iniciarAuthGuard() async {
    final appState = context.read<AppState>();
    await appState.initApp();

    if (!mounted) return;

    // Esperar al menos 2s para que se vea el splash
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final usuario = appState.usuarioActual;
    if (usuario != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _fade,
          builder: (context, child) {
            return Opacity(
              opacity: _fade.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.spa, size: 80, color: theme.colorScheme.onPrimary),
                  const SizedBox(height: 24),
                  Text(
                    'Turnia',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gestión de turnos para estética y belleza',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_error) ...[
                    const SizedBox(height: 24),
                    Text(
                      'No se pudo cargar la sesión. Intenta de nuevo.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}