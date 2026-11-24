import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnia_app/core/utils/app_notifications.dart';
import 'package:turnia_app/core/utils/validators.dart';
import 'package:turnia_app/state/app_state.dart';
import 'package:turnia_app/ui/widgets/confirm_delete_dialog.dart';

class AjustesPerfilScreen extends StatefulWidget {
  const AjustesPerfilScreen({super.key});

  @override
  State<AjustesPerfilScreen> createState() => _AjustesPerfilScreenState();
}

class _AjustesPerfilScreenState extends State<AjustesPerfilScreen> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  bool _editando = false;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    final usuario = context.read<AppState>().usuarioActual;
    if (usuario != null) {
      _nombreController.text = usuario['nombre'] ?? '';
      _emailController.text = usuario['email'] ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _guardarPerfil() async {
    if (!_nombreController.text.isNotEmpty || !_emailController.text.isNotEmpty) return;
    setState(() => _cargando = true);

    final appState = context.read<AppState>();
    final exito = await appState.updateProfile({
      'nombre': _nombreController.text.trim(),
      'email': _emailController.text.trim(),
    });

    if (!mounted) return;
    setState(() {
      _cargando = false;
      _editando = false;
    });

    if (exito) {
      AppNotifications.success(context, message: 'Perfil guardado');
    } else {
      AppNotifications.error(context, message: 'No se pudo guardar el perfil');
    }
  }

  Future<void> _cerrarSesion() async {
    final confirmado = await showConfirmDeleteDialog(
      context,
      nombre: 'tu sesión',
      tipo: 'sesión',
    );
    if (confirmado && mounted) {
      context.read<AppState>().logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes y Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Perfil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  child: Text(appState.usuarioActual?['nombre']?.isNotEmpty == true
                      ? appState.usuarioActual!['nombre'][0]
                      : '?'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appState.usuarioActual?['nombre'] ?? 'Sin nombre', style: tema.textTheme.titleLarge),
                      Text(appState.usuarioActual?['email'] ?? '', style: tema.textTheme.bodyMedium?.copyWith(color: tema.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(_editando ? Icons.close : Icons.edit),
                  onPressed: () => setState(() => _editando = !_editando),
                ),
              ],
            ),
            if (_editando) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                validator: validateName,
                enabled: _editando,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                validator: validateEmail,
                enabled: _editando,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: _guardarPerfil, child: const Text('Guardar'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextButton(onPressed: () => setState(() => _editando = false), child: const Text('Cancelar'))),
                ],
              ),
            ],
            const SizedBox(height: 32),
            const Text('Apariencia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Modo oscuro'),
              subtitle: const Text('Cambiar entre tema claro y oscuro'),
              trailing: Switch(
                value: appState.isDarkMode,
                onChanged: (_) => appState.toggleTheme(),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Formato 24 horas'),
              subtitle: const Text('Mostrar hora en formato de 24h'),
              trailing: Switch(
                value: appState.use24hFormat,
                onChanged: (_) => appState.toggle24hFormat(),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.cloud_off),
              title: const Text('Modo offline'),
              subtitle: const Text('Simular trabajo sin conexión (usa caché local)'),
              trailing: Switch(
                value: appState.isOfflineMode,
                onChanged: (_) => appState.toggleOfflineMode(),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Sesión', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: _cargando ? null : _cerrarSesion,
                child: const Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}