import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:anicom_app/pages/productsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anicom App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    ProductsPage(), // Home
    // Placeholder(), // Carrito
    // Placeholder(), // Mapa
    // Placeholder(), // Pedidos recientes
    // Placeholder(), // Usuario
  ];

  final List<String> titles = [
    'Inicio',
    // 'Carrito',
    // 'Ubicación',
    // 'Pedidos recientes',
    // 'Perfil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(titles[currentIndex])),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: pages[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
