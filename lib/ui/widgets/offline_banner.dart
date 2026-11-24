import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnia_app/state/app_state.dart';

/// Banner visible cuando `isOfflineMode` está activo.
///
/// Req 13: "Sin conexión — mostrando datos guardados".
class OfflineBanner extends StatelessWidget {
  final Widget? child;

  const OfflineBanner({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      child: child,
      builder: (context, appState, content) {
        if (!appState.isOfflineMode) {
          return content ?? const SizedBox.shrink();
        }

        final banner = Container(
          width: double.infinity,
          color: Colors.amber,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: const Row(
            children: [
              Icon(Icons.cloud_off, size: 18, color: Colors.black87),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sin conexión — mostrando datos guardados',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );

        if (content == null) return banner;
        return Column(
          children: [banner, Expanded(child: content)],
        );
      },
    );
  }
}