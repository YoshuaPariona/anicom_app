import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart'; // Aún necesario si usarás RTDB
import 'package:cloud_firestore/cloud_firestore.dart'; // Necesario para Firestore

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ListaProductos());
  }
}

class ListaProductos extends StatefulWidget {
  const ListaProductos({super.key});

  @override
  State<ListaProductos> createState() => _ListaProductosState();
}

class _ListaProductosState extends State<ListaProductos> {
  List<Map<String, dynamic>> productos = [];

  @override
  void initState() {
    super.initState();
    obtenerProductos();
  }

  Future<void> obtenerProductos() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('productos').get();
      setState(() {
        productos =
            snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
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
      body:
          productos.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  final urlImagenOriginal = producto['imagen'] as String? ?? '';
                  final urlImagenDirecta = convertirEnlaceDriveADirecto(
                    urlImagenOriginal,
                  );
                  return ListTile(
                    leading:
                        urlImagenOriginal.isNotEmpty
                            ? Image.network(
                              urlImagenDirecta,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                            )
                            : const Icon(Icons.image_not_supported),
                    title: Text(producto['nombre'] ?? 'Sin nombre'),
                    subtitle: Text(
                      'Precio: S/ ${producto['precio'] ?? '0.00'}',
                    ),
                    trailing: Text('ID: ${producto['id']}'),
                  );
                },
              ),
    );
  }
}
