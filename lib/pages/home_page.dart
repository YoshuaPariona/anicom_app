import 'package:anicom_app/pages/auth/login_page.dart';
import 'package:anicom_app/pages/cart_page.dart';
import 'package:anicom_app/pages/map_page.dart';
import 'package:anicom_app/pages/order_history_page.dart';
import 'package:anicom_app/pages/screens/products_screen.dart';
import 'package:anicom_app/pages/user_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  User? user;

  final List<Widget> pages = [
    ProductsScreen(),
    CartPage(),
    OrderHistoryScreen(),
    MapPage(),
    UserPage(),
  ];

  final List<String> titles = [
    'Inicio',
    'Carrito',
    'Pedidos',
    'Mapa',
    'Perfil',
  ];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Usuario no autenticado: redirige al login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      });
    }
  }

  // Función que muestra el diálogo de confirmación para cerrar sesión
  Future<void> confirmarCerrarSesion() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Estás seguro?'),
          content: Text('¿Deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cierra el diálogo
                await cerrarSesion();
              },
              child: Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }

  // Función para cerrar sesión
  Future<void> cerrarSesion() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: user != null
          ? FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user!.uid)
              .snapshots()
          : null,
      builder: (context, snapshot) {
        String userName = "anicom_user";
        if (snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data!.data() as Map<String, dynamic>?;
          userName = data?['name'] ?? "anicom_user";
        }

        final String inicial =
            userName.isNotEmpty ? userName[0].toUpperCase() : 'A';

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFF4DFF4),
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black87),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: Text(
              titles[currentIndex],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Image.asset(
                  'assets/logo.png',
                  height: 40,
                ),
              ),
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 40, left: 16, right: 16, bottom: 16),
                  color: const Color(0xFFF4DFF4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          inicial,
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          userName,
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      const ListTile(
                        leading: Icon(Icons.language),
                        title: Text('Lenguaje'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.notifications),
                        title: Text('Notificaciones'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Configuraciones'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.payment),
                        title: Text('Métodos de pago'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Cerrar sesión'),
                        onTap: confirmarCerrarSesion,
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
                icon: Icon(Icons.refresh),
                label: 'Pedidos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_pin),
                label: 'Mapa',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },
    );
  }
}
