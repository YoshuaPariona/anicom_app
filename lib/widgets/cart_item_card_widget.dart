import 'package:anicom_app/models/product.dart';
import 'package:flutter/material.dart';

class CartItemCardWidget extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onRemoveFromCart;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemCardWidget({
    super.key,
    required this.product,
    required this.quantity,
    required this.onRemoveFromCart,
    required this.onIncrement,
    required this.onDecrement,
  });

  Widget _buildImage() {
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        convertDriveLinkToDirect(product.imagen),
        width: 120,
        height: 100,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return const SizedBox(
              width: 120,
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            width: 120,
            height: 100,
            child: Icon(Icons.broken_image, size: 50),
          );
        },
        semanticLabel: 'Imagen del producto ${product.nombre}',
      ),
    );
  }

  Widget _buildName() {
    return Text(
      product.nombre,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  Widget _buildPrice() {
    return Text(
      'S/. ${(product.precio * quantity).toStringAsFixed(2)}',
      style: const TextStyle(
        color: Colors.brown,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: quantity > 1 ? onDecrement : onRemoveFromCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: quantity > 1 ? Colors.brown : const Color.fromARGB(255, 244, 98, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(0),
            minimumSize: const Size(40, 30),
          ),
          child: Icon(
            quantity > 1 ? Icons.remove : Icons.delete,
            color: Colors.white,
            size: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onIncrement,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(0),
            minimumSize: const Size(40, 30),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140, // Altura fija para el CartItemCardWidget
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withAlpha((255 * 0.9).toInt()),
              Colors.grey.shade100.withAlpha((255 * 0.8).toInt()),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildImage(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente el contenido
                children: [
                  _buildName(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPrice(),
                      _buildQuantityControls(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
