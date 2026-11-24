import 'dart:convert';

import 'package:http/http.dart' as http;

/// DTO con el clima actual devuelto por Open-Meteo.
class ClimaActual {
  final double temperatura;
  final double vientoKmH;
  final int direccionViento;
  final int codigoClima;
  final DateTime fechaHora;

  ClimaActual({
    required this.temperatura,
    required this.vientoKmH,
    required this.direccionViento,
    required this.codigoClima,
    required this.fechaHora,
  });

  factory ClimaActual.fromJson(Map<String, dynamic> json) {
    final current = json['current_weather'] as Map<String, dynamic>;
    return ClimaActual(
      temperatura: (current['temperature'] as num).toDouble(),
      vientoKmH: (current['windspeed'] as num).toDouble(),
      direccionViento: current['winddirection'] as int,
      codigoClima: current['weathercode'] as int,
      fechaHora: DateTime.parse(current['time'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperatura': temperatura,
      'vientoKmH': vientoKmH,
      'direccionViento': direccionViento,
      'codigoClima': codigoClima,
      'fechaHora': fechaHora.toIso8601String(),
    };
  }
}

/// Servicio para consumir la API pública gratuita de Open-Meteo sin API key.
/// Endpoint: https://api.open-meteo.com/v1/forecast (Req 14).
class ExternalApiService {
  ExternalApiService() : _client = http.Client();

  static final ExternalApiService instance = ExternalApiService();

  /// Coordenadas de Mendoza (ejemplo de salón).
  static const double _lat = -32.89;
  static const double _lon = -68.84;
  static const String _baseUrl =
      'https://api.open-meteo.com/v1/forecast';

  /// Si es true, la próxima llamada a [obtenerClimaActual] lanzará una
  /// excepción simulada para probar el manejo de errores.
  bool forzarError = false;

  final http.Client _client;

  ExternalApiService.withClient(this._client);

  /// Coordenadas de Mendoza (ejemplo de salón).

  /// Obtiene el clima actual mapeado a [ClimaActual].
  ///
  /// - Timeout de 6 segundos.
  /// - try/catch para errores de red/JSON.
  /// - Logs sin PII (no se envían ni registran datos personales).
  Future<ClimaActual> obtenerClimaActual() async {
    if (forzarError) {
      forzarError = false;
      throw Exception('Error simulado: API externa no disponible');
    }

    final uri = Uri.parse(
      '$_baseUrl?latitude=$_lat&longitude=$_lon&current_weather=true',
    );

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 6),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Error HTTP ${response.statusCode} al obtener clima',
        );
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      return ClimaActual.fromJson(data);
    } on FormatException {
      rethrow; // JSON inválido
    } on http.ClientException {
      rethrow; // Error de red
    } catch (e) {
      // Log sin PII: solo se registra el tipo de error, no datos de usuario.
      throw Exception('Error inesperado al consultar clima: $e');
    }
  }
}