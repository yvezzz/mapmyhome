import 'package:flutter/material.dart';
import 'package:mapmyhome/screens/parametre.dart';
import 'package:mapmyhome/screens/map_page.dart';
import 'package:mapmyhome/screens/splash_screen.dart';
import 'package:mapmyhome/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mapmyhome/screens/ecran_connexion.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
        '/': (context) => const SplashScreen(),
        '/setting': (context) => const Parametre(),
        '/login': (context) => const EcranConnexion(),
        '/mappage': (context) => const MapPage(role: ''),
      },
    );
  }
}
