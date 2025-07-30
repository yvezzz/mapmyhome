import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mapmyhome/themes/theme.dart';
import 'package:mapmyhome/screens/ecran_inscription.dart';
import 'package:mapmyhome/screens/map_page.dart';
import 'package:icons_plus/icons_plus.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final _formKey = GlobalKey<FormState>();
  bool rememberPassword = false;
  bool _obscureText = true;
  String? errorMessage;
  final mdpController = TextEditingController();
  final mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
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
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Identifiez-vous pour superviser la plateforme.',
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
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
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
                            child: Divider(thickness: 0.7, color: Colors.grey),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Se connecter avec",
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                          Expanded(
                            child: Divider(thickness: 0.7, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Logo(Logos.google, size: 35),
                            onPressed: () => signInWithGoogle(context),
                          ),
                          IconButton(
                            icon: Logo(Logos.facebook_f, size: 35),
                            onPressed: () => signInWithFacebook(context),
                          ),
                          IconButton(
                            icon: Logo(Logos.github, size: 35),
                            onPressed: () {
                              // À implémenter
                            },
                          ),
                          IconButton(
                            icon: Logo(Logos.microsoft, size: 35),
                            onPressed: () {
                              // À implémenter
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Vous n'avez pas de compte ? ",
                            style: TextStyle(color: Colors.black45),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EcranInscription(),
                                ),
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
            ),
          );
        },
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    try {
      _showLoadingDialog();
      await auth.signInWithEmailAndPassword(
        email: mailController.text.trim(),
        password: mdpController.text.trim(),
      );
      Navigator.pop(context);
      // Connexion réussie ✅
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MapPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        Navigator.pop(context);

        // Affiche un message : Utilisateur introuvable
        message = 'Utilisateur introuvable ❌';
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);
        message = 'Mot de passe incorrect 🔐';
      } else {
        Navigator.pop(context);
        message = 'Erreur : Utilisateur ou Mot de passe incorrect 🔐❌';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      _showLoadingDialog();
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final uid = userCredential.user!.uid;
      final userDoc =
          await FirebaseFirestore.instance
              .collection('utilisateurs')
              .doc(uid)
              .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance
            .collection('utilisateurs')
            .doc(uid)
            .set({
              'nom_complet': userCredential.user?.displayName ?? '',
              'email': userCredential.user?.email ?? '',
              'role': 'Client',
              'pays': '',
              'telephone': userCredential.user?.phoneNumber ?? '',
              'uid': uid,
              'auth_provider': 'google',
            });
      }
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur Google : $e')));
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      _showLoadingDialog();
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookCredential);

        final uid = userCredential.user!.uid;
        final userDoc =
            await FirebaseFirestore.instance
                .collection('utilisateurs')
                .doc(uid)
                .get();

        if (!userDoc.exists) {
          await FirebaseFirestore.instance
              .collection('utilisateurs')
              .doc(uid)
              .set({
                'nom_complet': userCredential.user?.displayName ?? '',
                'email': userCredential.user?.email ?? '',
                'role': 'Client',
                'pays': '',
                'telephone': userCredential.user?.phoneNumber ?? '',
                'uid': uid,
                'auth_provider': 'facebook',
              });
        }
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connexion Facebook annulée.")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur Facebook : $e")));
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
