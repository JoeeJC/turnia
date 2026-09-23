import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets.dart';

/// Pantalla 10 · Horarios de atención por día.
class HorariosScreen extends StatelessWidget {
  const HorariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Horarios de atención'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          ...List.generate(state.schedules.length, (i) {
            final s = state.schedules[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              decoration: BoxDecoration(
                color: dark ? const Color(0xFF1B1A26) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: dark ? const Color(0xFF2A2838) : Brand.line),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.dayName,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(
                          s.rangeLabel,
                          style: TextStyle(
                            color: s.active ? Brand.inkSoft : const Color(0xFFB4B1C6),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (s.active)
                    IconButton(
                      icon: const Icon(Icons.schedule_rounded, size: 20, color: Brand.violet),
                      onPressed: () => _editHours(context, state, i),
                    ),
                  Switch(
                    value: s.active,
                    activeColor: Brand.violet,
                    onChanged: (v) => state.toggleSchedule(i, v),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          const Text(
            'Tocá un día para activarlo o desactivarlo. Podés ajustar el rango horario con el ícono de reloj. Los turnos se generan solo dentro de estos horarios.',
            style: TextStyle(color: Brand.inkSoft, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  void _editHours(BuildContext context, AppState state, int index) {
    final s = state.schedules[index];
    TimeOfDay toTod(int m) => TimeOfDay(hour: m ~/ 60, minute: m % 60);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        TimeOfDay open = toTod(s.openMinutes);
        TimeOfDay close = toTod(s.closeMinutes);
        return StatefulBuilder(
          builder: (ctx, setSheet) => Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Horario · ${s.dayName}',
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _timeBox(
                        context,
                        label: 'Apertura',
                        time: open,
                        onPick: (t) => setSheet(() => open = t),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _timeBox(
                        context,
                        label: 'Cierre',
                        time: close,
                        onPick: (t) => setSheet(() => close = t),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: () {
                    s.openMinutes = open.hour * 60 + open.minute;
                    s.closeMinutes = close.hour * 60 + close.minute;
                    state.toggleSchedule(index, s.active); // notifica el cambio
                    Navigator.of(ctx).pop();
                    showToast(context, 'Horario actualizado');
                  },
                  child: const Text('Guardar horario'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _timeBox(
    BuildContext context, {
    required String label,
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onPick,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(label),
        OutlinedButton(
          onPressed: () async {
            final picked = await showTimePicker(context: context, initialTime: time);
            if (picked != null) onPick(picked);
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}