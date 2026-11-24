import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Claves de persistencia en SharedPreferences.
abstract class _PrefKeys {
  static const String sessionToken = 'turnia_session_token';
  static const String usuario = 'turnia_usuario';
  static const String perfil = 'turnia_perfil';
  static const String turnos = 'turnia_turnos';
  static const String clientes = 'turnia_clientes';
  static const String servicios = 'turnia_servicios';
  static const String favoritos = 'turnia_favoritos';
  static const String modoOscuro = 'turnia_modo_oscuro';
  static const String formato24h = 'turnia_formato_24h';
  static const String modoOffline = 'turnia_modo_offline';
}

/// Wrapper sobre SharedPreferences para guardar y leer objetos en JSON.
///
/// Soporta: sesión/token, usuario, perfil, turnos, clientes, servicios,
/// favoritos, modo oscuro, formato 24h y modo offline simulado.
class LocalStorageService {
  LocalStorageService._();
  static final LocalStorageService instance = LocalStorageService._();

  SharedPreferences? _prefs;

  /// Inicializa la instancia de SharedPreferences.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    if (_prefs == null) {
      throw StateError(
        'LocalStorageService no inicializado. Llame a init() primero.',
      );
    }
    return _prefs!;
  }

  // -----------------------------------------------------------------------
  // Sesión / token
  // -----------------------------------------------------------------------
  Future<bool> saveSessionToken(String token) async =>
      await _p.setString(_PrefKeys.sessionToken, token);

  String? getSessionToken() => _p.getString(_PrefKeys.sessionToken);

  Future<bool> clearSession() async => await _p.remove(_PrefKeys.sessionToken);

  // -----------------------------------------------------------------------
  // Usuario / perfil (JSON)
  // -----------------------------------------------------------------------
  Future<bool> saveUsuario(Map<String, dynamic> usuario) async =>
      await _p.setString(_PrefKeys.usuario, jsonEncode(usuario));

  Map<String, dynamic>? getUsuario() {
    final s = _p.getString(_PrefKeys.usuario);
    return s != null ? jsonDecode(s) as Map<String, dynamic> : null;
  }

  Future<bool> savePerfil(Map<String, dynamic> perfil) async =>
      await _p.setString(_PrefKeys.perfil, jsonEncode(perfil));

  Map<String, dynamic>? getPerfil() {
    final s = _p.getString(_PrefKeys.perfil);
    return s != null ? jsonDecode(s) as Map<String, dynamic> : null;
  }

  // -----------------------------------------------------------------------
  // Listas JSON genéricas (turnos, clientes, servicios, favoritos)
  // -----------------------------------------------------------------------
  Future<bool> saveList(String key, List<Map<String, dynamic>> items) async =>
      await _p.setString(key, jsonEncode(items));

  List<Map<String, dynamic>> getList(String key) {
    final s = _p.getString(key);
    if (s == null) return [];
    final decoded = jsonDecode(s) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  // Turnos
  Future<bool> saveTurnos(List<Map<String, dynamic>> turnos) =>
      saveList(_PrefKeys.turnos, turnos);
  List<Map<String, dynamic>> getTurnos() => getList(_PrefKeys.turnos);

  // Clientes
  Future<bool> saveClientes(List<Map<String, dynamic>> clientes) =>
      saveList(_PrefKeys.clientes, clientes);
  List<Map<String, dynamic>> getClientes() => getList(_PrefKeys.clientes);

  // Servicios
  Future<bool> saveServicios(List<Map<String, dynamic>> servicios) =>
      saveList(_PrefKeys.servicios, servicios);
  List<Map<String, dynamic>> getServicios() => getList(_PrefKeys.servicios);

  // Favoritos (IDs de clientes favoritos)
  Future<bool> saveFavoritos(List<String> favoritos) async =>
      await _p.setStringList(_PrefKeys.favoritos, favoritos);
  List<String> getFavoritos() =>
      _p.getStringList(_PrefKeys.favoritos) ?? [];

  // -----------------------------------------------------------------------
  // Ajustes de UI
  // -----------------------------------------------------------------------
  Future<bool> saveModoOscuro(bool value) async =>
      await _p.setBool(_PrefKeys.modoOscuro, value);
  bool getModoOscuro() => _p.getBool(_PrefKeys.modoOscuro) ?? false;

  Future<bool> saveFormato24h(bool value) async =>
      await _p.setBool(_PrefKeys.formato24h, value);
  bool getFormato24h() => _p.getBool(_PrefKeys.formato24h) ?? true;

  // -----------------------------------------------------------------------
  // Modo offline simulado
  // -----------------------------------------------------------------------
  Future<bool> saveModoOffline(bool value) async =>
      await _p.setBool(_PrefKeys.modoOffline, value);
  bool getModoOffline() => _p.getBool(_PrefKeys.modoOffline) ?? false;

  /// Limpia toda la persistencia (útil para tests / logout completo).
  Future<bool> clearAll() async => await _p.clear();
}