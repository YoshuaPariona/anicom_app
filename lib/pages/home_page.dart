import 'package:anicom_app/pages/auth/login_page.dart';
import 'package:anicom_app/pages/map_page.dart';
import 'package:anicom_app/pages/screens/cart_screen.dart';
import 'package:anicom_app/pages/screens/order_history_screen.dart';
import 'package:anicom_app/pages/screens/products_screen.dart';
import 'package:anicom_app/pages/user_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert'; // Asegúrate de importar esta biblioteca para usar base64Decode

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anicom App',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class AppColors {
  static const Color backgroundColor = Color(0xFFF4DFF4);
  static const Color selectedItemColor = Color.fromARGB(255, 131, 66, 42);
  static const Color unselectedItemColor = Colors.grey;
  static const Color textColor = Colors.black87;
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  User? user;

  final List<Widget> pages = const [
    ProductsScreen(),
    CartScreen(),
    OrderHistoryScreen(),
    MapPage(),
    UserPage(),
  ];

  final List<String> titles = const [
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      });
    }
  }

  Future<void> confirmarCerrarSesion() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro?'),
          content: const Text('¿Deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await cerrarSesion();
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }

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
        String? imagenBase64;

        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          userName = data?['name'] ?? "anicom_user";
          imagenBase64 = data?['fotoPerfilBase64'];
        }

        ImageProvider<Object>? imageProvider;
        if (imagenBase64 != null) {
          try {
            final bytes = base64Decode(imagenBase64);
            imageProvider = MemoryImage(bytes);
          } catch (e) {
            imageProvider = null;
          }
        }

        final String initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'A';

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            leading: Builder(
              builder: (context) => Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.selectedItemColor),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
            title: Text(
              titles[currentIndex],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
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
                  color: AppColors.backgroundColor,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: imageProvider,
                        child: imageProvider == null
                            ? Text(
                                initial,
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: AppColors.selectedItemColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          userName,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.exit_to_app, color: Colors.red),
                        onPressed: confirmarCerrarSesion,
                      ),
                    ],
                  ),
                ),
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
            selectedItemColor: AppColors.selectedItemColor,
            unselectedItemColor: AppColors.unselectedItemColor,
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
