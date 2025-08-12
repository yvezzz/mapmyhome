import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mapmyhome/screens/ecran_connexion.dart';
import 'package:mapmyhome/screens/map_page.dart';

final mdpController = TextEditingController();
final mailController = TextEditingController();
String? errorMessage;
final formKey = GlobalKey<FormState>();
bool obscureText = true;
bool rememberPassword = false;
final phoneController = TextEditingController();
final fullNameController = TextEditingController();
bool agreePersonalData = false;
String? selectedRole;
String? selectedCountry;


Future<void> handleInscription(BuildContext context) async {
  if (formKey.currentState!.validate() && agreePersonalData) {
    showLoadingDialog(context);
    try {
      final auth = FirebaseAuth.instance;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: mailController.text.trim(),
        password: mdpController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(userCredential.user!.uid)
          .set({
            'nom_complet': fullNameController.text.trim(),
            'email': mailController.text.trim(),
            'role': selectedRole,
            'pays': selectedCountry,
            'telephone': phoneController.text.trim(),
            'uid': userCredential.user!.uid,
            'auth_provider': 'email',
          });

      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Inscription réussie ✅")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (e) => const EcranConnexion()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String message = "Une erreur est survenue.";
      if (e.code == 'email-already-in-use') {
        message = "Cet e-mail est déjà utilisé.";
      } else if (e.code == 'invalid-email') {
        message = "E-mail invalide.";
      } else if (e.code == 'weak-password') {
        message = "Mot de passe trop faible.";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  } else if (!agreePersonalData) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Veuillez accepter le traitement des données personnelles",
        ),
      ),
    );
  }
}

double getFormWidth(double screenWidth) {
  if (screenWidth < 600) return screenWidth;
  if (screenWidth < 1000) return 650;
  return 500;
}

ButtonStyle customButtonStyle(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (states) =>
          states.contains(WidgetState.pressed)
              ? colorScheme.onPrimary
              : colorScheme.primary,
    ),
    foregroundColor: WidgetStateProperty.resolveWith<Color>(
      (states) =>
          states.contains(WidgetState.pressed)
              ? colorScheme.primary
              : colorScheme.onPrimary,
    ),
  );
}

void showLoadingDialog(BuildContext context) {
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

Future<void> login(BuildContext context) async {
  final auth = FirebaseAuth.instance;
  try {
    showLoadingDialog(context);
    await auth.signInWithEmailAndPassword(
      email: mailController.text.trim(),
      password: mdpController.text.trim(),
    );
    Navigator.pop(context);
    // Connexion réussie ✅
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MapPage()));
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
    showLoadingDialog(context);

    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      Navigator.pop(context); // ✅ fermer le dialog si annulé
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

    Navigator.pop(context); // ✅ fermeture normale
    Navigator.pushReplacementNamed(context, '/home');
  } catch (e) {
    Navigator.pop(context); // ✅ fermeture en cas d'erreur
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Erreur Google : $e')));
  }
}
