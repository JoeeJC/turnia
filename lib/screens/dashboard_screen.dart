import 'package:flutter/material.dart';
import '../app_state.dart';
import '../appointment_tile.dart';
import '../main.dart';
import '../theme.dart';
import '../widgets.dart';

/// Pantalla 5 · Dashboard / Inicio.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final turnos = state.todayAppointments;
    final totalMin = turnos.fold<int>(0, (p, a) => p + a.durationMin);
    final hours = totalMin ~/ 60;
    final mins = totalMin % 60;
    final initials = state.profile.initials;
    final greeting = greetingForHour(DateTime.now().hour);

    void openTab(int i) => state.setShellTab(i);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: Brand.heroGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$greeting, ${state.profile.ownerName.split(' ').first} 👋',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Esto es lo que tenés para hoy',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InitialsAvatar(
                          initials: initials,
                          size: 46,
                          color: Colors.white.withValues(alpha: 0.22),
                          onTap: () => Navigator.of(context).pushNamed('/perfil'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${turnos.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Turnos de hoy',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(Icons.schedule_rounded, color: Colors.white, size: 20),
                              const SizedBox(height: 6),
                              Text(
                                '$hours hs${mins > 0 ? ' $mins min' : ''} reservadas',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SectionHeader(
                  title: 'Hoy',
                  action: 'Ver agenda',
                  onAction: () => openTab(1),
                ),
                if (turnos.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: Text('No tenés turnos agendados para hoy', style: TextStyle(color: Brand.inkSoft)),
                    ),
                  )
                else
                  ...turnos.map(
                    (a) => AppointmentTile(
                      appointment: a,
                      onTap: () => Navigator.of(context).pushNamed('/turno', arguments: TurnoArgs(a)),
                    ),
                  ),
                const SectionHeader(title: 'Accesos rápidos'),
                Row(
                  children: [
                    _QuickAction(
                      icon: Icons.calendar_month_rounded,
                      color: Brand.violet,
                      label: 'Ver agenda',
                      onTap: () => openTab(1),
                    ),
                    const SizedBox(width: 12),
                    _QuickAction(
                      icon: Icons.add_rounded,
                      color: Brand.pink,
                      label: 'Nuevo servicio',
                      onTap: () => Navigator.of(context).pushNamed('/servicio-form'),
                    ),
                    const SizedBox(width: 12),
                    _QuickAction(
                      icon: Icons.share_rounded,
                      color: Brand.teal,
                      label: 'Compartir\nmi enlace',
                      onTap: () => Navigator.of(context).pushNamed('/enlace'),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Material(
        color: dark ? const Color(0xFF1B1A26) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}