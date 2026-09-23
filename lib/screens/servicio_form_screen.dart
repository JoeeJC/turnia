import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// Pantalla 9 · Crear / editar servicio.
class ServicioFormScreen extends StatefulWidget {
  const ServicioFormScreen({super.key});

  @override
  State<ServicioFormScreen> createState() => _ServicioFormScreenState();
}

class _ServicioFormScreenState extends State<ServicioFormScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _durCtrl = TextEditingController();

  Service? _editing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String && _editing == null) {
      final state = AppScope.of(context);
      final idx = state.services.indexWhere((s) => s.id == arg);
      if (idx >= 0) {
        _editing = state.services[idx];
        _nameCtrl.text = _editing!.name;
        _descCtrl.text = _editing!.description;
        _priceCtrl.text = _editing!.price.toString();
        _durCtrl.text = _editing!.durationMin.toString();
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _durCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final state = AppScope.of(context);
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      showToast(context, 'Poné un nombre al servicio', icon: Icons.error_outline_rounded);
      return;
    }
    final price = int.tryParse(_priceCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final dur = int.tryParse(_durCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 60;

    if (_editing == null) {
      state.addService(Service(
        id: 's${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: _descCtrl.text.trim(),
        price: price,
        durationMin: dur,
      ));
    } else {
      state.updateService(
        _editing!.id,
        name: name,
        description: _descCtrl.text.trim(),
        price: price,
        durationMin: dur,
      );
    }
    Navigator.of(context).pop();
    showToast(context, _editing == null ? 'Servicio creado' : 'Servicio actualizado');
  }

  void _delete() {
    final state = AppScope.of(context);
    if (_editing == null) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Eliminar servicio?',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Se quita "${_editing!.name}" de tu lista.',
                style: const TextStyle(color: Brand.inkSoft)),
            const SizedBox(height: 22),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Brand.danger),
              onPressed: () {
                state.removeService(_editing!.id);
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
                showToast(context, 'Servicio eliminado', icon: Icons.delete_outline_rounded);
              },
              child: const Text('Sí, eliminar'),
            ),
            const SizedBox(height: 10),
            GhostButton(label: 'Volver', onPressed: () => Navigator.of(ctx).pop()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _editing != null;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(isEdit ? 'Editar servicio' : 'Nuevo servicio'),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Brand.danger),
              onPressed: _delete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          const FieldLabel('Nombre'),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(hintText: 'Manicura semipermanente'),
          ),
          const SizedBox(height: 18),
          const FieldLabel('Descripción'),
          TextField(
            controller: _descCtrl,
            maxLines: 2,
            decoration: const InputDecoration(hintText: 'Esmaltado de larga duración'),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FieldLabel('Precio'),
                    TextField(
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '\$15.000'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FieldLabel('Duración (min)'),
                    TextField(
                      controller: _durCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '60'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const FieldLabel('Foto'),
          AppCard(
            onTap: () => showToast(context, 'Selector de imagen (demo)'),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Brand.violet.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.image_outlined, color: Brand.violet),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Agregar foto', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 2),
                      Text('Se muestra en tu página de reservas',
                          style: TextStyle(color: Brand.inkSoft, fontSize: 12.5)),
                    ],
                  ),
                ),
                const Icon(Icons.upload_rounded, color: Brand.violet),
              ],
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _save,
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}