import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import 'dashboard_screen.dart';
import 'agenda_screen.dart';
import 'servicios_screen.dart';
import 'clientes_screen.dart';

/// Contenedor principal con navegación inferior.
/// La pestaña activa vive en [AppState] para que cualquier pantalla
/// pueda cambiarla aunque esté fuera del shell (Perfil, Configuración, etc.).
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final index = state.shellTab;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          DashboardScreen(),
          AgendaScreen(),
          ServiciosScreen(),
          ClientesScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF1B1A26) : Colors.white,
          border: Border(top: BorderSide(color: dark ? const Color(0xFF2A2838) : Brand.line)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: [
                _tab(context, state, 0, Icons.home_rounded, 'Inicio'),
                _tab(context, state, 1, Icons.calendar_month_rounded, 'Agenda'),
                _tab(context, state, 2, Icons.spa_rounded, 'Servicios'),
                _tab(context, state, 3, Icons.people_alt_rounded, 'Clientes'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, AppState state, int i, IconData icon, String label) {
    final active = state.shellTab == i;
    return Expanded(
      child: InkWell(
        onTap: () => state.setShellTab(i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: active ? Brand.violet : const Color(0xFF9A97B0)),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? Brand.violet : const Color(0xFF9A97B0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}