import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFirebase extends StatefulWidget {
  const ProductFirebase({super.key});

  @override
  State<ProductFirebase> createState() => _ProductFirebaseState();
}

class _ProductFirebaseState extends State<ProductFirebase> {
  List<Map<String, dynamic>> productos = [];

  final List<String> colecciones = [
    'comida',
    'ropa',
    'accesorios',
    'figuras',
    'cosplay',
  ];

  @override
  void initState() {
    super.initState();
    obtenerTodosLosProductos();
  }

  Future<void> obtenerTodosLosProductos() async {
    try {
      List<Map<String, dynamic>> todosLosProductos = [];

      for (String coleccion in colecciones) {
        final snapshot =
            await FirebaseFirestore.instance.collection(coleccion).get();

        final productosDeColeccion = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'categoria': coleccion,
            ...doc.data(),
          };
        }).toList();

        todosLosProductos.addAll(productosDeColeccion);
      }

      setState(() {
        productos = todosLosProductos;
      });
    } catch (e) {
      print('Error al obtener productos: $e');
    }
  }

  String convertirEnlaceDriveADirecto(String enlaceDrive) {
    final regExp = RegExp(r'/d/([a-zA-Z0-9_-]+)');
    final match = regExp.firstMatch(enlaceDrive);
    if (match != null && match.groupCount >= 1) {
      final id = match.group(1);
      return 'https://drive.google.com/uc?export=view&id=$id';
    } else {
      return enlaceDrive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Productos')),
      body: productos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                final urlImagenOriginal = producto['imagen'] as String? ?? '';
                final urlImagenDirecta = convertirEnlaceDriveADirecto(urlImagenOriginal);
                return ListTile(
                  leading: urlImagenOriginal.isNotEmpty
                      ? Image.network(
                          urlImagenDirecta,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(producto['nombre'] ?? 'Sin nombre'),
                  subtitle: Text('Precio: S/ ${producto['precio'] ?? '0.00'}\nCategoría: ${producto['categoria']}'),
                  trailing: Text('ID: ${producto['id']}'),
                );
              },
            ),
    );
  }
}
