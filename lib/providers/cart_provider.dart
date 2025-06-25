// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:anicom_app/models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<Product, int> _items = {};

  Map<Product, int> get items => _items;

  /// Agrega un producto al carrito o incrementa su cantidad si ya existe.
  void addProduct(Product product) {
    _items[product] = (_items[product] ?? 0) + 1;
    notifyListeners();
    _saveCartToPrefs();
  }

  /// Elimina un producto del carrito.
  void removeProduct(Product product) {
    _items.remove(product);
    notifyListeners();
    _saveCartToPrefs();
  }

  /// Decrementa la cantidad de un producto en el carrito.
  /// Si la cantidad es 1, el producto se elimina del carrito.
  void decrementProduct(Product product) {
    if (!_items.containsKey(product)) return;

    if (_items[product]! > 1) {
      _items[product] = _items[product]! - 1;
    } else {
      _items.remove(product);
    }
    notifyListeners();
    _saveCartToPrefs();
  }

  /// Limpia todos los productos del carrito.
  void clear() {
    _items.clear();
    notifyListeners();
    _saveCartToPrefs();
  }

  /// Calcula el total del precio de todos los productos en el carrito.
  double get total {
    return _items.entries
        .map((e) => e.key.precio * e.value)
        .fold(0.0, (a, b) => a + b);
  }

  /// Calcula el número total de productos en el carrito.
  int get totalItems {
    return _items.values.fold(0, (a, b) => a + b);
  }

  /// Devuelve una lista de entradas de productos con sus cantidades.
  /// Útil para mostrar en la interfaz de usuario.
  List<MapEntry<Product, int>> get productList => _items.entries.toList();

  /// Verifica si un producto está en el carrito.
  bool containsProduct(Product product) => _items.containsKey(product);

  /// Carga el carrito desde las preferencias locales.
  Future<void> loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      final Map<String, dynamic> decoded = json.decode(cartData);
      // Aquí necesitarás una forma de convertir los datos decodificados de nuevo a Product.
      // Esto depende de cómo serialices los productos.
      // Por simplicidad, asumiré que tienes una función `Product.fromMap`.
      decoded.forEach((key, value) {
        final product = Product.fromMap(json.decode(key));
        _items[product] = value;
      });
      notifyListeners();
    }
  }

  /// Guarda el carrito en las preferencias locales.
  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, int> cartData = {};
    _items.forEach((product, quantity) {
      cartData[json.encode(product.toMap())] = quantity;
    });
    await prefs.setString('cart', json.encode(cartData));
  }
}
