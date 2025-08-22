import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mapmyhome/screens/map_page.dart';
import 'package:mapmyhome/themes/theme.dart';
import 'package:mapmyhome/screens/ecran_inscription.dart';
import 'package:mapmyhome/widgets/methode.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final _formKey = GlobalKey<FormState>();
  bool rememberPassword = false;
  bool _obscureText = true;
  final TextEditingController resetCtrl =
      TextEditingController(); // déplacé ici

  @override
  void dispose() {
    resetCtrl.dispose(); // dispose du controller local
    super.dispose();
  }

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
            child: Center(
              child: Container(
                width: formWidth,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
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

                      // EMAIL
                      TextFormField(
                        controller: mailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir un e-mail";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Veuillez entrer un e-mail valide';
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

                      // MOT DE PASSE
                      TextFormField(
                        controller: mdpController,
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir le mot de passe";
                          }
                          if (value.length < 8 || value.length > 20) {
                            return 'Mot de passe entre 8 et 20 caractères';
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

                      // SOUVENIR / RESET PASSWORD
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value ?? false;
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
                            onTap: () {
                              showResetPasswordDialog(context, resetCtrl);
                            },
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

                      // BOUTON CONNEXION
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              login(context);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              "Connexion",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),

                      // CONNECTE AVEC GOOGLE / AUTRES
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
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Logo(Logos.github, size: 35),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Logo(Logos.microsoft, size: 35),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),

                      // S'INSCRIRE
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

  // --- Méthodes intégrées ---

  Future<void> login(BuildContext context) async {
    try {
      showLoadingDialog(context);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mailController.text.trim(),
        password: mdpController.text.trim(),
      );
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapPage(role: 'Admin')),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String message =
          e.code == 'user-not-found'
              ? 'Utilisateur introuvable ❌'
              : e.code == 'wrong-password'
              ? 'Mot de passe incorrect 🔐'
              : 'Erreur : $e';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      showLoadingDialog(context);
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Navigator.pop(context);
        return;
      }
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
              'role': 'Admin',
              'pays': '',
              'telephone': userCredential.user?.phoneNumber ?? '',
              'uid': uid,
              'auth_provider': 'google',
            });
      }

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapPage(role: 'Admin')),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur Google : $e')));
    }
  }

  void showResetPasswordDialog(
    BuildContext context,
    TextEditingController emailController,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Réinitialiser le mot de passe"),
            content: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                hintText: 'Entrez votre e-mail',
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Annuler"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("Envoyer"),
                onPressed: () async {
                  final email = emailController.text.trim();
                  if (email.isEmpty ||
                      !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Veuillez entrer un e-mail valide"),
                      ),
                    );
                    return;
                  }
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: email,
                    );
                    Navigator.pop(context);
                    emailController.clear(); // clear après envoi réussi
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("E-mail de réinitialisation envoyé ✅"),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur : ${e.message}")),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }
}
