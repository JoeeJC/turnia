import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:turnia_app/models/models.dart';
import 'package:turnia_app/state/app_state.dart';
import 'package:turnia_app/ui/widgets/empty_state.dart';
import 'package:turnia_app/ui/widgets/skeleton_loader.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final _busquedaController = TextEditingController();

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Agenda')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _busquedaController,
                      decoration: const InputDecoration(
                        labelText: 'Buscar turno o cliente',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (v) => appState.setSearchQuery(v),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('Pendiente'),
                          selected: appState.estadoFiltro == EstadoTurno.pendiente,
                          onSelected: (_) => appState.setEstadoFiltro(EstadoTurno.pendiente),
                        ),
                        FilterChip(
                          label: const Text('Confirmado'),
                          selected: appState.estadoFiltro == EstadoTurno.confirmado,
                          onSelected: (_) => appState.setEstadoFiltro(EstadoTurno.confirmado),
                        ),
                        FilterChip(
                          label: const Text('Completado'),
                          selected: appState.estadoFiltro == EstadoTurno.completado,
                          onSelected: (_) => appState.setEstadoFiltro(EstadoTurno.completado),
                        ),
                        FilterChip(
                          label: const Text('Cancelado'),
                          selected: appState.estadoFiltro == EstadoTurno.cancelado,
                          onSelected: (_) => appState.setEstadoFiltro(EstadoTurno.cancelado),
                        ),
                        FilterChip(
                          label: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Icon(Icons.favorite, size: 16), SizedBox(width: 6), Text('Favoritos')],
                          ),
                          selected: appState.soloFavoritos,
                          onSelected: (v) => appState.setSoloFavoritos(v),
                        ),
                        if (appState.estadoFiltro != null || appState.soloFavoritos || appState.searchQuery.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              _busquedaController.clear();
                              appState.limpiarFiltros();
                            },
                            child: const Text('Limpiar'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: appState.isLoading
                    ? const Center(child: SkeletonLoader(height: 200))
                    : appState.turnosFiltrados.isEmpty
                    ? EmptyState(
                        icon: Icons.event_busy,
                        title: 'No hay turnos',
                        subtitle: 'Ajusta los filtros o crea un turno nuevo.',
                        ctaLabel: 'Crear turno',
                        onCtaPressed: () => Navigator.pushNamed(context, '/turno-form'),
                      )
                    : ListView.builder(
                        itemCount: appState.turnosFiltrados.length,
                        itemBuilder: (context, index) {
                          final turno = appState.turnosFiltrados[index];
                          return ListTile(
                            key: ValueKey(turno.id),
                            leading: CircleAvatar(
                              child: Text(turno.clienteNombre.isNotEmpty ? turno.clienteNombre[0] : '?'),
                            ),
                            title: Text(turno.clienteNombre),
                            subtitle: Text('${turno.servicioNombre} · ${DateFormat('dd/MM/yyyy HH:mm').format(turno.fechaHora)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Semantics(
                                  label: 'Marcar ${turno.clienteNombre} como favorito',
                                  child: IconButton(
                                    icon: Icon(
                                      appState.clientes.any((c) => c.id == turno.clienteId && c.esFavorito)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: appState.clientes.any((c) => c.id == turno.clienteId && c.esFavorito) ? Colors.red : null,
                                    ),
                                    onPressed: () => appState.toggleFavorito(turno.clienteId),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: () => Navigator.pushNamed(context, '/turno-detalle', arguments: turno.id),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}