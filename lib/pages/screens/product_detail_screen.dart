// lib/pages/screens/product_detail_screen.dart
import 'package:anicom_app/models/product.dart';
import 'package:anicom_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final List<Product> allProducts;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.allProducts,
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

  List<Product> getRecommendedProducts() {
    final reference = product.nombre.toLowerCase();
    final similarProducts = allProducts.where((p) {
      final name = p.nombre.toLowerCase();
      return p.id != product.id && _similitud(name, reference) > 0;
    }).toList();

    similarProducts.sort((a, b) =>
        _similitud(b.nombre.toLowerCase(), reference) -
        _similitud(a.nombre.toLowerCase(), reference));

    return similarProducts.take(3).toList();
  }

  int _similitud(String a, String b) {
    final minLength = a.length < b.length ? a.length : b.length;
    int score = 0;
    for (int i = 0; i < minLength; i++) {
      if (a[i] == b[i]) {
        score++;
      } else {
        break;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final recomendados = getRecommendedProducts();

    return Scaffold(
      backgroundColor: const Color(0xFFF4DFF4), 
      appBar: AppBar(
        title: Text("Detalle del producto"),
        backgroundColor: Color(0xFFF4DFF4),
        foregroundColor: Colors.brown,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Imagen
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.network(
                convertDriveLinkToDirect(product.imagen),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 80)),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                product.nombre,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                'S/. ${product.precio.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.brown,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                product.descripcion ?? 'Sin descripción',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).addProduct(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.nombre} añadido al carrito')),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Agregar al carrito'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const Divider(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Productos recomendados:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
            ...recomendados.map(
              (prod) => Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        convertDriveLinkToDirect(prod.imagen),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  title: Text(prod.nombre),
                  subtitle: Text('S/. ${prod.precio.toStringAsFixed(2)}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.pinkAccent),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          product: prod,
                          allProducts: allProducts,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
