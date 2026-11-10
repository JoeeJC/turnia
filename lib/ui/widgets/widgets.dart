import 'package:flutter/material.dart';
import '../../core/theme/../../core/theme/theme.dart';

/// Avatar circular con iniciales sobre un color derivado.
class InitialsAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color? color;
  final VoidCallback? onTap;

  const InitialsAvatar({
    super.key,
    required this.initials,
    this.size = 44,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? Brand.violet;
    final content = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bg, Color.lerp(bg, Colors.black, 0.22)!],
        ),
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
        ),
      ),
    );
    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }
}

/// Tarjeta contenedora con estilo consistente.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: color ?? (dark ? const Color(0xFF1B1A26) : Colors.white),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Etiqueta de estado (confirmado / pendiente / cancelado).
class StateBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StateBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

/// Botón secundario con borde.
class GhostButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;

  const GhostButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Brand.violet;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        foregroundColor: c,
        side: BorderSide(color: c.withValues(alpha: 0.4), width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Encabezado de sección con título y acción opcional.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 22, 4, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: const TextStyle(
                  color: Brand.violet,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Fila de etiqueta + valor.
class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: Brand.inkSoft),
      ),
    );
  }
}

/// Muestra un SnackBar breve con estilo de marca.
void showToast(BuildContext context, String message, {IconData icon = Icons.check_circle_rounded}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Brand.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
}

/// Genera un cuadro tipo QR ficticio a partir de un texto (determinista).
class FakeQr extends StatelessWidget {
  final String data;
  final double size;
  const FakeQr({super.key, required this.data, this.size = 150});

  @override
  Widget build(BuildContext context) {
    final hash = data.codeUnits.fold<int>(5381, (p, c) => (p * 33) ^ c);
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Brand.line, width: 1.5),
      ),
      child: CustomPaint(
        painter: _QrPainter(seed: hash),
        size: Size.square(size - 20),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  final int seed;
  _QrPainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    const n = 21;
    final cell = size.width / n;
    final paint = Paint()..color = Brand.ink;

    bool isFinder(int r, int c) {
      bool inBox(int r0, int c0) => r >= r0 && r < r0 + 7 && c >= c0 && c < c0 + 7;
      return inBox(0, 0) || inBox(0, n - 7) || inBox(n - 7, 0);
    }

    bool finderOn(int r, int c) {
      int lr = r, lc = c;
      if (r >= n - 7) lr = r - (n - 7);
      if (c >= n - 7) lc = c - (n - 7);
      final ring = lr == 0 || lr == 6 || lc == 0 || lc == 6;
      final core = lr >= 2 && lr <= 4 && lc >= 2 && lc <= 4;
      return ring || core;
    }

    int state = seed;
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        bool on;
        if (isFinder(r, c)) {
          on = finderOn(r, c);
        } else {
          state = (state * 1103515245 + 12345) & 0x7fffffff;
          on = (state >> 8) % 2 == 0;
        }
        if (on) {
          canvas.drawRect(
            Rect.fromLTWH(c * cell, r * cell, cell * 0.92, cell * 0.92),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) => oldDelegate.seed != seed;
}