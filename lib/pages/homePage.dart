import 'package:anicom_app/pages/cartPage.dart';
import 'package:anicom_app/pages/mapPage.dart';
import 'package:anicom_app/pages/placeholder.dart';
import 'package:anicom_app/pages/productsPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
    CartPage(), // Carrito
    MapPage(), // Mapa
    const PlaceholderPage(title: 'Pedidos', icon: Icons.refresh),
    const PlaceholderPage(title: 'Perfil', icon: Icons.person),
  ];

  final List<String> titles = [
    'Inicio',
    'Carrito',
    'Mapa',
    'Pedidos',
    'Perfil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: const Color(0xFFF4DFF4),
        centerTitle: true, 
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  titles[currentIndex],
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Image.asset(
              'assets/logo.png',
              height: 40,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Cabecera con perfil del usuario
            Container(
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
              color: const Color(0xFFF4DFF4),
              child: Row(
                children: [
                  // Círculo con inicial
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      'A', // <- Inicial del usuario (placeholder)
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Nombre de usuario
                  const Expanded(
                    child: Text(
                      'anico_user', // <- Nombre de usuario (placeholder)
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Opciones debajo
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Lenguaje'),
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notificaciones'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Configuraciones'),
                  ),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text('Métodos de pago'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Cerrar sesión'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: pages[currentIndex],
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
