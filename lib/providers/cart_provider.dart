import 'package:anicom_app/models/product.dart';
import 'package:flutter/material.dart';


class CartProvider with ChangeNotifier {
  final Map<Product, int> _items = {};

  Map<Product, int> get items => _items;

  void addProduct(Product product) {
    _items[product] = (_items[product] ?? 0) + 1;
    notifyListeners(); // Notifica a quien escuche el cambio
  }

  void removeProduct(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void decrementProduct(Product product) {
    if (!_items.containsKey(product)) return;

    if (_items[product]! > 1) {
      _items[product] = _items[product]! - 1;
    } else {
      _items.remove(product);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get total {
    return _items.entries
        .map((e) => e.key.precio * e.value)
        .fold(0.0, (a, b) => a + b);
  }

  int get totalItems {
    return _items.values.fold(0, (a, b) => a + b);
  }
}
