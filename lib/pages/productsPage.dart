// ... otros imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:anicom_app/models/product.dart';
import 'package:anicom_app/providers/cartProvider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Set<String> recentlyAddedProducts = {};
  List<Map<String, dynamic>> products = [];
  String categoryFilter = 'todos';
  String searchQuery = '';

  final List<String> categories = [
    'comida',
    'ropa',
    'accesorios',
    'figuras',
    'cosplay',
  ];

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    try {
      List<Map<String, dynamic>> allProducts = [];

      for (String category in categories) {
        final snapshot =
            await FirebaseFirestore.instance.collection(category).get();

        final productsFromCollection = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'categoria': category,
            ...doc.data(),
          };
        }).toList();

        allProducts.addAll(productsFromCollection);
      }

      setState(() {
        products = allProducts;
      });
    } catch (e) {
      print('Error al obtener productos: $e');
    }
  }

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
    final filteredProducts = products.where((product) {
      final name = product['nombre']?.toString().toLowerCase() ?? '';
      final matchesSearch = name.contains(searchQuery.toLowerCase());
      final matchesCategory =
          categoryFilter == 'todos' || product['categoria'] == categoryFilter;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          // Botones de categorías
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Todos'),
                  selected: categoryFilter == 'todos',
                  onSelected: (_) {
                    setState(() {
                      categoryFilter = 'todos';
                    });
                  },
                ),
                const SizedBox(width: 8),
                ...categories.map((category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: categoryFilter == category,
                        onSelected: (_) {
                          setState(() {
                            categoryFilter = category;
                          });
                        },
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Lista de productos
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('Cargando productos . . .'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      final originalImageUrl = product['imagen'] as String? ?? '';
                      final directImageUrl =
                          convertDriveLinkToDirect(originalImageUrl);

                      return ListTile(
                        leading: originalImageUrl.isNotEmpty
                            ? Image.network(
                                directImageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                              )
                            : const Icon(Icons.image_not_supported),
                        title: Text(product['nombre'] ?? 'Sin nombre'),
                        subtitle: Text(
                            'Precio: S/ ${product['precio'] ?? '0.00'}\nCategoría: ${product['categoria']}'),
                        trailing: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: recentlyAddedProducts.contains(product['id'])
                              ? SizedBox(
                                  key: const ValueKey('icon'),
                                  width: 100, // igual que el ancho del botón
                                  height: 40, // igual que la altura del botón
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 28,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  key: const ValueKey('button'),
                                  width: 100, // igual ancho que el ícono
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final producto = Product.fromMap(product);

                                      Provider.of<CartProvider>(context, listen: false).addProduct(producto);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${producto.nombre} añadido al carrito')),
                                      );

                                      setState(() {
                                        recentlyAddedProducts.add(product['id']);
                                      });
                                      Future.delayed(const Duration(seconds: 1), () {
                                        setState(() {
                                          recentlyAddedProducts.remove(product['id']);
                                        });
                                      });
                                    },
                                    child: const Text('Agregar'),
                                  ),
                                ),
                        ),



                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
