import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnia_app/core/utils/app_notifications.dart';
import 'package:turnia_app/core/utils/validators.dart';
import 'package:turnia_app/models/models.dart';
import 'package:turnia_app/state/app_state.dart';

/// Pantalla formulario de turno (Alta y Edición).
///
/// Req 8, 9, 15.
class TurnoFormScreen extends StatefulWidget {
  final Turno? turnoExistente;
  const TurnoFormScreen({super.key, this.turnoExistente});

  @override
  State<TurnoFormScreen> createState() => _TurnoFormScreenState();
}

class _TurnoFormScreenState extends State<TurnoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clienteNombreController = TextEditingController();
  final _clienteTelefonoController = TextEditingController();
  final _servicioNombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _notasController = TextEditingController();
  DateTime _fechaHora = DateTime.now();
  int _duracionMin = 30;
  EstadoTurno _estado = EstadoTurno.pendiente;
  bool _cargando = false;

  Turno? _turnoOriginal;

  @override
  void initState() {
    super.initState();
    if (widget.turnoExistente != null) {
      _turnoOriginal = widget.turnoExistente;
      _clienteNombreController.text = widget.turnoExistente!.clienteNombre;
      _clienteTelefonoController.text = widget.turnoExistente!.clienteTelefono;
      _servicioNombreController.text = widget.turnoExistente!.servicioNombre;
      _precioController.text = widget.turnoExistente!.precio.toStringAsFixed(2);
      _notasController.text = widget.turnoExistente!.notas ?? '';
      _fechaHora = widget.turnoExistente!.fechaHora;
      _duracionMin = widget.turnoExistente!.duracionMin;
      _estado = widget.turnoExistente!.estado;
    }
  }

  @override
  void dispose() {
    _clienteNombreController.dispose();
    _clienteTelefonoController.dispose();
    _servicioNombreController.dispose();
    _precioController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  bool get _esEdicion => widget.turnoExistente != null;

  bool get _tieneCambiosSinGuardar {
    if (_turnoOriginal == null) return false;
    return _clienteNombreController.text != _turnoOriginal!.clienteNombre ||
        _clienteTelefonoController.text != _turnoOriginal!.clienteTelefono ||
        _servicioNombreController.text != _turnoOriginal!.servicioNombre ||
        _precioController.text != _turnoOriginal!.precio.toStringAsFixed(2) ||
        _notasController.text != (_turnoOriginal!.notas ?? '') ||
        _fechaHora != _turnoOriginal!.fechaHora ||
        _duracionMin != _turnoOriginal!.duracionMin ||
        _estado != _turnoOriginal!.estado;
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _cargando = true);

    final turno = Turno(
      id: _turnoOriginal?.id ?? '',
      clienteId: _turnoOriginal?.clienteId ?? 'c1',
      clienteNombre: _clienteNombreController.text.trim(),
      clienteTelefono: _clienteTelefonoController.text.trim(),
      servicioNombre: _servicioNombreController.text.trim(),
      precio: double.tryParse(_precioController.text) ?? 0,
      fechaHora: _fechaHora,
      duracionMin: _duracionMin,
      estado: _estado,
      notas: _notasController.text.trim().isEmpty ? null : _notasController.text.trim(),
    );

    final appState = context.read<AppState>();
    final exito = _esEdicion
        ? await appState.actualizarTurno(turno)
        : await appState.crearTurno(turno);

    if (!mounted) return;
    setState(() => _cargando = false);

    if (exito) {
      AppNotifications.success(
        context,
        message: _esEdicion ? 'Turno actualizado' : 'Turno creado',
      );
      Navigator.pop(context);
    } else {
      AppNotifications.error(
        context,
        message: 'No se pudo guardar el turno. Intenta nuevamente.',
        actionLabel: 'Reintentar',
        onAction: () => _guardar(),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (!_tieneCambiosSinGuardar) return true;
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Salir sin guardar?'),
        content: const Text('Hay cambios sin guardar. ¿Deseas salir de todos modos?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sí')),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic _) async {
        if (!didPop) {
          final puedeSalir = await _onWillPop();
          if (puedeSalir && context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_esEdicion ? 'Editar turno' : 'Nuevo turno')),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Text(
                  _esEdicion ? 'Editando: ${widget.turnoExistente!.clienteNombre}' : 'Nuevo turno',
                  style: tema.textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _clienteNombreController,
                  validator: validateName,
                  decoration: const InputDecoration(labelText: 'Nombre del cliente', prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _clienteTelefonoController,
                  keyboardType: TextInputType.phone,
                  validator: validatePhone,
                  decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _servicioNombreController,
                  validator: validateName,
                  decoration: const InputDecoration(labelText: 'Servicio', prefixIcon: Icon(Icons.menu_book)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _precioController,
                  keyboardType: TextInputType.number,
                  validator: validatePrice,
                  decoration: const InputDecoration(labelText: 'Precio', prefixIcon: Icon(Icons.attach_money)),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Fecha y hora'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final fecha = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: _fechaHora,
                      );
                      if (fecha == null) return;
                      if (!context.mounted) return;
                      final hora = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_fechaHora),
                      );
                      if (!mounted) return;
                      if (hora != null) {
                        setState(() => _fechaHora = DateTime(fecha.year, fecha.month, fecha.day, hora.hour, hora.minute));
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: _duracionMin,
                  items: [30, 45, 60, 90].map((d) => DropdownMenuItem(value: d, child: Text('$d min'))).toList(),
                  onChanged: (v) => setState(() => _duracionMin = v ?? 30),
                  decoration: const InputDecoration(labelText: 'Duración (min)'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<EstadoTurno>(
                  initialValue: _estado,
                  items: EstadoTurno.values.map((e) => DropdownMenuItem(value: e, child: Text(e.label))).toList(),
                  onChanged: (v) => setState(() => _estado = v ?? EstadoTurno.pendiente),
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notasController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Notas (opcional)', prefixIcon: Icon(Icons.note)),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: _cargando ? null : _guardar,
                    child: _cargando
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Guardar turno'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}