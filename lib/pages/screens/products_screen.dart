import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:anicom_app/models/product.dart';
import 'package:anicom_app/providers/cart_provider.dart';
import 'package:anicom_app/widgets/product_grid_widget.dart';
import 'package:anicom_app/widgets/search_bar_widget.dart';
import 'package:anicom_app/widgets/tab_bar_widget.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;

  final List<String> categories = [
    'Accesorios',
    'Comida',
    'Cosplay',
    'Figuras',
    'Ropa',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    try {
      List<Product> allProducts = [];

      for (String category in categories) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection(category.toLowerCase())
            .get();

        allProducts.addAll(snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          data['categoria'] = category;
          return Product.fromMap(data);
        }));
      }

      if (mounted) {
        setState(() {
          _products = allProducts;
          _filteredProducts = allProducts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error fetching products: $e');
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _products.where((product) {
        return product.nombre.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _addToCart(Product product) {
    Provider.of<CartProvider>(context, listen: false).addProduct(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.nombre} añadido al carrito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4DFF4),
      body: SafeArea(
        child: Column(
          children: [
            SearchBarWidget(
              isSearchActive: _isSearchActive,
              searchController: _searchController,
              onSearchChanged: (query) {
                setState(() {
                  _isSearchActive = query.isNotEmpty;
                });
                _filterProducts(query);
              },
            ),
            CustomTabBar(tabController: _tabController),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: categories.map((category) {
                        final categoryProducts = _filteredProducts
                            .where((product) => product.categoria == category)
                            .toList();
                        return categoryProducts.isEmpty
                            ? const Center(
                                child: Text('No se encontraron productos'))
                            : ProductGridWidget(
                                products: categoryProducts,
                                onAddToCart: _addToCart,
                              );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
