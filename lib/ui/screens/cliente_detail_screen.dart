import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../../../../main.dart';
import '../../../../../../../models/models.dart';
import '../../../../../core/theme/../../core/theme/theme.dart';
import '../../../../widgets/p../widgets/widgets.dart';

/// Pantalla 12 · Detalle del cliente con historial.
class ClienteDetailScreen extends StatelessWidget {
  const ClienteDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is! Client) {
      return const Scaffold(body: Center(child: Text('Cliente no encontrado')));
    }
    final Client c = arg;
    final state = AppScope.of(context);
    final historial = state.historyFor(c.name);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Cliente'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Center(
            child: Column(
              children: [
                InitialsAvatar(initials: c.initials, size: 90),
                const SizedBox(height: 14),
                Text(c.name,
                    style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Brand.violet.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '${c.totalTurnos} turnos',
                    style: const TextStyle(
                        color: Brand.violet, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                _row(
                  icon: '📱',
                  label: 'Teléfono',
                  value: c.phone,
                  onTap: () => showToast(context, 'Llamar a ${c.name}', icon: Icons.call_rounded),
                ),
                const Divider(height: 1, color: Brand.line),
                _row(
                  icon: '📅',
                  label: 'Próximo turno',
                  value: c.nextTurno != null ? dayLabel(c.nextTurno!) : 'Sin turnos agendados',
                ),
                const Divider(height: 1, color: Brand.line),
                _row(
                  icon: '📊',
                  label: 'Total histórico',
                  value: '\$${c.totalFacturado}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text('Historial de turnos',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          ),
          if (historial.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('Todavía no hay historial',
                    style: TextStyle(color: Brand.inkSoft)),
              ),
            )
          else
            ...historial.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Brand.violet.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.check_rounded, color: Brand.violet, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.serviceName,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                            const SizedBox(height: 2),
                            Text(
                              '${dayLabel(a.date)} · ${a.startLabel}',
                              style: const TextStyle(color: Brand.inkSoft, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        a.priceLabel,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _row({
    required String icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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
      ),
    );
  }
}