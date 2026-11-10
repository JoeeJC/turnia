import 'package:flutter/material.dart';
import 'models.dart';

/// Estado global de la app (mock, en memoria).
class AppState extends ChangeNotifier {
  // ── Sesión ──────────────────────────────────────────────────────────
  bool loggedIn = false;
  ServiceType serviceType = ServiceType.manicura;

  // ── Perfil / negocio ────────────────────────────────────────────────
  final BusinessProfile profile = BusinessProfile(
    ownerName: 'Sofía Ramírez',
    businessName: 'Sofía Manicura',
    description: 'Uñas y belleza de manos en Palermo ✨',
    address: 'Av. Santa Fe 1234, CABA',
  );

  // ── Preferencias ────────────────────────────────────────────────────
  bool notifications = true;
  bool darkMode = false;

  // ── Servicios ───────────────────────────────────────────────────────
  final List<Service> services = [
    Service(
      id: 's1',
      name: 'Manicura semipermanente',
      description: 'Esmaltado de larga duración',
      price: 15000,
      durationMin: 60,
    ),
    Service(
      id: 's2',
      name: 'Kapping',
      description: 'Refuerzo con gel sobre uña natural',
      price: 18000,
      durationMin: 90,
    ),
  ];

  // ── Clientes ────────────────────────────────────────────────────────
  final List<Client> clients = [
    Client(
      id: 'c1',
      name: 'Ana Martínez',
      phone: '+54 9 11 5555-1234',
      email: 'ana@mail.com',
      totalTurnos: 8,
      totalFacturado: 182000,
      nextTurno: DateTime(2026, 9, 15),
    ),
    Client(
      id: 'c2',
      name: 'Laura Gómez',
      phone: '+54 9 11 5555-5678',
      email: 'laura@mail.com',
      totalTurnos: 5,
      totalFacturado: 96000,
      nextTurno: DateTime(2026, 9, 15),
    ),
    Client(
      id: 'c3',
      name: 'Carla Pérez',
      phone: '+54 9 11 5555-9012',
      email: 'carla@mail.com',
      totalTurnos: 3,
      totalFacturado: 54000,
      nextTurno: DateTime(2026, 9, 16),
    ),
  ];

  // ── Agenda (turnos) ─────────────────────────────────────────────────
  final List<Appointment> appointments = [
    Appointment(
      id: 'a1',
      clientName: 'Ana Martínez',
      serviceName: 'Manicura',
      date: DateTime(2026, 9, 15),
      startMinutes: 10 * 60,
      durationMin: 60,
      price: 15000,
      state: TurnoState.confirmado,
    ),
    Appointment(
      id: 'a2',
      clientName: 'Laura Gómez',
      serviceName: 'Kapping',
      date: DateTime(2026, 9, 15),
      startMinutes: 11 * 60 + 30,
      durationMin: 90,
      price: 18000,
      state: TurnoState.pendiente,
    ),
    Appointment(
      id: 'a3',
      clientName: 'Carla Pérez',
      serviceName: 'Manicura',
      date: DateTime(2026, 9, 15),
      startMinutes: 14 * 60,
      durationMin: 60,
      price: 15000,
      state: TurnoState.confirmado,
    ),
    Appointment(
      id: 'a4',
      clientName: 'Ana Martínez',
      serviceName: 'Manicura',
      date: DateTime(2026, 9, 15),
      startMinutes: 16 * 60,
      durationMin: 60,
      price: 15000,
      state: TurnoState.confirmado,
    ),
    Appointment(
      id: 'a5',
      clientName: 'Laura Gómez',
      serviceName: 'Kapping',
      date: DateTime(2026, 9, 15),
      startMinutes: 17 * 60,
      durationMin: 60,
      price: 18000,
      state: TurnoState.confirmado,
    ),
    // Otros días de la semana
    Appointment(
      id: 'a6',
      clientName: 'Carla Pérez',
      serviceName: 'Kapping',
      date: DateTime(2026, 9, 16),
      startMinutes: 9 * 60 + 30,
      durationMin: 90,
      price: 18000,
      state: TurnoState.confirmado,
    ),
    Appointment(
      id: 'a7',
      clientName: 'Ana Martínez',
      serviceName: 'Manicura',
      date: DateTime(2026, 9, 17),
      startMinutes: 15 * 60,
      durationMin: 60,
      price: 15000,
      state: TurnoState.pendiente,
    ),
    Appointment(
      id: 'a8',
      clientName: 'Laura Gómez',
      serviceName: 'Manicura',
      date: DateTime(2026, 9, 18),
      startMinutes: 11 * 60,
      durationMin: 60,
      price: 15000,
      state: TurnoState.confirmado,
    ),
    // Historial pasado
    Appointment(
      id: 'h1',
      clientName: 'Ana Martínez',
      serviceName: 'Manicura',
      date: DateTime(2026, 9, 1),
      startMinutes: 10 * 60,
      durationMin: 60,
      price: 15000,
      state: TurnoState.confirmado,
    ),
    Appointment(
      id: 'h2',
      clientName: 'Ana Martínez',
      serviceName: 'Kapping',
      date: DateTime(2026, 8, 20),
      startMinutes: 16 * 60,
      durationMin: 90,
      price: 18000,
      state: TurnoState.confirmado,
    ),
  ];

