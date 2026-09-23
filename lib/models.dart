import 'package:flutter/material.dart';

/// Tipo de servicio que ofrece el profesional (onboarding).
enum ServiceType { manicura, peluqueria, barberia, estetica, otro }

extension ServiceTypeLabel on ServiceType {
  String get label {
    switch (this) {
      case ServiceType.manicura:
        return 'Manicura';
      case ServiceType.peluqueria:
        return 'Peluquería';
      case ServiceType.barberia:
        return 'Barbería';
      case ServiceType.estetica:
        return 'Estética';
      case ServiceType.otro:
        return 'Otro';
    }
  }
}

/// Modalidad de atención del negocio.
enum AttentionMode { local, domicilio, ambos }

extension AttentionModeLabel on AttentionMode {
  String get label {
    switch (this) {
      case AttentionMode.local:
        return 'En local';
      case AttentionMode.domicilio:
        return 'A domicilio';
      case AttentionMode.ambos:
        return 'Ambos';
    }
  }
}

/// Estado de un turno.
enum TurnoState { confirmado, pendiente, cancelado }

extension TurnoStateX on TurnoState {
  String get label {
    switch (this) {
      case TurnoState.confirmado:
        return 'Confirmado';
      case TurnoState.pendiente:
        return 'Pendiente';
      case TurnoState.cancelado:
        return 'Cancelado';
    }
  }

  Color get color {
    switch (this) {
      case TurnoState.confirmado:
        return const Color(0xFF16A34A);
      case TurnoState.pendiente:
        return const Color(0xFFF59E0B);
      case TurnoState.cancelado:
        return const Color(0xFFEF4444);
    }
  }
}

/// Servicio ofrecido por el profesional.
class Service {
  final String id;
  String name;
  String description;
  int price;
  int durationMin;
  String? photoUrl;

  Service({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    required this.durationMin,
    this.photoUrl,
  });

  String get priceLabel => formatMoney(price);
}

/// Formatea un entero como $15.000
String formatMoney(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '\$${buf.toString()}';
}

/// Convierte minutos desde 00:00 a formato HH:mm
String hhmm(int minutes) {
  final h = (minutes ~/ 60) % 24;
  final m = minutes % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

/// Cliente del profesional.
class Client {
  final String id;
  final String name;
  final String phone;
  final String email;
  final int totalTurnos;
  final int totalFacturado;
  final DateTime? nextTurno;

  Client({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.totalTurnos = 0,
    this.totalFacturado = 0,
    this.nextTurno,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

/// Un turno agendado.
class Appointment {
  final String id;
  final String clientName;
  final String serviceName;
  final DateTime date;
  final int startMinutes; // minutos desde 00:00
  final int durationMin;
  final int price;
  TurnoState state;

  Appointment({
    required this.id,
    required this.clientName,
    required this.serviceName,
    required this.date,
    required this.startMinutes,
    required this.durationMin,
    required this.price,
    this.state = TurnoState.pendiente,
  });

  String get clientInitials {
    final parts = clientName.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) return clientName.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  String get timeLabel => '${hhmm(startMinutes)} - ${hhmm(startMinutes + durationMin)}';
  String get startLabel => hhmm(startMinutes);
  String get priceLabel => formatMoney(price);
}

/// Horario de atención de un día de la semana.
class DaySchedule {
  final String dayName;
  bool active;
  int openMinutes;
  int closeMinutes;

  DaySchedule({
    required this.dayName,
    this.active = false,
    this.openMinutes = 9 * 60,
    this.closeMinutes = 18 * 60,
  });

  String get rangeLabel => active ? '${hhmm(openMinutes)} - ${hhmm(closeMinutes)}' : 'Cerrado';
}

/// Datos del profesional / negocio.
class BusinessProfile {
  final String ownerName;
  String businessName;
  String description;
  String address;
  String phone;
  String email;
  String slug;
  AttentionMode mode;

  BusinessProfile({
    required this.ownerName,
    required this.businessName,
    this.description = '',
    this.address = '',
    this.phone = '+54 9 11 5555-1234',
    this.email = 'sofia@mail.com',
    this.slug = 'sofia-manicura',
    this.mode = AttentionMode.local,
  });

  String get initials {
    final parts = businessName.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) return businessName.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  String get shareUrl => 'turnia.app/$slug';
}