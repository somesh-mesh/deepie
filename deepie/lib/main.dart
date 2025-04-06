import 'package:deppie/pages/capabilities_screen.dart';
import 'package:deppie/pages/chat_screen.dart';
import 'package:deppie/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());

  // Remove splash screen after initialization
  Future.delayed(const Duration(milliseconds: 500), () {
    FlutterNativeSplash.remove();
  });
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const WelcomeScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'capabilities',
          builder: (BuildContext context, GoRouterState state) => const CapabilitiesScreen(),
        ),
        GoRoute(
          path: 'chat',
          builder: (BuildContext context, GoRouterState state) {
            final initialMessage = state.uri.queryParameters['msg'] ?? "";
            return ChatScreen(initialMessage: initialMessage);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Deppie AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
    );
  }
}
