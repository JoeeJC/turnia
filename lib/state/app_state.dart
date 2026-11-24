// ignore_for_file: unused_element

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:turnia_app/data/api/external_api_service.dart';
import 'package:turnia_app/data/local/local_storage_service.dart';
import 'package:turnia_app/data/mock/turnia_repository_impl.dart';
import 'package:turnia_app/data/repositories/turnia_repository.dart';
import 'package:turnia_app/models/models.dart';

/// Gestión de estado global de Turnia App.
///
/// Inyecta [TurniaRepository] y [ExternalApiService], expone el estado de
/// la UI y orquesta las acciones de autenticación, CRUD y configuración.
class AppState extends ChangeNotifier {
  AppState({
    TurniaRepository? repository,
    ExternalApiService? apiService,
    LocalStorageService? localStorage,
  })  : _repository = repository ?? TurniaRepositoryImpl(),
        _api = apiService ?? ExternalApiService.instance,
        _local = localStorage ?? LocalStorageService.instance {
    _local.init();
  }

  // -----------------------------------------------------------------------
  // Dependencias
  // -----------------------------------------------------------------------
  final TurniaRepository _repository;
  final ExternalApiService _api;
  final LocalStorageService _local;

  // -----------------------------------------------------------------------
  // Estado general
  // -----------------------------------------------------------------------
  bool _isLoading = false;
  bool _isWeatherLoading = false;
  String? _weatherError;
  ClimaActual? _climaActual;
  bool _isOfflineMode = false;
  bool _isDarkMode = false;
  bool _use24hFormat = true;
  Map<String, dynamic>? _usuarioActual;

  // -----------------------------------------------------------------------
  // Listas de datos
  // -----------------------------------------------------------------------
  List<Turno> _turnos = [];
  List<Cliente> _clientes = [];
  List<Servicio> _servicios = [];

  // -----------------------------------------------------------------------
  // Búsqueda y filtros
  // -----------------------------------------------------------------------
  String _searchQuery = '';
  EstadoTurno? _estadoFiltro;
  bool _soloFavoritos = false;
  Timer? _debounce;

  // -----------------------------------------------------------------------
  // Getters
  // -----------------------------------------------------------------------
  bool get isLoading => _isLoading;
  bool get isWeatherLoading => _isWeatherLoading;
  String? get weatherError => _weatherError;
  ClimaActual? get climaActual => _climaActual;
  bool get isOfflineMode => _isOfflineMode;
  bool get isDarkMode => _isDarkMode;
  bool get use24hFormat => _use24hFormat;
  Map<String, dynamic>? get usuarioActual => _usuarioActual;

  List<Turno> get turnos => List.unmodifiable(_turnos);
  List<Cliente> get clientes => List.unmodifiable(_clientes);
  List<Servicio> get servicios => List.unmodifiable(_servicios);

  String get searchQuery => _searchQuery;
  EstadoTurno? get estadoFiltro => _estadoFiltro;
  bool get soloFavoritos => _soloFavoritos;

  /// Turnos filtrados por búsqueda, estado y favoritos.
  List<Turno> get turnosFiltrados {
    return _turnos.where((turno) {
      final coincideBusqueda = _searchQuery.isEmpty ||
          turno.clienteNombre.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          turno.servicioNombre.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final coincideEstado =
          _estadoFiltro == null || turno.estado == _estadoFiltro;

      final coincideFavorito =
          !_soloFavoritos || _esFavorito(turno.clienteId);

      return coincideBusqueda && coincideEstado && coincideFavorito;
    }).toList();
  }

  /// Clientes filtrados por búsqueda y favoritos.
  List<Cliente> get clientesFiltrados {
    return _clientes.where((cliente) {
      final coincideBusqueda = _searchQuery.isEmpty ||
          cliente.nombre.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final coincideFavorito =
          !_soloFavoritos || cliente.esFavorito;

      return coincideBusqueda && coincideFavorito;
    }).toList();
  }

  /// Clientes marcados como favoritos.
  List<Cliente> get turnosFavoritos {
    // Nota: a pesar del nombre, devuelve clientes favoritos (según el modelo).
    return _clientes.where((c) => c.esFavorito).toList();
  }

  bool _esFavorito(String clienteId) {
    return _clientes.any((c) => c.id == clienteId && c.esFavorito);
  }

