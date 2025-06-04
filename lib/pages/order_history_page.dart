import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const OrderHistoryScreen({
    super.key,
    this.title = 'Historial de Pedidos', // título opcional
    this.icon = Icons.construction, // icono opcional
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            '$title (en desarrollo)',
            style: const TextStyle(fontSize: 24, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
