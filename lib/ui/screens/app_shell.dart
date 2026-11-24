import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnia_app/core/theme/app_theme.dart';
import 'package:turnia_app/models/models.dart';
import 'package:turnia_app/state/app_state.dart';
import 'package:turnia_app/ui/screens/ajustes_perfil_screen.dart';
import 'package:turnia_app/ui/screens/auth/splash_screen.dart';
import 'package:turnia_app/ui/screens/auth/login_screen.dart';
import 'package:turnia_app/ui/screens/auth/registro_screen.dart';
import 'package:turnia_app/ui/screens/auth/recuperar_screen.dart';
import 'package:turnia_app/ui/screens/cliente_form_screen.dart';
import 'package:turnia_app/ui/screens/dashboard_screen.dart';
import 'package:turnia_app/ui/screens/agenda_screen.dart';
import 'package:turnia_app/ui/screens/favoritos_screen.dart';
import 'package:turnia_app/ui/screens/turno_detalle_screen.dart';
import 'package:turnia_app/ui/screens/turno_form_screen.dart';

/// Shell principal con navegación por pestañas inferior.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _indiceSeleccionado = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          body: IndexedStack(
            index: _indiceSeleccionado,
            children: [
              DashboardScreen(),
              AgendaScreen(),
              FavoritosScreen(),
              AjustesPerfilScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _indiceSeleccionado,
            onTap: (i) => setState(() => _indiceSeleccionado = i),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
            ],
          ),
          floatingActionButton: _indiceSeleccionado == 1
              ? FloatingActionButton(
                  heroTag: 'shell-add-turno',
                  onPressed: () => Navigator.pushNamed(context, '/turno-form'),
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}

/// Ruta de configuración de la aplicación con todas las rutas nombradas.
class TurniaAppRouter extends StatelessWidget {
  const TurniaAppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Turnia App',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/splash',
          onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/registro':
            return MaterialPageRoute(builder: (_) => const RegistroScreen());
          case '/recuperar':
            return MaterialPageRoute(builder: (_) => const RecuperarScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const AppShell());
          case '/turno-detalle':
            final id = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (_) => TurnoDetalleScreen(id: id ?? ''),
            );
          case '/turno-form':
            final turno = settings.arguments as Turno?;
            return MaterialPageRoute(
              builder: (_) => TurnoFormScreen(turnoExistente: turno),
            );
          case '/favoritos':
            return MaterialPageRoute(builder: (_) => const FavoritosScreen());
          case '/perfil':
            return MaterialPageRoute(builder: (_) => const AjustesPerfilScreen());
          case '/cliente-form':
            return MaterialPageRoute(builder: (_) => const ClienteFormScreen());
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  },
);
}
}