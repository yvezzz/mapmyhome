import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mapmyhome/screens/ecran_connexion.dart';
import 'package:mapmyhome/screens/map_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si snapshot.connectionState est waiting, on peut afficher un loader
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si l'utilisateur est connecté, on va sur MapPage
        if (snapshot.hasData) {
          return const MapPage();
        }

        // Sinon on renvoie vers l'écran de connexion
        return const EcranConnexion();
      },
    );
  }
}
