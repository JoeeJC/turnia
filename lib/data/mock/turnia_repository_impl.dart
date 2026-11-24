import 'package:turnia_app/data/local/local_storage_service.dart';
import 'package:turnia_app/data/repositories/turnia_repository.dart';
import 'package:turnia_app/models/models.dart';

class TurniaRepositoryImpl implements TurniaRepository {
  TurniaRepositoryImpl({
    LocalStorageService? localStorage,
  }) : _local = localStorage ?? LocalStorageService.instance;

  final LocalStorageService _local;

  static const Duration _delay = Duration(milliseconds: 250);

  static final List<Cliente> _clientesSemilla = [
    Cliente(id: 'c1', nombre: 'María González', telefono: '2611234567', email: 'maria@example.com', esFavorito: true),
    Cliente(id: 'c2', nombre: 'Juan Pérez', telefono: '2612345678', email: 'juan@example.com'),
    Cliente(id: 'c3', nombre: 'Lucía Fernández', telefono: '2613456789', email: 'lucia@example.com', esFavorito: true),
    Cliente(id: 'c4', nombre: 'Carlos Ruiz', telefono: '2614567890', email: 'carlos@example.com'),
    Cliente(id: 'c5', nombre: 'Sofía Martínez', telefono: '2615678901', email: 'sofia@example.com'),
    Cliente(id: 'c6', nombre: 'Andrés Gómez', telefono: '2616789012', email: 'andres@example.com'),
    Cliente(id: 'c7', nombre: 'Valeria López', telefono: '2617890123', email: 'valeria@example.com', esFavorito: true),
    Cliente(id: 'c8', nombre: 'Diego Silva', telefono: '2618901234', email: 'diego@example.com'),
  ];

  static final List<Servicio> _serviciosSemilla = [
    Servicio(id: 's1', nombre: 'Manicure', descripcion: 'Cuidado y esmaltado de uñas de manos', precio: 2500, duracionMin: 45),
    Servicio(id: 's2', nombre: 'Pedicure', descripcion: 'Cuidado y esmaltado de uñas de pies', precio: 3000, duracionMin: 50),
    Servicio(id: 's3', nombre: 'Depilación Cejas', descripcion: 'Diseño y depilación de cejas', precio: 2000, duracionMin: 30),
    Servicio(id: 's4', nombre: 'Limpieza Facial', descripcion: 'Limpieza profunda de cutis', precio: 5000, duracionMin: 60),
    Servicio(id: 's5', nombre: 'Masaje Relajante', descripcion: 'Masaje corporal relajante 60 min', precio: 7000, duracionMin: 60),
  ];


  Future<void> _ensureSeedData() async {
    final clientes = _local.getClientes();
    if (clientes.isEmpty) {
      await _local.saveClientes(
        _clientesSemilla.map((c) => c.toJson()).toList(),
      );
    }

    final servicios = _local.getServicios();
    if (servicios.isEmpty) {
      await _local.saveServicios(
        _serviciosSemilla.map((s) => s.toJson()).toList(),
      );
    }

    final turnos = _local.getTurnos();
    if (turnos.isEmpty) {
      await _local.saveTurnos(_generarTurnosSimulados(105));
    }
  }

  List<Map<String, dynamic>> _generarTurnosSimulados(int cantidad) {
    final random = _seededRandom(42);
    final ahora = DateTime.now();
    final estados = EstadoTurno.values;
    final serviciosNombres =
        _serviciosSemilla.map((s) => s.nombre).toList();
    final clientesNombres = _clientesSemilla.map((c) => c.nombre).toList();
    final clientesTelefonos = _clientesSemilla.map((c) => c.telefono).toList();

    final List<Map<String, dynamic>> resultado = [];
    for (int i = 0; i < cantidad; i++) {
      final diaOffset = random() * 14 + 1;
      final hora = 9 + (random() * 9).toInt();
      final minuto = (random() * 12).toInt() * 5;
      final fecha = DateTime(
        ahora.year,
        ahora.month,
        ahora.day + diaOffset.toInt(),
        hora,
        minuto,
      );
      final idxServicio = (random() * serviciosNombres.length).toInt();
      final idxCliente = (random() * clientesNombres.length).toInt();
      final precios = [2500, 3000, 2000, 5000, 7000];
      final duraciones = [45, 50, 30, 60, 60];
      final precio = precios[idxServicio].toDouble();
      final duracion = duraciones[idxServicio];
      final estado = estados[(random() * estados.length).toInt()];

      final turno = Turno(
        id: 't${i + 1}',
        clienteId: 'c${idxCliente + 1}',
        clienteNombre: clientesNombres[idxCliente],
        clienteTelefono: clientesTelefonos[idxCliente],
        servicioNombre: serviciosNombres[idxServicio],
        precio: precio,
        fechaHora: fecha,
        duracionMin: duracion,
        estado: estado,
        notas: estado == EstadoTurno.confirmado
            ? 'Cliente confirma asistencia'
            : null,
      );
      resultado.add(turno.toJson());
    }
    return resultado;
  }

