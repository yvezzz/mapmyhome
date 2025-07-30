import 'package:flutter/material.dart';
import 'package:mapmyhome/screens/map_page.dart';
import 'package:mapmyhome/screens/splash_screen.dart';
import 'package:mapmyhome/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:mapmyhome/screens/ecran_connexion.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  Initialisation de Firebase avec options générées par flutterfire configure
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //  Activation de App Check (debug ici, mais à remplacer en prod)
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    // webRecaptchaSiteKey: '...' // optionnel pour web
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MapMyHome',
      theme: LightMode,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => const MapPage(),
        '/login': (context) => const EcranConnexion(),
      },
    );
  }
}