  // ── Horarios de atención ────────────────────────────────────────────
  final List<DaySchedule> schedules = [
    DaySchedule(dayName: 'Lunes', active: true, openMinutes: 9 * 60, closeMinutes: 18 * 60),
    DaySchedule(dayName: 'Martes', active: true, openMinutes: 9 * 60, closeMinutes: 18 * 60),
    DaySchedule(dayName: 'Miércoles', active: true, openMinutes: 9 * 60, closeMinutes: 13 * 60),
    DaySchedule(dayName: 'Jueves', active: true, openMinutes: 9 * 60, closeMinutes: 18 * 60),
    DaySchedule(dayName: 'Viernes', active: true, openMinutes: 9 * 60, closeMinutes: 18 * 60),
    DaySchedule(dayName: 'Sábado'),
    DaySchedule(dayName: 'Domingo'),
  ];

  // ── Selección de semana en Agenda ───────────────────────────────────
  DateTime weekStart = DateTime(2026, 9, 14); // lunes
  DateTime selectedDay = DateTime(2026, 9, 15);

  // ── Selección en la página pública de reservas ──────────────────────
  Service? publicSelectedService;
  int? publicSelectedSlot;

  // ── Auth ────────────────────────────────────────────────────────────
  void login() {
    loggedIn = true;
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }

  void setServiceType(ServiceType t) {
    serviceType = t;
    notifyListeners();
  }

  void setProfile({
    String? businessName,
    String? description,
    String? address,
    AttentionMode? mode,
  }) {
    if (businessName != null && businessName.trim().isNotEmpty) {
      profile.businessName = businessName.trim();
    }
    if (description != null) profile.description = description;
    if (address != null) profile.address = address;
    if (mode != null) profile.mode = mode;
    notifyListeners();
  }

  // ── Servicios CRUD ──────────────────────────────────────────────────
  void addService(Service s) {
    services.add(s);
    notifyListeners();
  }

  void updateService(String id, {String? name, String? description, int? price, int? durationMin}) {
    final idx = services.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    final s = services[idx];
    if (name != null) s.name = name;
    if (description != null) s.description = description;
    if (price != null) s.price = price;
    if (durationMin != null) s.durationMin = durationMin;
    notifyListeners();
  }

  void removeService(String id) {
    services.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ── Turnos ──────────────────────────────────────────────────────────
  void setTurnoState(String id, TurnoState state) {
    final idx = appointments.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    appointments[idx].state = state;
    notifyListeners();
  }

  List<Appointment> appointmentsFor(DateTime day) {
    return appointments
        .where((a) => a.date.year == day.year && a.date.month == day.month && a.date.day == day.day)
        .toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
  }

  List<Appointment> get todayAppointments =>
      appointmentsFor(DateTime(2026, 9, 15)); // fecha "hoy" del mock

  List<Appointment> historyFor(String clientName) {
    return appointments
        .where((a) => a.clientName == clientName && a.date.isBefore(DateTime(2026, 9, 10)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // ── Semana ──────────────────────────────────────────────────────────
  void shiftWeek(int delta) {
    weekStart = weekStart.add(Duration(days: 7 * delta));
    selectedDay = weekStart;
    notifyListeners();
  }

  void selectDay(DateTime day) {
    selectedDay = day;
    notifyListeners();
  }

  // ── Toggles ─────────────────────────────────────────────────────────
  void toggleSchedule(int index, bool value) {
    schedules[index].active = value;
    notifyListeners();
  }

  void setNotifications(bool v) {
    notifications = v;
    notifyListeners();
  }

  void setDarkMode(bool v) {
    darkMode = v;
    notifyListeners();
  }

  // ── Página pública ──────────────────────────────────────────────────
  void selectPublicService(Service? s) {
    publicSelectedService = s;
    publicSelectedSlot = null;
    notifyListeners();
  }

  void selectPublicSlot(int? slot) {
    publicSelectedSlot = slot;
    notifyListeners();
  }

  // ── Pestaña activa del shell ────────────────────────────────────────
  int shellTab = 0;

  void setShellTab(int i) {
    if (shellTab == i) return;
    shellTab = i;
    notifyListeners();
  }

  /// Slots libres del día seleccionado en la página pública.
  List<int> availableSlotsFor(DateTime day) {
    if (publicSelectedService == null) return [];
    // Busca el horario del día
    final weekday = day.weekday; // 1 = lunes
    final schedule = schedules[weekday - 1];
    if (!schedule.active) return [];
    final dur = publicSelectedService!.durationMin;
    final taken = appointmentsFor(day);
    final slots = <int>[];
    for (int m = schedule.openMinutes; m + dur <= schedule.closeMinutes; m += 30) {
      final overlaps = taken.any((a) => m < a.startMinutes + a.durationMin && m + dur > a.startMinutes);
      if (!overlaps) slots.add(m);
    }
    return slots;
  }
}

/// Provee el AppState a todo el árbol de widgets.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope no encontrado en el contexto');
    return scope!.notifier!;
  }
}