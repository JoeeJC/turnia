import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../../../../../../models/models.dart';
import '../../../../../core/theme/../../core/theme/theme.dart';
import '../../../../widgets/p../widgets/widgets.dart';

/// Pantalla 3 · Registro con tipo de servicio.
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _nameCtrl = TextEditingController(text: 'Sofía');
  final _emailCtrl = TextEditingController(text: 'sofia@mail.com');
  final _passCtrl = TextEditingController(text: 'turnia123');
  bool _obscure = true;
  ServiceType _type = ServiceType.manicura;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final state = AppScope.of(context);
    state.setServiceType(_type);
    state.login();
    Navigator.of(context).pushReplacementNamed('/config-inicial');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Creá tu cuenta',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
              ),
              const SizedBox(height: 6),
              const Text(
                'Empezá a organizar tus turnos hoy',
                style: TextStyle(color: Brand.inkSoft, fontSize: 15),
              ),
              const SizedBox(height: 28),
              const FieldLabel('Nombre'),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  hintText: 'Sofía',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 18),
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
              const SizedBox(height: 22),
              const FieldLabel('Tipo de servicio'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ServiceType.values.map((t) {
                  final selected = _type == t;
                  return ChoiceChip(
                    label: Text(t.label),
                    selected: selected,
                    onSelected: (_) => setState(() => _type = t),
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : Brand.inkSoft,
                    ),
                    selectedColor: Brand.violet,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: selected ? Brand.violet : Brand.line, width: 1.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 34),
              ElevatedButton(onPressed: _submit, child: const Text('Crear cuenta')),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tenés cuenta? ', style: TextStyle(color: Brand.inkSoft)),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
                    child: const Text(
                      'Iniciar sesión',
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