  // -----------------------------------------------------------------------
  // Utilidades de estado
  // -----------------------------------------------------------------------
  void _setLoading(bool valor) {
    _isLoading = valor;
    notifyListeners();
  }

  void _setWeatherLoading(bool valor) {
    _isWeatherLoading = valor;
    notifyListeners();
  }

  void _setWeatherError(String? error) {
    _weatherError = error;
    notifyListeners();
  }

  void _setClimaActual(ClimaActual? clima) {
    _climaActual = clima;
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Configuración de UI (persistida)
  // -----------------------------------------------------------------------
  Future<void> _cargarPreferenciasUI() async {
    _isDarkMode = _local.getModoOscuro();
    _use24hFormat = _local.getFormato24h();
    _isOfflineMode = _local.getModoOffline();
    notifyListeners();
  }

  Future<void> _guardarModoOscuro(bool valor) async {
    _isDarkMode = valor;
    await _local.saveModoOscuro(valor);
    notifyListeners();
  }

  Future<void> _guardarFormato24h(bool valor) async {
    _use24hFormat = valor;
    await _local.saveFormato24h(valor);
    notifyListeners();
  }

  Future<void> _guardarModoOffline(bool valor) async {
    _isOfflineMode = valor;
    await _local.saveModoOffline(valor);
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Búsqueda y filtros (con debounce de 300ms - Req 11)
  // -----------------------------------------------------------------------
  void setSearchQuery(String query) {
    _searchQuery = query;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      notifyListeners();
    });
    notifyListeners();
  }

  void setEstadoFiltro(EstadoTurno? estado) {
    _estadoFiltro = estado;
    notifyListeners();
  }

  void setSoloFavoritos(bool valor) {
    _soloFavoritos = valor;
    notifyListeners();
  }

