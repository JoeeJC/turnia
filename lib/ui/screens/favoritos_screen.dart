import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnia_app/state/app_state.dart';
import 'package:turnia_app/ui/widgets/empty_state.dart';

/// Pantalla Favoritos: clientes y turnos favoritos.
///
/// Req 12.
class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final favoritos = appState.clientes.where((c) => c.esFavorito).toList();
        return Scaffold(
          appBar: AppBar(title: const Text('Favoritos')),
          body: favoritos.isEmpty
              ? EmptyState(
                  icon: Icons.favorite_border,
                  title: 'No tienes clientes favoritos',
                  subtitle: 'Marca clientes como favoritos desde la Agenda.',
                  ctaLabel: 'Ver clientes',
                  onCtaPressed: () => Navigator.pushNamed(context, '/home'),
                )
              : ListView.builder(
                  itemCount: favoritos.length,
                  itemBuilder: (context, index) {
                    final cliente = favoritos[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(cliente.iniciales),
                      ),
                      title: Text(cliente.nombre),
                      subtitle: Text(cliente.telefono),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.person_remove_outlined),
                            onPressed: () => appState.toggleFavorito(cliente.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => Navigator.pushNamed(context, '/cliente-form', arguments: cliente.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'favoritos-add-turno',
            onPressed: () => Navigator.pushNamed(context, '/turno-form'),
            icon: const Icon(Icons.add),
            label: const Text('Nuevo turno'),
          ),
        );
      },
    );
  }
}