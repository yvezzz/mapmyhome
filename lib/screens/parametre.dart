import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapmyhome/widgets/methode.dart';

class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final formWidth = getFormWidth(screenWidth);
          final buttonWidth = getButtonWidth(screenWidth);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: SizedBox(
              width: formWidth,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Paramètres",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50.0),

                    // Bouton Déconnexion
                    SizedBox(
                      width: buttonWidth,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            showLoadingDialog(context); // depuis methode.dart
                            // Déconnexion Firebase
                            await FirebaseAuth.instance.signOut();
                            // Déconnexion Google
                            await googleSignIn.signOut();
                            if (!mounted) return;
                            Navigator.pop(context); // fermer le loading
                            Navigator.pushReplacementNamed(context, '/login');
                          } catch (e) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Erreur déconnexion : $e")),
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            "Déconnexion",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
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
