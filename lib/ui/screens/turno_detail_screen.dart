import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../../../../main.dart';
import '../../../../../../../models/models.dart';
import '../../../../../core/theme/../../core/theme/theme.dart';
import '../../../../widgets/p../widgets/widgets.dart';

/// Pantalla 7 · Detalle del turno con acciones.
class TurnoDetailScreen extends StatelessWidget {
  const TurnoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! TurnoArgs) {
      return const Scaffold(body: Center(child: Text('Turno no encontrado')));
    }
    final Appointment a = args.appointment;
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Detalle del turno'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          AppCard(
            child: Row(
              children: [
                InitialsAvatar(initials: a.clientInitials, size: 56),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '👩 ${a.clientName}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '💅 ${a.serviceName}',
                        style: const TextStyle(color: Brand.inkSoft, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                StateBadge(label: a.state.label, color: a.state.color),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                _InfoRow(icon: '📅', label: 'Fecha', value: dayLabel(a.date)),
                _divider(),
                _InfoRow(icon: '🕐', label: 'Horario', value: a.timeLabel),
                _divider(),
                _InfoRow(icon: '💵', label: 'Precio', value: a.priceLabel),
                _divider(),
                _InfoRow(icon: '⏱️', label: 'Duración', value: '${a.durationMin} min'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            onPressed: () {
              state.setTurnoState(a.id, TurnoState.confirmado);
              showToast(context, 'Turno confirmado');
            },
            child: const Text('Confirmar'),
          ),
          const SizedBox(height: 12),
          GhostButton(
            label: 'Reprogramar',
            icon: Icons.event_repeat_rounded,
            onPressed: () => showToast(context, 'Elegí una nueva fecha y horario', icon: Icons.edit_calendar_rounded),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _confirmCancel(context, state, a),
            icon: const Icon(Icons.close_rounded, size: 18),
            label: const Text('Cancelar turno'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: Brand.danger,
              side: BorderSide(color: Brand.danger.withValues(alpha: 0.4), width: 1.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              textStyle: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, color: Brand.line);

  void _confirmCancel(BuildContext context, AppState state, Appointment a) {
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
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Brand.line,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '¿Cancelar el turno?',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Se va a liberar el horario de ${a.clientName}.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Brand.inkSoft),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Brand.danger),
              onPressed: () {
                state.setTurnoState(a.id, TurnoState.cancelado);
                Navigator.of(ctx).pop();
                showToast(context, 'Turno cancelado', icon: Icons.cancel_rounded);
              },
              child: const Text('Sí, cancelar'),
            ),
            const SizedBox(height: 10),
            GhostButton(
              label: 'Volver',
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
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