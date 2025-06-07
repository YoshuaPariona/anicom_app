import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anicom_app/models/product.dart';
import 'package:anicom_app/providers/cart_provider.dart';
import 'package:anicom_app/widgets/cart_item_card_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
                  padding: const EdgeInsets.only(bottom: 16.0), // Espacio debajo de cada Card
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
                    onPressed: () {
                      // Lógica para proceder a la compra
                    },
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