  static double Function() _seededRandom(int seed) {
    var value = seed.toDouble();
    return () {
      value = (value * 1103515245 + 12345) % (1 << 31);
      return (value / (1 << 31));
    };
  }

  Future<T> _delayed<T>(Future<T> Function() action) async {
    await Future.delayed(_delay);
    return action();
  }

  @override
  Future<Map<String, dynamic>?> getSession() => _delayed(() async {
        await _ensureSeedData();
        final token = _local.getSessionToken();
        if (token == null) return null;
        final usuario = _local.getUsuario();
        return {'token': token, 'usuario': usuario};
      });

  @override
  Future<Map<String, dynamic>> login(String email, String password) =>
      _delayed(() async {
        await _ensureSeedData();
        await _local.saveSessionToken('mock_token_$email');
        final usuario = {
          'id': 'u1',
          'nombre': 'Usuario Demo',
          'email': email,
        };
        await _local.saveUsuario(usuario);
        return {'token': 'mock_token_$email', 'usuario': usuario};
      });

  @override
  Future<Map<String, dynamic>> register(
    String nombre,
    String email,
    String password,
  ) =>
      _delayed(() async {
        await _ensureSeedData();
        await _local.saveSessionToken('mock_token_$email');
        final usuario = {
          'id': 'u2',
          'nombre': nombre,
          'email': email,
        };
        await _local.saveUsuario(usuario);
        return {'token': 'mock_token_$email', 'usuario': usuario};
      });

  @override
  Future<Map<String, dynamic>> recoverPassword(String email) =>
      _delayed(() async {
        await _ensureSeedData();
        return {'email': email, 'resetLink': 'mock_reset_link'};
      });

  @override
  Future<void> logout() => _delayed(() async {
        await _local.clearSession();
      });

  @override
  Future<List<Turno>> getTurnos() => _delayed(() async {
        await _ensureSeedData();
        if (_local.getModoOffline()) {
          return _local.getTurnos().map(Turno.fromJson).toList();
        }
        try {
          return _local.getTurnos().map(Turno.fromJson).toList();
        } catch (e) {
          return _local.getTurnos().map(Turno.fromJson).toList();
        }
      });

  @override
  Future<Turno> getTurnoById(String id) => _delayed(() async {
        await _ensureSeedData();
        final turnos = await getTurnos();
        final turno = turnos.firstWhere(
          (t) => t.id == id,
          orElse: () => throw Exception('Turno no encontrado: $id'),
        );
        return turno;
      });

  @override
  Future<Turno> crearTurno(Turno turno) => _delayed(() async {
        await _ensureSeedData();
        final lista = _local.getTurnos();
        final nuevo = turno.copyWith(
          id: 't${DateTime.now().millisecondsSinceEpoch}',
        );
        lista.add(nuevo.toJson());
        await _local.saveTurnos(lista);
        return nuevo;
      });

  @override
  Future<Turno> actualizarTurno(Turno turno) => _delayed(() async {
        await _ensureSeedData();
        final lista = _local.getTurnos();
        final idx = lista.indexWhere((t) => t['id'] == turno.id);
        if (idx == -1) {
          throw Exception('Turno no encontrado para actualizar: ${turno.id}');
        }
        lista[idx] = turno.toJson();
        await _local.saveTurnos(lista);
        return turno;
      });

