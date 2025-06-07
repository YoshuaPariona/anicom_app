import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anicom_app/models/product.dart';
import 'package:anicom_app/providers/cart_provider.dart';
import 'package:anicom_app/widgets/cart_item_card_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _saveOrderToFirestore(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe iniciar sesión para realizar un pedido')),
      );
      return;
    }

    final products = cartProvider.items.entries.map((entry) {
      return {
        'nombre': entry.key.nombre,
        'precio': entry.key.precio,
        'cantidad': entry.value,
      };
    }).toList();

    final total = cartProvider.total;

    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .collection('historial')
          .add({
        'fecha': FieldValue.serverTimestamp(),
        'productos': products,
        'total': total,
      });

      // Limpiar el carrito después de guardar el pedido
      cartProvider.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido realizado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al realizar el pedido: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final Map<Product, int> cartItems = cartProvider.items;

    return Scaffold(
      backgroundColor: const Color(0xFFF4DFF4),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems.keys.elementAt(index);
                final quantity = cartItems[product]!;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: CartItemCardWidget(
                    product: product,
                    quantity: quantity,
                    onRemoveFromCart: () {
                      cartProvider.removeProduct(product);
                    },
                    onIncrement: () {
                      cartProvider.addProduct(product);
                    },
                    onDecrement: () {
                      cartProvider.decrementProduct(product);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'S/. ${cartProvider.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveOrderToFirestore(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Comprar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
