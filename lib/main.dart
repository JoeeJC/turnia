import 'package:flutter/material.dart';

// Estado y Repositorios
import '../../state/app_state.dart';

// Tema visual
import 'core/theme/../../core/theme/theme.dart';

// Modelos necesarios para argumentos de navegación
import 'models/turno.dart';

// Pantallas del sistema
import 'ui/screens/splash_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/registro_screen.dart';
import 'ui/screens/config_inicial_screen.dart';
import 'ui/screens/app_shell.dart';
import 'ui/screens/turno_detail_screen.dart';
import 'ui/screens/servicio_form_screen.dart';
import 'ui/screens/horarios_screen.dart';
import 'ui/screens/cliente_detail_screen.dart';
import 'ui/screens/enlace_screen.dart';
import 'ui/screens/reservas_publicas_screen.dart';
import 'ui/screens/perfil_screen.dart';
import 'ui/screens/config_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TurniaApp());
}

class TurniaApp extends StatefulWidget {
  const TurniaApp({super.key});

  @override
  State<TurniaApp> createState() => _TurniaAppState();
}

class _TurniaAppState extends State<TurniaApp> {
  late final AppState _state;

  @override
  void initState() {
    super.initState();
    _state = AppState();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

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

// ========================================================
// UTILIDADES DE FORMATO REUTILIZADAS POR LAS PANTALLAS
// ========================================================

String greetingForHour(int hour) {
  if (hour < 12) return 'Buenos días';
  if (hour < 19) return 'Buenas tardes';
  return 'Buenas noches';
}

const List<String> weekdayShort = [
  'LUN',
  'MAR',
  'MIÉ',
  'JUE',
  'VIE',
  'SÁB',
  'DOM',
];

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

String dayLabel(DateTime d) =>
    '${weekdayLong[d.weekday - 1]} ${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

String shortDayLabel(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

// ========================================================
// ARGUMENTOS DE NAVEGACIÓN
// ========================================================

/// Alias o clase para permitir la navegación hacia el detalle de un turno
class TurnoArgs {
  final Turno appointment;
  const TurnoArgs(this.appointment);
}

// Typedef para compatibilidad si alguna pantalla aún usa el nombre anterior "Appointment"
typedef Appointment = Turno;