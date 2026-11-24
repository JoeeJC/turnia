import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:turnia_app/models/models.dart';
import 'package:turnia_app/state/app_state.dart';
import 'package:turnia_app/ui/widgets/empty_state.dart';
import 'package:turnia_app/ui/widgets/offline_banner.dart';
import 'package:turnia_app/ui/widgets/skeleton_loader.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Widget _kpiCard(String titulo, String valor, IconData icono) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icono, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(valor, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(titulo, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _climaCard(BuildContext context, AppState appState) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Clima actual', style: tema.textTheme.titleLarge),
                if (appState.isWeatherLoading)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ),
            const SizedBox(height: 12),
            if (appState.weatherError != null)
              Text(appState.weatherError!, style: const TextStyle(color: Colors.red))
            else if (appState.climaActual != null)
              Row(
                children: [
                  const Icon(Icons.wb_sunny, color: Colors.orange),
                  const SizedBox(width: 12),
                  Text('${appState.climaActual!.temperatura.toStringAsFixed(1)}°C', style: tema.textTheme.titleLarge),
                ],
              )
            else
              const SkeletonLoader(height: 40, width: 200),
          ],
        ),
      ),
    );
  }

  Widget _accesoRapido(String label, IconData icono, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icono, size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _turnosRecientes(AppState appState) {
    final tema = Theme.of(context);
    final recientes = appState.turnos.take(5).toList();
    return SizedBox(
      height: 132,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recientes.length,
        itemBuilder: (context, index) {
          final turno = recientes[index];
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(turno.clienteNombre, style: tema.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(turno.servicioNombre, style: tema.textTheme.bodySmall?.copyWith(color: tema.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Text(DateFormat('dd/MM HH:mm').format(turno.fechaHora), style: const TextStyle(fontSize: 12)),
                    const Spacer(),
                    Chip(
                      label: Text(turno.estado.label, style: const TextStyle(fontSize: 10)),
                      backgroundColor: WidgetStateColor.resolveWith((states) {
                        switch (turno.estado) {
                          case EstadoTurno.pendiente: return Colors.amber;
                          case EstadoTurno.confirmado: return Colors.blue;
                          case EstadoTurno.completado: return Colors.green;
                          case EstadoTurno.cancelado: return Colors.red;
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          body: OfflineBanner(
            child: RefreshIndicator(
              onRefresh: () async {
                await appState.cargarTurnos();
                await appState.cargarClientes();
                await appState.cargarServicios();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hola, ${appState.usuarioActual?['nombre'] ?? 'Usuario'}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Aquí tienes un resumen de tu día',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: _kpiCard('Turnos hoy', '${appState.turnos.length}', Icons.calendar_today)),
                              const SizedBox(width: 12),
                              Expanded(child: _kpiCard('Clientes', '${appState.clientes.length}', Icons.people)),
                              const SizedBox(width: 12),
                              Expanded(child: _kpiCard('Servicios', '${appState.servicios.length}', Icons.menu_book)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _climaCard(context, appState),
                          const SizedBox(height: 24),
                          Text('Accesos rápidos', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _accesoRapido('Nuevo turno', Icons.add_circle, () => Navigator.pushNamed(context, '/turno-form'))),
                              const SizedBox(width: 12),
                              Expanded(child: _accesoRapido('Agenda', Icons.calendar_today, () => {})),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Últimos turnos', style: Theme.of(context).textTheme.titleLarge),
                              TextButton(onPressed: () => {}, child: const Text('Ver todo')),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (appState.isLoading)
                            const SkeletonLoader(height: 200)
                          else if (appState.turnos.isEmpty)
                            EmptyState(
                              icon: Icons.event_busy,
                              title: 'No hay turnos agendados',
                              subtitle: 'Crea tu primer turno para comenzar.',
                              ctaLabel: 'Crear turno',
                              onCtaPressed: () => Navigator.pushNamed(context, '/turno-form'),
                            )
                          else
                            _turnosRecientes(appState),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}