  void limpiarFiltros() {
    _searchQuery = '';
    _estadoFiltro = null;
    _soloFavoritos = false;
    _debounce?.cancel();
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Inicialización de la app
  // -----------------------------------------------------------------------
  Future<void> initApp() async {
    _setLoading(true);
    try {
      await _cargarPreferenciasUI();

      // Verificar sesión en SharedPreferences (tiempo < 2s)
      final sesion = await _repository.getSession().timeout(
        const Duration(seconds: 2),
      );
      if (sesion != null && sesion['token'] != null) {
        _usuarioActual = sesion['usuario'] as Map<String, dynamic>?;
      }

      // Cargar datos locales
      await _cargarDatos();
    } on TimeoutException {
      // Si la verificación de sesión tarda, continuamos sin sesión
      _usuarioActual = null;
      await _cargarDatos();
    } catch (e) {
      _usuarioActual = null;
      await _cargarDatos();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _cargarDatos() async {
    final turnosF = await _repository.getTurnos();
    final clientesF = await _repository.getClientes();
    final serviciosF = await _repository.getServicios();
    _turnos = turnosF;
    _clientes = clientesF;
    _servicios = serviciosF;
    notifyListeners();

    // Cargar clima (no bloquea la UI principal)
    _cargarClima();
  }

  Future<void> _cargarClima() async {
    _setWeatherLoading(true);
    _setWeatherError(null);
    try {
      final clima = await _api.obtenerClimaActual();
      _setClimaActual(clima);
    } catch (e) {
      _setWeatherError('No se pudo obtener el clima');
      _setClimaActual(null);
    } finally {
      _setWeatherLoading(false);
    }
  }

  // -----------------------------------------------------------------------
  // Autenticación
  // -----------------------------------------------------------------------
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final resultado = await _repository.login(email, password).timeout(
        const Duration(seconds: 10),
      );
      _usuarioActual = resultado['usuario'] as Map<String, dynamic>?;
      await _local.saveSessionToken(resultado['token'] as String);
      await _local.saveUsuario(_usuarioActual!);
      notifyListeners();
      return true;
    } on TimeoutException {
      return false;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(
    String nombre,
    String email,
    String password,
  ) async {
    _setLoading(true);
    try {
      final resultado = await _repository
          .register(nombre, email, password)
          .timeout(const Duration(seconds: 10));
      _usuarioActual = resultado['usuario'] as Map<String, dynamic>?;
      await _local.saveSessionToken(resultado['token'] as String);
      await _local.saveUsuario(_usuarioActual!);
      notifyListeners();
      return true;
    } on TimeoutException {
      return false;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> recoverPassword(String email) async {
    _setLoading(true);
    try {
      await _repository.recoverPassword(email).timeout(
        const Duration(seconds: 10),
      );
      return true;
    } on TimeoutException {
      return false;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> campos) async {
    _setLoading(true);
    try {
      if (_usuarioActual == null) return false;
      final actualizado = {..._usuarioActual!, ...campos};
      _usuarioActual = actualizado;
      await _local.saveUsuario(actualizado);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // -----------------------------------------------------------------------
  // Cierre de sesión (Req 18)
  // -----------------------------------------------------------------------
  Future<void> logout(BuildContext context) async {
    _setLoading(true);
    try {
      await _repository.logout();
      await _local.clearSession();
      _usuarioActual = null;
      _turnos = [];
      _clientes = [];
      _servicios = [];
      _searchQuery = '';
      _estadoFiltro = null;
      _soloFavoritos = false;
      _debounce?.cancel();
      notifyListeners();

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (_) => false,
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  // -----------------------------------------------------------------------
  // CRUD Turnos
  // -----------------------------------------------------------------------
  Future<List<Turno>> cargarTurnos() async {
    _setLoading(true);
    try {
      _turnos = await _repository.getTurnos();
      notifyListeners();
      return _turnos;
    } finally {
      _setLoading(false);
    }
  }

  Future<Turno> obtenerTurnoPorId(String id) async {
    return await _repository.getTurnoById(id);
  }

  Future<bool> crearTurno(Turno turno) async {
    _setLoading(true);
    try {
      final creado = await _repository.crearTurno(turno);
      _turnos.add(creado);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> actualizarTurno(Turno turno) async {
    _setLoading(true);
    try {
      final actualizado = await _repository.actualizarTurno(turno);
      final idx = _turnos.indexWhere((t) => t.id == turno.id);
      if (idx != -1) {
        _turnos[idx] = actualizado;
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> eliminarTurno(String id) async {
    _setLoading(true);
    try {
      await _repository.eliminarTurno(id);
      _turnos.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // -----------------------------------------------------------------------
  // CRUD Clientes
  // -----------------------------------------------------------------------
  Future<List<Cliente>> cargarClientes() async {
    _setLoading(true);
    try {
      _clientes = await _repository.getClientes();
      notifyListeners();
      return _clientes;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> crearCliente(Cliente cliente) async {
    _setLoading(true);
    try {
      final creado = await _repository.crearCliente(cliente);
      _clientes.add(creado);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> actualizarCliente(Cliente cliente) async {
    _setLoading(true);
    try {
      final actualizado = await _repository.actualizarCliente(cliente);
      final idx = _clientes.indexWhere((c) => c.id == cliente.id);
      if (idx != -1) {
        _clientes[idx] = actualizado;
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> eliminarCliente(String id) async {
    _setLoading(true);
    try {
      await _repository.eliminarCliente(id);
      _clientes.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // -----------------------------------------------------------------------
  // CRUD Servicios
  // -----------------------------------------------------------------------
  Future<List<Servicio>> cargarServicios() async {
    _setLoading(true);
    try {
      _servicios = await _repository.getServicios();
      notifyListeners();
      return _servicios;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> crearServicio(Servicio servicio) async {
    _setLoading(true);
    try {
      final creado = await _repository.crearServicio(servicio);
      _servicios.add(creado);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> actualizarServicio(Servicio servicio) async {
    _setLoading(true);
    try {
      final actualizado = await _repository.actualizarServicio(servicio);
      final idx = _servicios.indexWhere((s) => s.id == servicio.id);
      if (idx != -1) {
        _servicios[idx] = actualizado;
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> eliminarServicio(String id) async {
    _setLoading(true);
    try {
      await _repository.eliminarServicio(id);
      _servicios.removeWhere((s) => s.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // -----------------------------------------------------------------------
  // Favoritos y configuración
  // -----------------------------------------------------------------------
  Future<bool> toggleFavorito(String id) async {
    try {
      await _repository.toggleFavorito(id);
      await cargarClientes();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> toggleTheme() async {
    await _guardarModoOscuro(!_isDarkMode);
  }

  Future<void> toggle24hFormat() async {
    await _guardarFormato24h(!_use24hFormat);
  }

  Future<void> toggleOfflineMode() async {
    await _guardarModoOffline(!_isOfflineMode);
  }
}