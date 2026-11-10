import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../../../../core/theme/../../core/theme/theme.dart';
import '../../../../widgets/p../widgets/widgets.dart';

/// Pantalla 2 · Login con email y contraseña.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: 'sofia@mail.com');
  final _passCtrl = TextEditingController(text: 'turnia123');
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    AppScope.of(context).login();
    Navigator.of(context).pushReplacementNamed('/app');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: Brand.brandGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 28),
              const Text(
                'Bienvenida de nuevo',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ingresá para gestionar tus turnos',
                style: TextStyle(color: Brand.inkSoft, fontSize: 15),
              ),
              const SizedBox(height: 32),
              const FieldLabel('Email'),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'sofia@mail.com',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
              ),
              const SizedBox(height: 18),
              const FieldLabel('Contraseña'),
              TextField(
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => showToast(context, 'Te enviamos un mail para recuperarla'),
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _submit, child: const Text('Iniciar sesión')),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tenés cuenta? ', style: TextStyle(color: Brand.inkSoft)),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/registro'),
                    child: const Text(
                      'Crear cuenta',
                      style: TextStyle(color: Brand.violet, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}