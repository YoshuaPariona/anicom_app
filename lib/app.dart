// lib/app.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/welcome_page.dart';
import 'pages/home_page.dart';
import 'services/inactivity_service.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late InactivityService _inactivityService;
  bool _isInactivityServiceInitialized = false;

  @override
  void initState() {
    super.initState();
    if (!_isInactivityServiceInitialized) {
      _inactivityService = InactivityService(
        navigatorKey: navigatorKey,
        inactivityDuration: const Duration(minutes: 2, seconds: 0),
        warningDuration: const Duration(seconds: 30),
      );
      _inactivityService.start(
        initialRoute: FirebaseAuth.instance.currentUser != null
            ? AppRoutes.home
            : AppRoutes.welcome,
      );
      _isInactivityServiceInitialized = true;
    }
  }

  @override
  void dispose() {
    _inactivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _inactivityService.handleUserInteraction(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        navigatorObservers: [
          _inactivityService.routeObserver,
          MyRouteObserver(_inactivityService),
        ],
        debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser != null
            ? AppRoutes.home
            : AppRoutes.welcome,
        routes: {
          AppRoutes.welcome: (_) => const WelcomePage(),
          AppRoutes.login: (_) => LoginPage(),
          AppRoutes.register: (_) => RegisterPage(),
          AppRoutes.home: (_) => const HomePage(),
        },
      ),
    );
  }
}

class MyRouteObserver extends NavigatorObserver {
  final InactivityService inactivityService;

  MyRouteObserver(this.inactivityService);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    inactivityService.updateCurrentRoute(route.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    inactivityService.updateCurrentRoute(previousRoute?.settings.name);
  }
}
