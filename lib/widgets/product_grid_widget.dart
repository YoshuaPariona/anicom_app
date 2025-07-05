//lib/widgets/product_grid_widget.dart
import 'package:anicom_app/pages/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:anicom_app/widgets/product_card_widget.dart';
import 'package:anicom_app/models/product.dart';

class ProductGridWidget extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onAddToCart; // Cambia VoidCallback a Function(Product)

  const ProductGridWidget({
    super.key,
    required this.products,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Text(
          'No hay productos disponibles',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCardWidget(
            product: product,
            onAddToCart: () => onAddToCart(product),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    product: product,
                    allProducts: products,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
