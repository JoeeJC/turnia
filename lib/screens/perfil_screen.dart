import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets.dart';

/// Pantalla 14 · Perfil del profesional.
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.profile;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).pushNamed('/config'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Center(
            child: Column(
              children: [
                InitialsAvatar(
                  initials: p.initials,
                  size: 92,
                  onTap: () => showToast(context, 'Cambiar foto (demo)',
                      icon: Icons.photo_camera_rounded),
                ),
                const SizedBox(height: 14),
                Text(p.ownerName,
                    style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(p.businessName,
                    style: const TextStyle(color: Brand.violet, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    p.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Brand.inkSoft, fontSize: 13.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Servicios',
            action: 'Ver todos',
            onAction: () {
              state.setShellTab(2);
              Navigator.of(context).popUntil((r) => r.isFirst);
            },
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.services
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: Brand.violet.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(s.name,
                          style: const TextStyle(
                              color: Brand.violet, fontWeight: FontWeight.w600, fontSize: 13)),
                    ))
                .toList(),
          ),
          const SectionHeader(title: 'Datos de contacto'),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                _row('📍', 'Dirección', p.address),
                const Divider(height: 1, color: Brand.line),
                _row('📱', 'Teléfono', p.phone),
                const Divider(height: 1, color: Brand.line),
                _row('✉️', 'Email', p.email),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GhostButton(
            label: 'Mi enlace de reservas',
            icon: Icons.link_rounded,
            onPressed: () => Navigator.of(context).pushNamed('/enlace'),
          ),
          const SizedBox(height: 12),
          GhostButton(
            label: 'Configuración',
            icon: Icons.settings_outlined,
            onPressed: () => Navigator.of(context).pushNamed('/config'),
          ),
        ],
      ),
    );
  }

  Widget _row(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 19)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Brand.inkSoft, fontSize: 12.5)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}