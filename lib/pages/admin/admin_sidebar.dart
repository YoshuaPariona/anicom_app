//lib/pages/admin/admin_sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

SideBar adminSidebar({
  required String selected,
  required Function(String) onSelect,
}) {
  return SideBar(
    items: const [
      AdminMenuItem(title: 'Accesorios', icon: Icons.star, route: '/accesorios'),
      AdminMenuItem(title: 'Comida', icon: Icons.fastfood, route: '/comida'),
      AdminMenuItem(title: 'Cosplay', icon: Icons.face, route: '/cosplay'),
      AdminMenuItem(title: 'Figuras', icon: Icons.toys, route: '/figuras'),
      AdminMenuItem(title: 'Ropa', icon: Icons.checkroom, route: '/ropa'),
    ],
    selectedRoute: '/$selected',
    onSelected: (item) {
      onSelect(item.route!.substring(1)); // quita el '/'
    },
  );
}