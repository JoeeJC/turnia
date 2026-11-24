import 'package:flutter/material.dart';

/// Tipos de notificación visual para eventos de la app.
enum NotificationType {
  success,
  info,
  warning,
  error,
}

/// Helper centralizado para mostrar SnackBars sin solapamiento.
///
/// Antes de mostrar un nuevo SnackBar se llama a [clearSnackBars] para
/// descartar cualquier mensaje pendiente (Req 15).
class AppNotifications {
  AppNotifications._();

  /// Muestra un SnackBar en [context]. Limpia los previos para evitar
  /// solapamientos. Soporta acción opcional ("Deshacer" o "Ver").
  static void show({
    required BuildContext context,
    required String message,
    NotificationType type = NotificationType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    clearSnackBars(context);

    final color = _colorFor(type);
    final icon = _iconFor(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  /// Descarta todos los SnackBars visibles en [context].
  static void clearSnackBars(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  /// Evento de éxito (ej. turno creado, cambios guardados).
  static void success(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context: context,
      message: message,
      type: NotificationType.success,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Evento informativo genérico.
  static void info(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context: context,
      message: message,
      type: NotificationType.info,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Evento de advertencia (ej. campos incompletos).
  static void warning(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context: context,
      message: message,
      type: NotificationType.warning,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Evento de error (ej. fallo de red, validación crítica).
  static void error(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context: context,
      message: message,
      type: NotificationType.error,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static IconData _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.info:
        return Icons.info;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.error:
        return Icons.error;
    }
  }

  static Color _colorFor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return Colors.red;
    }
  }
}