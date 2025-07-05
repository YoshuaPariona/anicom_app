// lib/pages/admin/admin_form.dart
import 'package:flutter/material.dart';
import 'admin_controller.dart';

class AdminForm extends StatelessWidget {
  final AdminController controller;
  final VoidCallback refresh;

  const AdminForm({
    super.key,
    required this.controller,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4DFF4), // rosa claro
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          SizedBox(
            width: 200,
            child: TextField(
              controller: controller.nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              controller: controller.imagenController,
              decoration: const InputDecoration(labelText: 'URL Imagen'),
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              controller: controller.descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
              maxLines: 2,
            ),
          ),
          SizedBox(
            width: 120,
            child: TextField(
              controller: controller.precioController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8AC5), // rosa más fuerte
            ),
            onPressed: () {
              controller.guardarDocumento();
              refresh();
            },
            child: Text(controller.editingId == null ? 'Agregar' : 'Actualizar'),
          ),
          if (controller.editingId != null)
            TextButton(
              onPressed: () {
                controller.limpiarFormulario();
                refresh();
              },
              child: const Text('Cancelar'),
            ),
        ],
      ),
    );
  }
}
