import 'package:flutter/material.dart';
import 'app_state.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registro_screen.dart';
import 'screens/config_inicial_screen.dart';
import 'screens/app_shell.dart';
import 'screens/turno_detail_screen.dart';
import 'screens/servicio_form_screen.dart';
import 'screens/horarios_screen.dart';
import 'screens/cliente_detail_screen.dart';
import 'screens/enlace_screen.dart';
import 'screens/reservas_publicas_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/config_screen.dart';
import 'models.dart';

void main() {
  runApp(const TurniaApp());
}

class TurniaApp extends StatefulWidget {
  const TurniaApp({super.key});

  @override
  State<TurniaApp> createState() => _TurniaAppState();
}

class _TurniaAppState extends State<TurniaApp> {
  final AppState _state = AppState();

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: AnimatedBuilder(
        animation: _state,
        builder: (context, _) {
          return MaterialApp(
            title: 'Turnia',
            debugShowCheckedModeBanner: false,
            theme: buildTheme(dark: _state.darkMode),
            initialRoute: '/',
            routes: {
              '/': (_) => const SplashScreen(),
              '/login': (_) => const LoginScreen(),
              '/registro': (_) => const RegistroScreen(),
              '/config-inicial': (_) => const ConfigInicialScreen(),
              '/app': (_) => const AppShell(),
              '/turno': (_) => const TurnoDetailScreen(),
              '/servicio-form': (_) => const ServicioFormScreen(),
              '/horarios': (_) => const HorariosScreen(),
              '/cliente': (_) => const ClienteDetailScreen(),
              '/enlace': (_) => const EnlaceScreen(),
              '/reservas': (_) => const ReservasPublicasScreen(),
              '/perfil': (_) => const PerfilScreen(),
              '/config': (_) => const ConfigScreen(),
            },
          );
        },
      ),
    );
  }
}

/// Utilidades de formato reutilizadas por las pantallas.
String greetingForHour(int hour) {
  if (hour < 12) return 'Buenos días';
  if (hour < 19) return 'Buenas tardes';
  return 'Buenas noches';
}

const List<String> weekdayShort = ['LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB', 'DOM'];
const List<String> weekdayLong = [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
];
const List<String> monthNames = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];

String dayLabel(DateTime d) => '${weekdayLong[d.weekday - 1]} ${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

String shortDayLabel(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

/// Ruta de navegación hacia un turno concreto.
class TurnoArgs {
  final Appointment appointment;
  const TurnoArgs(this.appointment);
}