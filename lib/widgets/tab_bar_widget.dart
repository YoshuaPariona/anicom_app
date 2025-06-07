import 'package:flutter/material.dart';
import 'package:anicom_app/widgets/product_grid_widget.dart';
import 'package:anicom_app/models/product.dart';

// Constantes para los estilos
const Color _tabBarBackgroundColor = Color(0xFFF4DFF4);
const Color _selectedLabelColor = Colors.brown;
const Color _unselectedLabelColor = Colors.grey;
const double _indicatorWeight = 4.0;
const double _fontSize = 16.0;
const double _tabBarIndicatorRadius = 20.0;

class CustomTabBar extends StatelessWidget {
  final TabController tabController;

  const CustomTabBar({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _tabBarBackgroundColor,
      elevation: 4.0, // Añadir elevación para sombra
      child: TabBar(
        controller: tabController,
        labelColor: _selectedLabelColor,
        unselectedLabelColor: _unselectedLabelColor,
        indicator: RoundedRectangleTabIndicator(
          color: Colors.brown,
          weight: _indicatorWeight,
          width: _tabBarIndicatorRadius,
        ),
        isScrollable: true,
        tabs: const [
          Tab(
            child: Text('Accesorios', style: TextStyle(fontSize: _fontSize)),
          ),
          Tab(
            child: Text('Comida', style: TextStyle(fontSize: _fontSize)),
          ),
          Tab(
            child: Text('Cosplay', style: TextStyle(fontSize: _fontSize)),
          ),
          Tab(
            child: Text('Figuras', style: TextStyle(fontSize: _fontSize)),
          ),
          Tab(
            child: Text('Ropa', style: TextStyle(fontSize: _fontSize)),
          ),
        ],
      ),
    );
  }
}

class RoundedRectangleTabIndicator extends Decoration {
  final Color color;
  final double weight;
  final double width;

  const RoundedRectangleTabIndicator({
    required this.color,
    required this.weight,
    required this.width,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RoundedRectanglePainter(
      color: color,
      weight: weight,
      width: width,
    );
  }
}

class _RoundedRectanglePainter extends BoxPainter {
  final Color color;
  final double weight;
  final double width;

  _RoundedRectanglePainter({
    required this.color,
    required this.weight,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = Offset(
      offset.dx + configuration.size!.width / 2 - width / 2,
      configuration.size!.height - weight,
    ) & Size(width, weight);

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      paint,
    );
  }
}

class TabBarViewWidget extends StatelessWidget {
  final TabController tabController;
  final List<Product> products;

  const TabBarViewWidget({Key? key, required this.tabController, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Product>> categorizedProducts = {
      'Accesorios': products.where((p) => p.categoria == 'Accesorios').toList(),
      'Comida': products.where((p) => p.categoria == 'Comida').toList(),
      'Cosplay': products.where((p) => p.categoria == 'Cosplay').toList(),
      'Figuras': products.where((p) => p.categoria == 'Figuras').toList(),
      'Ropa': products.where((p) => p.categoria == 'Ropa').toList(),
    };

    return TabBarView(
      controller: tabController,
      children: categorizedProducts.entries.map((entry) {
        return ProductGridWidget(
          products: entry.value,
          onAddToCart: () {},
        );
      }).toList(),
    );
  }
}
