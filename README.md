# Turnia · Prototipo en Flutter

App de gestión de turnos para profesionales de la belleza (manicura, peluquería, barbería, estética).
Este es un **prototipo navegable** con datos mock en memoria: todas las pantallas están conectadas y se puede recorrer el flujo completo.

## Pantallas incluidas

**🔐 Acceso**
1. Splash con logo
2. Login (email + contraseña)
3. Registro (nombre, email, contraseña, tipo de servicio)
4. Configuración inicial (nombre del negocio, logo, descripción, dirección/modalidad)

**🏠 Gestión del profesional**
5. Dashboard / Inicio (saludo, turnos de hoy, accesos rápidos)
6. Agenda (selector de semana + slots libres/ocupados)
7. Detalle del turno (confirmar / reprogramar / cancelar)
8. Servicios (lista con precio y duración)
9. Crear / editar servicio
10. Horarios de atención (por día, con apertura/cierre)

**👥 Clientes y reservas**
11. Clientes (lista con buscador)
12. Detalle del cliente (teléfono, próximo turno, historial)
13. Compartir mi enlace (copia, compartir, QR ficticio)
- Página pública de reservas (`turnia.app/sofia-manicura`)

**⚙️ Cuenta**
14. Perfil del profesional
15. Configuración (notificaciones, horarios, datos, cambiar contraseña, cerrar sesión)

## Navegación

```
              Dashboard
             /    |     \
        Agenda  Servicios  Clientes
          |         |          |
       Turno    Editar       Cliente

       Perfil ─── Configuración
          |
      Mi enlace ──► Página pública de reservas
```

- Barra inferior con 4 tabs: **Inicio · Agenda · Servicios · Clientes**.
- Desde el Dashboard el avatar lleva al **Perfil**, y "Compartir mi enlace" lleva a la página pública.

## Estructura

```
lib/
├── main.dart                 # App + rutas + helpers de formato
├── models.dart               # Modelos (Service, Client, Appointment, DaySchedule, BusinessProfile)
├── app_state.dart            # Estado global en memoria (AppState + AppScope) y datos mock
├── theme.dart                # Paleta de marca y ThemeData (con modo oscuro)
├── widgets.dart              # Widgets compartidos (avatar, tarjetas, badges, QR ficticio)
├── appointment_tile.dart     # Fila de turno reutilizable
└── screens/
    ├── splash_screen.dart
    ├── login_screen.dart
    ├── registro_screen.dart
    ├── config_inicial_screen.dart
    ├── app_shell.dart        # Navegación inferior
    ├── dashboard_screen.dart
    ├── agenda_screen.dart
    ├── turno_detail_screen.dart
    ├── servicios_screen.dart
    ├── servicio_form_screen.dart
    ├── horarios_screen.dart
    ├── clientes_screen.dart
    ├── cliente_detail_screen.dart
    ├── enlace_screen.dart
    ├── reservas_publicas_screen.dart
    ├── perfil_screen.dart
    └── config_screen.dart
```

## Cómo correrlo

Requiere el **Flutter SDK** instalado (Dart >= 3.6). En esta máquina todavía no está instalado, así que los pasos son:

1. Instalar Flutter: https://docs.flutter.dev/get-started/install
2. Desde la carpeta del proyecto:

```bash
flutter pub get
flutter run
```

Para correr en el navegador sin emulador:

```bash
flutter run -d chrome
```

Para verificar que compila:

```bash
flutter analyze
flutter test
```

## Notas

- Todos los datos son mock y viven en memoria (`AppState`), no hay backend.
- La imagen/logo usa iniciales como placeholder (no requiere assets).
- El código QR de la pantalla de enlace es decorativo y se genera de forma determinista.
- El modo oscuro está disponible desde Configuración.