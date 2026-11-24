import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnia_app/core/utils/app_notifications.dart';
import 'package:turnia_app/core/utils/validators.dart';
import 'package:turnia_app/state/app_state.dart';

/// Pantalla de recuperación de contraseña.
///
/// Req 3: email validado, microcopy exacto sin revelar existencia.
class RecuperarScreen extends StatefulWidget {
  const RecuperarScreen({super.key});

  @override
  State<RecuperarScreen> createState() => _RecuperarScreenState();
}

class _RecuperarScreenState extends State<RecuperarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _cargando = false;
  bool _enviado = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _cargando = true);

    final appState = context.read<AppState>();
    final exito = await appState.recoverPassword(_emailController.text.trim());

    if (!mounted) return;
    setState(() {
      _cargando = false;
      _enviado = exito;
    });

    if (exito) {
      AppNotifications.success(
        context,
        message: 'Si tu email está registrado, recibirás instrucciones para restablecer tu contraseña.',
        actionLabel: 'Volver',
        onAction: () => Navigator.pop(context),
      );
    } else {
      AppNotifications.error(
        context,
        message: 'No se pudo procesar la solicitud. Intenta nuevamente.',
        actionLabel: 'Reintentar',
        onAction: () => _enviar(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_reset, size: 64, color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  'Recuperar contraseña',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ingresa tu email para recibir instrucciones',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                if (!_enviado) ...[
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          validator: validateEmail,
                          onFieldSubmitted: (_) => _enviar(),
                          decoration: const InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton(
                            onPressed: _cargando ? null : _enviar,
                            child: _cargando
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Enviar instrucciones'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Instrucciones enviadas',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Revisa tu bandeja de entrada',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Volver al inicio de sesión'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}