import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// Pantalla 8 · Lista de servicios.
class ServiciosScreen extends StatelessWidget {
  const ServiciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final services = state.services;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  const Text(
                    'Servicios',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Brand.violet.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '${services.length}',
                      style: const TextStyle(color: Brand.violet, fontWeight: FontWeight.w700, fontSize: 12.5),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  ...services.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/servicio-form', arguments: s.id),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Brand.violet.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.spa_rounded, color: Brand.violet),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.name,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${s.priceLabel} · ${s.durationMin} min',
                                    style: const TextStyle(color: Brand.inkSoft, fontSize: 13.5),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: Brand.inkSoft),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pushNamed('/servicio-form'),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Agregar servicio'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}