  @override
  Future<void> eliminarTurno(String id) => _delayed(() async {
        await _ensureSeedData();
        final lista = _local.getTurnos();
        lista.removeWhere((t) => t['id'] == id);
        await _local.saveTurnos(lista);
      });

  @override
  Future<List<Cliente>> getClientes() => _delayed(() async {
        await _ensureSeedData();
        if (_local.getModoOffline()) {
          return _local.getClientes().map(Cliente.fromJson).toList();
        }
        return _local.getClientes().map(Cliente.fromJson).toList();
      });

  @override
  Future<Cliente> crearCliente(Cliente cliente) => _delayed(() async {
        await _ensureSeedData();
        final lista = _local.getClientes();
        final existe = lista.any(
          (c) =>
              (c['telefono'] as String?) == cliente.telefono ||
              (c['email'] as String?) == cliente.email,
        );
        if (existe) {
          throw Exception(
            'Ya existe un cliente con ese teléfono o email',
          );
        }
        final nuevo = cliente.copyWith(
          id: 'c${DateTime.now().millisecondsSinceEpoch}',
        );
        lista.add(nuevo.toJson());
        await _local.saveClientes(lista);
        return nuevo;
      });

  @override
  Future<Cliente> actualizarCliente(Cliente cliente) => _delayed(() async {
        await _ensureSeedData();
        final lista = _local.getClientes();
        final idx = lista.indexWhere((c) => c['id'] == cliente.id);
        if (idx == -1) {
          throw Exception('Cliente no encontrado para actualizar: ${cliente.id}');
        }
        final conflicto = lista.any(
          (c) =>
              c['id'] != cliente.id &&
              ((c['telefono'] as String?) == cliente.telefono ||
                  (c['email'] as String?) == cliente.email),
        );
        if (conflicto) {
          throw Exception(
            'Conflicto: otro cliente ya usa ese teléfono o email',
          );
        }
        lista[idx] = cliente.toJson();
        await _local.saveClientes(lista);
        return cliente;
      });

  @override
  Future<void> eliminarCliente(String id) => _delayed(() async {
        await _ensureSeedData();
        final lista = _local.getClientes();
        lista.removeWhere((c) => c['id'] == id);
        await _local.saveClientes(lista);
      });

  @override
  Future<List<Servicio>> getServicios() => _delayed(() async {
        await _ensureSeedData();
        if (_local.getModoOffline()) {
          return _local.getServicios().map(Servicio.fromJson).toList();
        }
        return _local.getServicios().map(Servicio.fromJson).toList();
      });

  @override
  Future<Servicio> crearServicio(Servicio servicio) => _delayed(() async {
        await _ensureSeedData();
        final lista = _local.getServicios();
        final nuevo = servicio.copyWith(
          id: 's${DateTime.now().millisecondsSinceEpoch}',
        );
        lista.add(nuevo.toJson());
        await _local.saveServicios(lista);
        return nuevo;
      });

  @override
  Future<Servicio> actualizarServicio(Servicio servicio) => _delayed(() async {
        await _ensureSeedData();
        final lista = _local.getServicios();
        final idx = lista.indexWhere((s) => s['id'] == servicio.id);
        if (idx == -1) {
          throw Exception('Servicio no encontrado para actualizar: ${servicio.id}');
        }
        lista[idx] = servicio.toJson();
        await _local.saveServicios(lista);
        return servicio;
      });

  @override
  Future<void> eliminarServicio(String id) => _delayed(() async {
        await _ensureSeedData();
        final lista = _local.getServicios();
        lista.removeWhere((s) => s['id'] == id);
        await _local.saveServicios(lista);
      });

  @override
  Future<List<Cliente>> getClientesFavoritos() => _delayed(() async {
        await _ensureSeedData();
        final todos = await getClientes();
        final favoritosIds = _local.getFavoritos();
        return todos.where((c) => favoritosIds.contains(c.id)).toList();
      });

  @override
  Future<void> toggleFavorito(String id) => _delayed(() async {
        await _ensureSeedData();
        final favoritos = _local.getFavoritos().toSet();
        if (favoritos.contains(id)) {
          favoritos.remove(id);
        } else {
          favoritos.add(id);
        }
        await _local.saveFavoritos(favoritos.toList());
      });
}