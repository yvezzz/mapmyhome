import 'package:flutter/material.dart';
import 'package:mapmyhome/widgets/connexion_navbar.dart';
import 'package:mapmyhome/screens/client.dart';
import 'package:mapmyhome/screens/proprietaire.dart';
import 'package:mapmyhome/screens/admin.dart';

class EcranConnexion extends StatefulWidget {
  const EcranConnexion({super.key});

  @override
  State<EcranConnexion> createState() => _EcranConnexionState();
}

class _EcranConnexionState extends State<EcranConnexion> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    switch (currentIndex) {
      case 1:
        currentPage = const Proprietaire();
        break;
      case 2:
        currentPage = const Admin();
        break;
      default:
        currentPage = const Client();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ConnexionNavbar(
              currentIndex: currentIndex,
              onValueChanged: (int newIndex) {
                setState(() {
                  currentIndex = newIndex;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: currentPage,
            ),
          ],
        ),
      ),
    );
    
  }
}
