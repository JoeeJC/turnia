import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets.dart';

/// Pantalla 15 · Configuración.
class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Configuración'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          _groupTitle('Preferencias'),
          _cardBox(
            context,
            [
              _switchRow(
                icon: '🔔',
                title: 'Notificaciones',
                subtitle: 'Avisos de nuevos turnos',
                value: state.notifications,
                onChanged: state.setNotifications,
              ),
              _divider(),
              _switchRow(
                icon: '🌙',
                title: 'Modo oscuro',
                subtitle: 'Cambiar la apariencia',
                value: state.darkMode,
                onChanged: state.setDarkMode,
              ),
            ],
          ),
          _groupTitle('Negocio'),
          _cardBox(
            context,
            [
              _navRow(
                context,
                icon: '🕐',
                title: 'Horarios de atención',
                subtitle: 'Días y franjas activas',
                route: '/horarios',
              ),
              _divider(),
              _navRow(
                context,
                icon: '💅',
                title: 'Servicios',
                subtitle: '${state.services.length} activos',
                route: null,
                onTap: () {
                  state.setShellTab(2);
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
              ),
              _divider(),
              _navRow(
                context,
                icon: '🏪',
                title: 'Datos del negocio',
                subtitle: state.profile.businessName,
                route: '/perfil',
              ),
            ],
          ),
          _groupTitle('Cuenta'),
          _cardBox(
            context,
            [
              _navRow(
                context,
                icon: '🔑',
                title: 'Cambiar contraseña',
                route: null,
                onTap: () => _changePassword(context),
              ),
              _divider(),
              _navRow(
                context,
                icon: '🚪',
                title: 'Cerrar sesión',
                danger: true,
                route: null,
                onTap: () => _logout(context, state),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text('Turnia · versión 1.0.0',
                style: TextStyle(color: Brand.inkSoft, fontSize: 12.5)),
          ),
        ],
      ),
    );
  }

  Widget _groupTitle(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
        child: Text(t.toUpperCase(),
            style: const TextStyle(
                color: Brand.inkSoft, fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.6)),
      );

  Widget _cardBox(BuildContext context, List<Widget> children) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1B1A26) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dark ? const Color(0xFF2A2838) : Brand.line),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() => const Divider(height: 1, color: Brand.line, indent: 60);

  Widget _switchRow({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Brand.inkSoft, fontSize: 12.5)),
              ],
            ),
          ),
          Switch(value: value, activeColor: Brand.violet, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _navRow(
    BuildContext context, {
    required String icon,
    required String title,
    String? subtitle,
    String? route,
    VoidCallback? onTap,
    bool danger = false,
  }) {
    return InkWell(
      onTap: onTap ?? (route != null ? () => Navigator.of(context).pushNamed(route) : null),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: danger ? Brand.danger : null,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: Brand.inkSoft, fontSize: 12.5)),
                  ],
                ],
              ),
            ),
            if (!danger)
              const Icon(Icons.chevron_right_rounded, color: Brand.inkSoft),
          ],
        ),
      ),
    );
  }

  void _changePassword(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Cambiar contraseña',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 18),
            const FieldLabel('Contraseña actual'),
            const TextField(obscureText: true, decoration: InputDecoration(hintText: '••••••••')),
            const SizedBox(height: 14),
            const FieldLabel('Nueva contraseña'),
            const TextField(obscureText: true, decoration: InputDecoration(hintText: '••••••••')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                showToast(context, 'Contraseña actualizada');
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Cerrar sesión?',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Vas a tener que ingresar de nuevo.',
                style: TextStyle(color: Brand.inkSoft)),
            const SizedBox(height: 22),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Brand.danger),
              onPressed: () {
                state.logout();
                Navigator.of(ctx).pop();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
              },
              child: const Text('Sí, cerrar sesión'),
            ),
            const SizedBox(height: 10),
            GhostButton(label: 'Volver', onPressed: () => Navigator.of(ctx).pop()),
          ],
        ),
      ),
    );
  }
}