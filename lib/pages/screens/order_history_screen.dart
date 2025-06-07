import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    final historialRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user?.uid)
        .collection('historial')
        .orderBy('fecha', descending: true);

    return Scaffold(

      body: StreamBuilder<QuerySnapshot>(
        stream: historialRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('No hay pedidos en el historial'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final pedido = docs[index].data() as Map<String, dynamic>;
              final fechaTimestamp = pedido['fecha'] as Timestamp?;
              final fecha = fechaTimestamp != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(fechaTimestamp.toDate())
                  : 'Fecha desconocida';

              final productos = List<Map<String, dynamic>>.from(pedido['productos'] ?? []);
              final total = pedido['total'] ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ExpansionTile(
                  title: Text('Pedido - $fecha'),
                  subtitle: Text('Total: S/ ${total.toStringAsFixed(2)}'),
                  children: productos.map((prod) {
                    final nombre = prod['nombre'] ?? 'Producto';
                    final precio = prod['precio'] is String
                        ? double.tryParse(prod['precio']) ?? 0.0
                        : prod['precio']?.toDouble() ?? 0.0;
                    return ListTile(
                      title: Text(nombre),
                      trailing: Text('S/ ${precio.toStringAsFixed(2)}'),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
