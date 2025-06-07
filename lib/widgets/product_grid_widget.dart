import 'package:flutter/material.dart';
import 'package:anicom_app/widgets/product_card_widget.dart';
import 'package:anicom_app/models/product.dart';

class ProductGridWidget extends StatelessWidget {
  final List<Product> products;
  final VoidCallback onAddToCart;

  const ProductGridWidget({
    super.key,
    required this.products,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Si la lista de productos está vacía, mostramos un mensaje
    if (products.isEmpty) {
      return Center(
        child: Text(
          'No hay productos disponibles',
          style: Theme.of(context).textTheme.headlineMedium, // Cambiado a headlineMedium
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Número de columnas
          childAspectRatio: 0.72, // Proporción entre el alto y el ancho de cada celda
          crossAxisSpacing: 12, // Espaciado entre columnas
          mainAxisSpacing: 12, // Espaciado entre filas
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCardWidget(
            product: product,
            onAddToCart: onAddToCart,
          );
        },
      ),
    );
  }
}
