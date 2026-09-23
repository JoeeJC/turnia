import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// Pantalla 4 · Configuración inicial del negocio.
class ConfigInicialScreen extends StatefulWidget {
  const ConfigInicialScreen({super.key});

  @override
  State<ConfigInicialScreen> createState() => _ConfigInicialScreenState();
}

class _ConfigInicialScreenState extends State<ConfigInicialScreen> {
  final _nameCtrl = TextEditingController(text: 'Sofía Manicura');
  final _descCtrl = TextEditingController(text: 'Uñas y belleza de manos en Palermo ✨');
  final _addrCtrl = TextEditingController(text: 'Av. Santa Fe 1234, CABA');
  AttentionMode _mode = AttentionMode.local;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _addrCtrl.dispose();
    super.dispose();
  }

  void _finish() {
    AppScope.of(context).setProfile(
      businessName: _nameCtrl.text,
      description: _descCtrl.text,
      address: _addrCtrl.text,
      mode: _mode,
    );
    Navigator.of(context).pushReplacementNamed('/app');
  }

  @override
  Widget build(BuildContext context) {
    final initials = _nameCtrl.text.trim().isEmpty
        ? 'SM'
        : _nameCtrl.text.trim().split(RegExp(r'\s+')).map((e) => e[0]).take(2).join().toUpperCase();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Brand.violet.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'Paso 1 de 1',
                    style: TextStyle(color: Brand.violet, fontWeight: FontWeight.w700, fontSize: 12.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Configurá tu negocio',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
              ),
              const SizedBox(height: 6),
              const Text(
                'Estos datos van a aparecer en tu página de reservas',
                style: TextStyle(color: Brand.inkSoft, fontSize: 15),
              ),
              const SizedBox(height: 26),
              const FieldLabel('Nombre del negocio'),
              TextField(
                controller: _nameCtrl,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Sofía Manicura',
                  prefixIcon: Icon(Icons.storefront_outlined),
                ),
              ),
              const SizedBox(height: 18),
              const FieldLabel('Foto / logo'),
              AppCard(
                onTap: () => showToast(context, 'Selector de imagen (demo)'),
                child: Row(
                  children: [
                    InitialsAvatar(initials: initials, size: 54),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Subir imagen', style: TextStyle(fontWeight: FontWeight.w700)),
                          SizedBox(height: 2),
                          Text('PNG o JPG · máx. 5 MB', style: TextStyle(color: Brand.inkSoft, fontSize: 12.5)),
                        ],
                      ),
                    ),
                    const Icon(Icons.upload_rounded, color: Brand.violet),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const FieldLabel('Descripción'),
              TextField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Contá qué hacés'),
              ),
              const SizedBox(height: 18),
              const FieldLabel('Dirección o modalidad de atención'),
              TextField(
                controller: _addrCtrl,
                decoration: const InputDecoration(
                  hintText: 'Av. Santa Fe 1234, CABA',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: AttentionMode.values.map((m) {
                  final selected = _mode == m;
                  return ChoiceChip(
                    label: Text(m.label),
                    selected: selected,
                    onSelected: (_) => setState(() => _mode = m),
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
              const SizedBox(height: 32),
              ElevatedButton(onPressed: _finish, child: const Text('Listo, empezar')),
            ],
          ),
        ),
      ),
    );
  }
}