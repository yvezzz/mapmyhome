import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          //Largeur responsive
          double formWidth;
          if (screenWidth < 600) {
            formWidth = screenWidth; //mobile
          } else if (screenWidth < 1000) {
            formWidth = 650; //tablette
          } else {
            formWidth = 500; //Ordinateur
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: SizedBox(
              width: formWidth,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Page de la Carte"),
                    const SizedBox(height: 50.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/login',
                            );
                          }
                        },

                        child: const Text(
                          "Déconnexion",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
