//anicom_app/widgets/product_card_widget.dart
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
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
            ),
            Image.network(
              convertDriveLinkToDirect(product.imagen),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const SizedBox();
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 50);
              },
              semanticLabel: 'Imagen del producto ${product.nombre}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        product.nombre,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
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
        minimumSize: const Size(56, 36),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(4.0),
      ),
      child: const Icon(
        Icons.add_shopping_cart,
        color: Colors.white,
        size: 20,
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
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImage(),
          const SizedBox(height: 8),
          SizedBox(
            height: 35,
            child: Center(child: _buildName()),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 0.5),
                _buildPrice(),
                _buildAddButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
