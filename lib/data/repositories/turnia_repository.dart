import 'package:turnia_app/models/models.dart';

/// Repositorio de dominio de Turnia App.
///
/// Define el contrato de acceso a datos para autenticación, turnos,
/// clientes, servicios y favoritos. Tanto la implementación local
/// (mock) como futuras implementaciones reales deben cumplir esta interfaz.
abstract class TurniaRepository {
  // -----------------------------------------------------------------------
  // Autenticación / sesión
  // -----------------------------------------------------------------------
  Future<Map<String, dynamic>?> getSession();
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(
    String nombre,
    String email,
    String password,
  );
  Future<Map<String, dynamic>> recoverPassword(String email);
  Future<void> logout();

  // -----------------------------------------------------------------------
  // Turnos
  // -----------------------------------------------------------------------
  Future<List<Turno>> getTurnos();
  Future<Turno> getTurnoById(String id);
  Future<Turno> crearTurno(Turno turno);
  Future<Turno> actualizarTurno(Turno turno);
  Future<void> eliminarTurno(String id);

  // -----------------------------------------------------------------------
  // Clientes
  // -----------------------------------------------------------------------
  Future<List<Cliente>> getClientes();
  Future<Cliente> crearCliente(Cliente cliente);
  Future<Cliente> actualizarCliente(Cliente cliente);
  Future<void> eliminarCliente(String id);

  // -----------------------------------------------------------------------
  // Servicios
  // -----------------------------------------------------------------------
  Future<List<Servicio>> getServicios();
  Future<Servicio> crearServicio(Servicio servicio);
  Future<Servicio> actualizarServicio(Servicio servicio);
  Future<void> eliminarServicio(String id);

  // -----------------------------------------------------------------------
  // Favoritos
  // -----------------------------------------------------------------------
  Future<List<Cliente>> getClientesFavoritos();
  Future<void> toggleFavorito(String id);
}