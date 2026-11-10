import 'package:flutter/material.dart';
import '../../../../models/models.dart';
import '../../core/theme/../../core/theme/theme.dart';
import 'p../widgets/widgets.dart';

/// Fila de turno reutilizada en el Dashboard y la Agenda.
class AppointmentTile extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onTap;

  const AppointmentTile({super.key, required this.appointment, this.onTap});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: dark ? const Color(0xFF1B1A26) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.startLabel,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                      Text(
                        '${appointment.durationMin} min',
                        style: const TextStyle(color: Brand.inkSoft, fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 3.5,
                  height: 40,
                  decoration: BoxDecoration(
                    color: appointment.state.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.clientName,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appointment.serviceName,
                        style: const TextStyle(color: Brand.inkSoft, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                StateBadge(label: appointment.state.label, color: appointment.state.color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fila de turno "libre" para la vista de agenda.
class FreeSlotTile extends StatelessWidget {
  final String time;
  const FreeSlotTile({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF17161F) : Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dark ? const Color(0xFF2A2838) : Brand.line),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(time, style: const TextStyle(color: Brand.inkSoft, fontWeight: FontWeight.w600)),
          ),
          const Text('Libre', style: TextStyle(color: Color(0xFFB4B1C6), fontSize: 13.5)),
        ],
      ),
    );
  }
}