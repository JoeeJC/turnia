import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets.dart';

/// Pantalla 13 · Compartir mi enlace con QR ficticio.
class EnlaceScreen extends StatelessWidget {
  const EnlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final url = state.profile.shareUrl;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Compartir mi enlace'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          AppCard(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 26),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: Brand.brandGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.share_rounded, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 16),
                const Text('Tu página de reservas',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                const Text(
                  'Compartila en tus redes y tus clientas reservan solas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Brand.inkSoft, fontSize: 13.5),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
                  decoration: BoxDecoration(
                    color: Brand.bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Brand.line),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          url,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, color: Brand.violet, fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 20),
                        color: Brand.violet,
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: 'https://$url'));
                          if (context.mounted) {
                            showToast(context, 'Enlace copiado al portapapeles');
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FakeQr(data: url),
                const SizedBox(height: 10),
                const Text('Escaneá para abrir la página',
                    style: TextStyle(color: Brand.inkSoft, fontSize: 12.5)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () => showToast(context, 'Abriendo opciones para compartir…',
                icon: Icons.share_rounded),
            icon: const Icon(Icons.ios_share_rounded),
            label: const Text('Compartir'),
          ),
          const SizedBox(height: 12),
          GhostButton(
            label: 'Ver página',
            icon: Icons.open_in_new_rounded,
            onPressed: () => Navigator.of(context).pushNamed('/reservas'),
          ),
        ],
      ),
    );
  }
}