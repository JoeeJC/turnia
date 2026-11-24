import 'package:flutter/material.dart';

/// Muestra un diálogo de confirmación de eliminación.
///
/// Req 10: "¿Eliminar '[nombre]'?" con botones Cancelar/Eliminar.
///
/// Devuelve `true` si el usuario confirma la eliminación, `false` si cancela.
Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  required String nombre,
  String tipo = 'elemento',
}) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text('¿Eliminar "$nombre"?'),
        content: Text('Esta acción eliminará el $tipo seleccionado y no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );
  return confirmado == true;
}