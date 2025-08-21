import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
        
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: SizedBox(
              width: formWidth,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Parametre"),
                    const SizedBox(height: 50.0),
                    SizedBox(
                      width: screenWidth * 0.35,
                      
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          await GoogleSignIn().signOut();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/');
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
