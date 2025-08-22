import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mapmyhome/screens/map_page.dart';
import 'package:mapmyhome/themes/theme.dart';
import 'package:mapmyhome/screens/ecran_inscription.dart';
import 'package:mapmyhome/widgets/methode.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Client extends StatefulWidget {
  const Client({super.key});

  @override
  State<Client> createState() => _ClientState();
}

class _ClientState extends State<Client> {
  final _formKey = GlobalKey<FormState>();

  // CONTROLLERS manquants
  final TextEditingController mailController = TextEditingController();
  final TextEditingController mdpController = TextEditingController();

  bool rememberPassword = false;
  bool _obscureText = true;

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "472099826779-hfa8o4hdai8lvqmlbl85j80263n47mb8.apps.googleusercontent.com",
    scopes: ['email'],
  );

  @override
  void dispose() {
    mailController.dispose();
    mdpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          double formWidth = screenWidth < 600
              ? screenWidth * 0.9
              : screenWidth < 1000
                  ? 650
                  : 500;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Container(
                width: formWidth,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Connectez-vous pour trouver le logement idéal.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 40),

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
                          labelText: 'E-mail',
                          hintText: "Exemple@gmail.com",
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

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
                          hintText: 'Entrez le mot de passe',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() => _obscureText = !_obscureText);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // SOUVENIR / RESET PASSWORD
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (value) =>
                                    setState(() => rememberPassword = value ?? false),
                                activeColor: lightColorScheme.primary,
                              ),
                              const Text(
                                'Souviens-toi de moi',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => showResetPasswordDialog(
                              context,
                              mailController,
                            ),
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
                      const SizedBox(height: 25),

                      // BOUTON CONNEXION
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) login(context);
                          },
                          child: const Text("Connexion"),
                        ),
                      ),
                      const SizedBox(height: 25),

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
                      const SizedBox(height: 25),

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
                      const SizedBox(height: 25),

                      // S'INSCRIRE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Vous n'avez pas de compte ? ",
                            style: TextStyle(color: Colors.black45),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EcranInscription(),
                              ),
                            ),
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
                      const SizedBox(height: 20),
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
      showLoadingDialog(context);
      await auth.signInWithEmailAndPassword(
        email: mailController.text.trim(),
        password: mdpController.text.trim(),
      );
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapPage(role: 'Client')),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String message = e.code == 'user-not-found'
          ? 'Utilisateur introuvable ❌'
          : e.code == 'wrong-password'
              ? 'Mot de passe incorrect 🔐'
              : 'Erreur : $e';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final uid = userCredential.user!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('utilisateurs').doc(uid).get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('utilisateurs').doc(uid).set({
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapPage(role: 'Client')),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur Google : $e')));
    }
  }

  void showResetPasswordDialog(
      BuildContext context, TextEditingController emailController) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
                  const SnackBar(content: Text("Veuillez entrer un e-mail valide")),
                );
                return;
              }
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("E-mail de réinitialisation envoyé ✅")),
                );
              } on FirebaseAuthException catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Erreur : ${e.message}")));
              }
            },
          ),
        ],
      ),
    );
  }
}
