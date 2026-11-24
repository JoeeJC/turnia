import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:turnia_app/core/utils/app_notifications.dart';
import 'package:turnia_app/models/models.dart';
import 'package:turnia_app/state/app_state.dart';
import 'package:turnia_app/ui/widgets/confirm_delete_dialog.dart';

/// Pantalla de detalle de un turno, recibe `id` por argumentos.
///
/// Req 7, 10, 12, 15.
class TurnoDetalleScreen extends StatelessWidget {
  final String id;
  const TurnoDetalleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return FutureBuilder<Turno>(
          future: appState.obtenerTurnoPorId(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(title: const Text('Turno')),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No encontrado', style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Volver'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final turno = snapshot.data!;
            final esFavorito = appState.clientes.any(
              (c) => c.id == turno.clienteId && c.esFavorito,
            );

            return Scaffold(
              appBar: AppBar(title: const Text('Detalle del turno')),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(turno.clienteNombre, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(turno.servicioNombre, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Text('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(turno.fechaHora)}'),
                    Text('Precio: ${turno.precioLabel}'),
                    Text('Duración: ${turno.duracionMin} min'),
                    Text('Estado: ${turno.estado.label}'),
                    if (turno.notas != null && turno.notas!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text('Notas: ${turno.notas}'),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(esFavorito ? Icons.favorite : Icons.favorite_border, color: esFavorito ? Colors.red : null),
                          onPressed: () => appState.toggleFavorito(turno.clienteId),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () => Navigator.pushNamed(context, '/turno-form', arguments: turno),
                          child: const Text('Editar'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () async {
                            final confirmado = await showConfirmDeleteDialog(
                              context,
                              nombre: turno.clienteNombre,
                              tipo: 'turno',
                            );
                            if (confirmado && context.mounted) {
                              final exito = await appState.eliminarTurno(turno.id);
                              if (exito && context.mounted) {
                                AppNotifications.success(
                                  context,
                                  message: 'Turno eliminado',
                                  actionLabel: 'Deshacer',
                                  onAction: () {},
                                );
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}