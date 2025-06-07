import 'package:anicom_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Image.network(
          product.imagen,
          width: 140,
          height: 100,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
              width: 140,
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 140,
              height: 100,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 50),
            );
          },
          semanticLabel: 'Imagen del producto ${product.nombre}',
        ),
      ),
    );
  }

  Widget _buildName() {
    return SizedBox(
      width: 120,
      child: Text(
        product.nombre,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 3, // Cambiado a 3 líneas
      ),
    );
  }

  Widget _buildPrice() {
    return Text(
      'S/. ${product.precio.toStringAsFixed(2)}',
      style: const TextStyle(
        color: Colors.brown,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: onAddToCart,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(8),
      ),
      child: const Icon(
        Icons.add_shopping_cart,
        color: Colors.white,
        size: 20,
        semanticLabel: 'Agregar al carrito',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImage(),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: Center(child: _buildName()),
          ),
          const SizedBox(height: 4),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPrice(),
              const SizedBox(width: 12),
              _buildAddButton(),
            ],
          ),
        ],
      ),
    );
  }
}
