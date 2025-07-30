import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapmyhome/themes/theme.dart';
import 'package:mapmyhome/screens/ecran_inscription.dart';
import 'package:mapmyhome/screens/map_page.dart';
import 'package:icons_plus/icons_plus.dart';

class Proprietaire extends StatefulWidget {
  const Proprietaire({super.key});

  @override
  State<Proprietaire> createState() => _ProprietaireState();
}

class _ProprietaireState extends State<Proprietaire> {
  final _formKey = GlobalKey<FormState>();
  bool rememberPassword = false;
  bool _obscureText = true;
  String? errorMessage;
  final mdpController = TextEditingController();
  final mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
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
              child: Center(
                child: Container(
                  width: formWidth,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey, // couleur de l'ombre
                        offset: Offset(4, 4), // décalage horizontal et vertical
                        blurRadius: 10, // flou
                        spreadRadius: 2, // étendue
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Connectez-vous pour gérer vos annonces.',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: lightColorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40.0),
                        TextFormField(
                          controller: mailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez saisir un e-mail";
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Veuillez entrer un e-mail valide (Exemple@gmail.com)';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('E-mail'),
                            hintText: "Exemple@gmail.com",
                            hintStyle: const TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: mdpController,
                          obscureText: _obscureText,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez saisir le mot de passe";
                            }
                            if (value.length < 8 || value.length > 20) {
                              return 'Le mot de passe doit contenir entre 8 et 20 caractères';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            hintText: 'Entrez le mot de passe',
                            hintStyle: const TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberPassword,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberPassword = value!;
                                    });
                                  },
                                  activeColor: lightColorScheme.primary,
                                ),
                                const Text(
                                  'Souviens-toi de moi',
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Oublier le mot de passe ?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                login(context);
                              }
                            },
                            child: const Text("Connexion"),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Divider(
                                    thickness: 0.7, color: Colors.grey)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Se connecter avec",
                                  style: TextStyle(color: Colors.black45)),
                            ),
                            Expanded(
                                child: Divider(
                                    thickness: 0.7, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Logo(Logos.google),
                            Logo(Logos.apple),
                            Logo(Logos.facebook_f),
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Vous n'avez pas de compte ? ",
                                style: TextStyle(color: Colors.black45)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const EcranInscription()),
                                );
                              },
                              child: Text(
                                "S'inscrire",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ));
        }));
  }
  
  Future<void> login(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(
          email: mailController.text, password: mdpController.text);
      // Connexion réussie ✅
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MapPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        // Affiche un message : Utilisateur introuvable
        message = 'Utilisateur introuvale ❌';
      } else if (e.code == 'wrong-password') {
        message = 'Mot de passe incorrect 🔐';
      } else {
        message = 'Erreur : Utilisateur ou Mot de passe incorrect 🔐❌';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
