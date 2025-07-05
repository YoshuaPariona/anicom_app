//lib/pages/admin/admin_controller.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminController {
  // Controladores de texto para los campos
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final imagenController = TextEditingController();

  // Colección seleccionada
  String selectedCollection = 'accesorios';

  // ID actual editándose (null si es nuevo)
  String? editingId;

  // Cambia la colección actual
  void setCollection(String collection) {
    selectedCollection = collection;
    limpiarFormulario();
  }

  // Guarda (nuevo o actualiza)
  Future<void> guardarDocumento() async {
    final nombre = nombreController.text.trim();
    final descripcion = descripcionController.text.trim();
    final imagen = imagenController.text.trim();
    final precio = double.tryParse(precioController.text) ?? 0.0;

    if (nombre.isEmpty || descripcion.isEmpty) return;

    final ref = FirebaseFirestore.instance.collection(selectedCollection);

    if (editingId == null) {
      await ref.add({
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'imagen': imagen,
      });
    } else {
      await ref.doc(editingId).update({
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'imagen': imagen,
      });
    }

    limpiarFormulario();
  }

  // Editar: carga los datos al form
  void editarDocumento(Map<String, dynamic> data, String id) {
    nombreController.text = data['nombre'] ?? '';
    descripcionController.text = data['descripcion'] ?? '';
    precioController.text = (data['precio'] ?? '').toString();
    imagenController.text = data['imagen'] ?? '';
    editingId = id;
  }

  // Eliminar
  Future<void> eliminarDocumento(String id) async {
    await FirebaseFirestore.instance.collection(selectedCollection).doc(id).delete();
  }

  // Limpiar formulario
  void limpiarFormulario() {
    nombreController.clear();
    descripcionController.clear();
    precioController.clear();
    imagenController.clear();
    editingId = null;
  }
}
