/// Modelos de dominio de Turnia App.
///
/// Todas las clases implementan [copyWith], [toJson] y [fromJson] para
/// facilitar la inmutabilidad, la serialización a JSON y el uso con
/// SharedPreferences / APIs.

library;

import 'package:intl/intl.dart';

/// Estado de un turno de belleza/estética.
enum EstadoTurno {
  pendiente,
  confirmado,
  completado,
  cancelado;

  /// Etiqueta legible para mostrar en la UI.
  String get label {
    switch (this) {
      case EstadoTurno.pendiente:
        return 'Pendiente';
      case EstadoTurno.confirmado:
        return 'Confirmado';
      case EstadoTurno.completado:
        return 'Completado';
      case EstadoTurno.cancelado:
        return 'Cancelado';
    }
  }

  /// Color hexadecimal asociado al estado (para chips, badges, etc.).
  String get color {
    switch (this) {
      case EstadoTurno.pendiente:
        return '#F59E0B'; // amber
      case EstadoTurno.confirmado:
        return '#3B82F6'; // blue
      case EstadoTurno.completado:
        return '#10B981'; // emerald
      case EstadoTurno.cancelado:
        return '#EF4444'; // red
    }
  }

  /// Convierte un String JSON al enum. Valor por defecto: [pendiente].
  EstadoTurno fromJson(String json) {
    switch (json) {
      case 'confirmado':
        return EstadoTurno.confirmado;
      case 'completado':
        return EstadoTurno.completado;
      case 'cancelado':
        return EstadoTurno.cancelado;
      default:
        return EstadoTurno.pendiente;
    }
  }

  /// Serializa el enum a su nombre en String (JSON).
  String toJson() => name;
}

/// Usuario del sistema (cliente o empleado).
class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String? telefono;
  final String? passwordHash;
  final DateTime? createdAt;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    this.passwordHash,
    this.createdAt,
  });

  Usuario copyWith({
    String? id,
    String? nombre,
    String? email,
    String? telefono,
    String? passwordHash,
    DateTime? createdAt,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'passwordHash': passwordHash,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      passwordHash: json['passwordHash'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

/// Servicio ofrecido por el salón de belleza.
class Servicio {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int duracionMin;
  final bool activo;

  Servicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.duracionMin,
    this.activo = true,
  });

  Servicio copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    double? precio,
    int? duracionMin,
    bool? activo,
  }) {
    return Servicio(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      duracionMin: duracionMin ?? this.duracionMin,
      activo: activo ?? this.activo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'duracionMin': duracionMin,
      'activo': activo,
    };
  }

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      precio: (json['precio'] as num).toDouble(),
      duracionMin: json['duracionMin'] as int,
      activo: json['activo'] as bool? ?? true,
    );
  }
}

/// Cliente del salón de belleza.
class Cliente {
  final String id;
  final String nombre;
  final String telefono;
  final String email;
  final bool esFavorito;
  final String iniciales;

  Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.email,
    this.esFavorito = false,
    String? iniciales,
  }) : iniciales = iniciales ?? _calcularIniciales(nombre);

  static String _calcularIniciales(String nombre) {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty) return '';
    if (partes.length == 1) return partes[0].substring(0, 1).toUpperCase();
    return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
  }

  Cliente copyWith({
    String? id,
    String? nombre,
    String? telefono,
    String? email,
    bool? esFavorito,
    String? iniciales,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      esFavorito: esFavorito ?? this.esFavorito,
      iniciales: iniciales ?? this.iniciales,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'esFavorito': esFavorito,
      'iniciales': iniciales,
    };
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      telefono: json['telefono'] as String,
      email: json['email'] as String,
      esFavorito: json['esFavorito'] as bool? ?? false,
      iniciales: json['iniciales'] as String?,
    );
  }
}

/// Turno agendado para un cliente y un servicio.
class Turno {
  final String id;
  final String clienteId;
  final String clienteNombre;
  final String clienteTelefono;
  final String servicioNombre;
  final double precio;
  final DateTime fechaHora;
  final int duracionMin;
  final EstadoTurno estado;
  final String? notas;

  /// Etiqueta con la hora formateada (ej. "10:30 AM").
  final String horaLabel;

  /// Etiqueta con el precio formateado (ej. "$25.00").
  final String precioLabel;

  Turno({
    required this.id,
    required this.clienteId,
    required this.clienteNombre,
    required this.clienteTelefono,
    required this.servicioNombre,
    required this.precio,
    required this.fechaHora,
    required this.duracionMin,
    this.estado = EstadoTurno.pendiente,
    this.notas,
    String? horaLabel,
    String? precioLabel,
  })  : horaLabel = horaLabel ?? _formatoHora(fechaHora),
        precioLabel = precioLabel ?? _formatoPrecio(precio);

  static String _formatoHora(DateTime fecha) {
    return DateFormat('hh:mm a').format(fecha);
  }

  static String _formatoPrecio(double precio) {
    return '\$${precio.toStringAsFixed(2)}';
  }

  Turno copyWith({
    String? id,
    String? clienteId,
    String? clienteNombre,
    String? clienteTelefono,
    String? servicioNombre,
    double? precio,
    DateTime? fechaHora,
    int? duracionMin,
    EstadoTurno? estado,
    String? notas,
    String? horaLabel,
    String? precioLabel,
  }) {
    return Turno(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      clienteTelefono: clienteTelefono ?? this.clienteTelefono,
      servicioNombre: servicioNombre ?? this.servicioNombre,
      precio: precio ?? this.precio,
      fechaHora: fechaHora ?? this.fechaHora,
      duracionMin: duracionMin ?? this.duracionMin,
      estado: estado ?? this.estado,
      notas: notas ?? this.notas,
      horaLabel: horaLabel ?? this.horaLabel,
      precioLabel: precioLabel ?? this.precioLabel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clienteId': clienteId,
      'clienteNombre': clienteNombre,
      'clienteTelefono': clienteTelefono,
      'servicioNombre': servicioNombre,
      'precio': precio,
      'fechaHora': fechaHora.toIso8601String(),
      'duracionMin': duracionMin,
      'estado': estado.toJson(),
      'notas': notas,
      'horaLabel': horaLabel,
      'precioLabel': precioLabel,
    };
  }

  factory Turno.fromJson(Map<String, dynamic> json) {
    final estadoEnum = EstadoTurno.values.firstWhere(
      (e) => e.name == (json['estado'] as String? ?? 'pendiente'),
      orElse: () => EstadoTurno.pendiente,
    );
    return Turno(
      id: json['id'] as String,
      clienteId: json['clienteId'] as String,
      clienteNombre: json['clienteNombre'] as String,
      clienteTelefono: json['clienteTelefono'] as String,
      servicioNombre: json['servicioNombre'] as String,
      precio: (json['precio'] as num).toDouble(),
      fechaHora: DateTime.parse(json['fechaHora'] as String),
      duracionMin: json['duracionMin'] as int,
      estado: estadoEnum,
      notas: json['notas'] as String?,
      horaLabel: json['horaLabel'] as String?,
      precioLabel: json['precioLabel'] as String?,
    );
  }
}