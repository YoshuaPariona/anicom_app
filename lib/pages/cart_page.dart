import 'package:anicom_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);

    final items = cart.items;
    return Scaffold(
      
      body: SafeArea(
        child: Column(
  children: [
    // Header

    const SizedBox(height: 10),
    Expanded(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: items.isEmpty
        ? const Center(
            child: Text(
              'Tu carrito está vacío.',
              style: TextStyle(fontSize: 18),
            ),
          )
        : Column(
            children: [
              Expanded(
                child: ListView(
                  children: items.entries.map((entry) {
                    final product = entry.key;
                    final quantity = entry.value;
                    return _CartItem(
                      imageUrl: product.imagen,
                      name: product.nombre,
                      price: product.precio,
                      quantity: quantity,
                      onIncrement: () => cart.addProduct(product),
                      onDecrement: () => cart.removeProduct(product),
                    );
                  }).toList(),
                ),
              ),
              const Spacer(),
              Text("Items total : ${cart.totalItems}"),
              const SizedBox(height: 16),
              const Divider(
                thickness: 1,
                indent: 40,
                endIndent: 40,
                color: Colors.brown,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("TOTAL:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("S/. ${cart.total.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: items.isEmpty
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Compra realizada.')),
                        );
                        cart.clear();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA16759),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Comprar", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 16),
            ],
          ),
  ),
),

  ],
),

      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    super.key,
  });

  String convertDriveLinkToDirect(String driveLink) {
      final regExp = RegExp(r'/d/([a-zA-Z0-9_-]+)');
      final match = regExp.firstMatch(driveLink);
      if (match != null && match.groupCount >= 1) {
        final id = match.group(1);
        return 'https://drive.google.com/uc?export=view&id=$id';
      } else {
        return driveLink;
      }
    }

  @override
  Widget build(BuildContext context) {
    final directImageUrl = convertDriveLinkToDirect(imageUrl);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFFF4DFF4),
      child: ListTile(
        leading: directImageUrl.isNotEmpty
            ? Image.network(
                directImageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
              )
            : const Icon(Icons.image_not_supported),
        title: Text(name),
        subtitle: Text('Precio: S/ ${price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: onDecrement),
            Text('$quantity'),
            IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: onIncrement),
          ],
        ),
      ),
    );
  }
}

