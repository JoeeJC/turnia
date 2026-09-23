import 'package:flutter/material.dart';
import '../app_state.dart';
import '../main.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// Página pública de reservas (la que ven las clientas por el enlace).
class ReservasPublicasScreen extends StatelessWidget {
  const ReservasPublicasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final profile = state.profile;
    final selectedDay = state.selectedDay;
    final slots = state.availableSlotsFor(selectedDay);
    final selService = state.publicSelectedService;
    final selSlot = state.publicSelectedSlot;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: Brand.heroGradient),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 26),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 44,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InitialsAvatar(
                          initials: profile.initials,
                          size: 58,
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.businessName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                profile.description,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _meta('📍 ${profile.address}', Colors.white),
                        _meta('⭐ 4.9 · 128 reseñas', Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SectionHeader(title: 'Elegí un servicio'),
                ...state.services.map((s) {
                  final selected = selService?.id == s.id;
                  final dark = Theme.of(context).brightness == Brightness.dark;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: dark ? const Color(0xFF1B1A26) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => state.selectPublicService(s),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected ? Brand.violet : Colors.transparent,
                              width: 1.8,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: Brand.violet.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.spa_rounded, color: Brand.violet),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(s.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 15)),
                                    const SizedBox(height: 3),
                                    Text('${s.priceLabel} · ${s.durationMin} min',
                                        style: const TextStyle(
                                            color: Brand.inkSoft, fontSize: 13)),
                                  ],
                                ),
                              ),
                              Icon(
                                selected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                color: selected ? Brand.violet : const Color(0xFFB4B1C6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SectionHeader(title: 'Elegí un horario'),
                _WeekStrip(state: state),
                const SizedBox(height: 14),
                if (selService == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 26),
                    child: Center(
                      child: Text('Primero elegí un servicio',
                          style: TextStyle(color: Brand.inkSoft)),
                    ),
                  )
                else if (slots.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 26),
                    child: Center(
                      child: Text('No hay horarios disponibles ese día',
                          style: TextStyle(color: Brand.inkSoft)),
                    ),
                  )
                else
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: slots.map((m) {
                      final selected = selSlot == m;
                      return GestureDetector(
                        onTap: () => state.selectPublicSlot(m),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            color: selected ? Brand.violet : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected ? Brand.violet : Brand.line,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            hhmm(m),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selected ? Colors.white : Brand.ink,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selService != null && selSlot != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    '${selService.name} · ${dayLabel(selectedDay)} · ${hhmm(selSlot)}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                  ),
                ),
              ElevatedButton(
                onPressed: (selService != null && selSlot != null)
                    ? () {
                        showToast(context, '¡Turno reservado! Te contactamos para confirmar.');
                      }
                    : null,
                child: const Text('Reservar turno'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _meta(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  final AppState state;
  const _WeekStrip({required this.state});

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) => state.weekStart.add(Duration(days: i)));
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final d = days[i];
          final isSel = d.day == state.selectedDay.day && d.month == state.selectedDay.month;
          return GestureDetector(
            onTap: () => state.selectDay(d),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 54,
              decoration: BoxDecoration(
                gradient: isSel ? Brand.brandGradient : null,
                color: isSel ? null : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSel ? Colors.transparent : Brand.line, width: 1.4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(weekdayShort[d.weekday - 1],
                      style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: isSel ? Colors.white70 : Brand.inkSoft)),
                  const SizedBox(height: 4),
                  Text('${d.day}',
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: isSel ? Colors.white : Brand.ink)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}