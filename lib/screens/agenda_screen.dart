import 'package:flutter/material.dart';
import '../app_state.dart';
import '../appointment_tile.dart';
import '../main.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// Pantalla 6 · Agenda con selector de semana y slots del día.
class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final days = List.generate(7, (i) => state.weekStart.add(Duration(days: i)));
    final selected = state.selectedDay;
    final turnos = state.appointmentsFor(selected);

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Agenda',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                      ),
                      const Spacer(),
                      _IconBtn(
                        icon: Icons.chevron_left_rounded,
                        onTap: () => state.shiftWeek(-1),
                      ),
                      const SizedBox(width: 6),
                      _IconBtn(
                        icon: Icons.chevron_right_rounded,
                        onTap: () => state.shiftWeek(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${monthNames[state.weekStart.month - 1]} ${state.weekStart.year}',
                      style: const TextStyle(color: Brand.inkSoft, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 82,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final d = days[i];
                final isSel = d.day == selected.day && d.month == selected.month;
                final count = state.appointmentsFor(d).length;
                return GestureDetector(
                  onTap: () => state.selectDay(d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 58,
                    decoration: BoxDecoration(
                      gradient: isSel ? Brand.brandGradient : null,
                      color: isSel ? null : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: isSel ? Colors.transparent : Brand.line, width: 1.4),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weekdayShort[d.weekday - 1],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isSel ? Colors.white70 : Brand.inkSoft,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${d.day}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: isSel ? Colors.white : Brand.ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: count > 0
                                ? (isSel ? Colors.white : Brand.violet)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {},
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Row(
                    children: [
                      Text(
                        dayLabel(selected),
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Brand.violet.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '${turnos.length} turno${turnos.length == 1 ? '' : 's'}',
                          style: const TextStyle(
                            color: Brand.violet,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (turnos.isEmpty)
                    _EmptyDay(selected: selected)
                  else
                    ..._buildSlots(context, turnos),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la grilla horaria interpolando slots ocupados y libres.
  List<Widget> _buildSlots(BuildContext context, List<Appointment> turnos) {
    final out = <Widget>[];
    int cursor = 9 * 60; // 09:00
    for (final a in turnos) {
      while (cursor < a.startMinutes) {
        out.add(FreeSlotTile(time: hhmm(cursor)));
        cursor += 60;
      }
      out.add(
        AppointmentTile(
          appointment: a,
          onTap: () => Navigator.of(context).pushNamed('/turno', arguments: TurnoArgs(a)),
        ),
      );
      cursor = a.startMinutes + a.durationMin;
      // Redondeo al siguiente bloque de 30 min
      cursor = ((cursor + 29) ~/ 30) * 30;
    }
    if (cursor < 18 * 60) {
      out.add(FreeSlotTile(time: hhmm(cursor)));
    }
    return out;
  }
}

class _EmptyDay extends StatelessWidget {
  final DateTime selected;
  const _EmptyDay({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Brand.line),
      ),
      child: Column(
        children: [
          const Icon(Icons.event_available_rounded, size: 44, color: Brand.violet),
          const SizedBox(height: 12),
          const Text('Día libre 🎉', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            'No tenés turnos para el ${shortDayLabel(selected)}',
            style: const TextStyle(color: Brand.inkSoft, fontSize: 13.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(side: BorderSide(color: Brand.line, width: 1.4)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 38, height: 38, child: Icon(icon, size: 22)),
      ),
    );
  }
}