// products_screen.dart
import 'package:flutter/material.dart';
import 'package:anicom_app/widgets/product_grid_widget.dart';
import 'package:anicom_app/widgets/search_bar_widget.dart';
import 'package:anicom_app/models/product.dart';
import 'package:anicom_app/widgets/tab_bar_widget.dart'; // Importamos el archivo tab_bar_widget.dart

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearchActive = false;
  TextEditingController _searchController = TextEditingController();

  // Lista de productos de ejemplo (placeholders)
  List<Product> _getSampleProducts() {
    return [
      Product(
        id: '1',
        nombre: 'Producto de ejemplo 1',
        descripcion: 'Descripción del producto de ejemplo 1',
        imagen: 'https://via.placeholder.com/150',
        precio: 10.99,
        categoria: 'Accesorios',
      ),
      Product(
        id: '2',
        nombre: 'Producto de ejemplo 2',
        descripcion: 'Descripción del producto de ejemplo 2',
        imagen: 'https://via.placeholder.com/150',
        precio: 15.99,
        categoria: 'Accesorios',
      ),
      Product(
        id: '3',
        nombre: 'Producto de ejemplo 3',
        descripcion: 'Descripción del producto de ejemplo 3',
        imagen: 'https://via.placeholder.com/150',
        precio: 20.99,
        categoria: 'Accesorios',
      ),
      Product(
        id: '4',
        nombre: 'Producto de ejemplo 4',
        descripcion: 'Descripción del producto de ejemplo 4',
        imagen: 'https://via.placeholder.com/150',
        precio: 5.99,
        categoria: 'Accesorios',
      ),
      Product(
        id: '5',
        nombre: 'Producto de ejemplo 5',
        descripcion: 'Descripción del producto de ejemplo 5',
        imagen: 'https://via.placeholder.com/150',
        precio: 12.99,
        categoria: 'Accesorios',
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Product> placeholderProducts = _getSampleProducts(); // Obtenemos los productos de ejemplo

    return Container(
      color: const Color(0xFFF4DFF4),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarWidget(
              isSearchActive: _isSearchActive,
              searchController: _searchController,
              onSearchChanged: (query) {
                setState(() {
                  _isSearchActive = query.isNotEmpty;
                });
              },
            ),
            CustomTabBar(tabController: _tabController), // Usamos el widget separado para el TabBar
            Expanded(
              child: TabBarViewWidget(
                tabController: _tabController,
                products: placeholderProducts, // Pasamos los productos al TabBarViewWidget
              ),
            ),
          ],
        ),
      ),
    );
  }
}
