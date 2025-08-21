import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mapmyhome/screens/map_page.dart';
import 'package:permission_handler/permission_handler.dart';

final mdpController = TextEditingController();
final mailController = TextEditingController();
final phoneController = TextEditingController();
final fullNameController = TextEditingController();

String? errorMessage;
final formKey = GlobalKey<FormState>();
bool obscureText = true;
bool rememberPassword = false;
bool agreePersonalData = false;
String? selectedRole;
String? selectedCountry;

// Client ID web pour Google Sign-In
final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId:
      "472099826779-hfa8o4hdai8lvqmlbl85j80263n47mb8.apps.googleusercontent.com",
  scopes: ['email'],
);


double getFormWidth(double screenWidth) {
  if (screenWidth < 600) return screenWidth;
  if (screenWidth < 1000) return 650;
  return 500;
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
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MapPage()));
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context);
    String message;
    if (e.code == 'user-not-found') {
      message = 'Utilisateur introuvable ❌';
    } else if (e.code == 'wrong-password') {
      message = 'Mot de passe incorrect 🔐';
    } else {
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

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      Navigator.pop(context); // fermeture si annulé
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

    Navigator.pop(context); // fermeture normale
    Navigator.pushReplacementNamed(context, '/mappage');
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Erreur Google : $e')));
  }
}


Future<void> checkPermissions(BuildContext context) async {
    // 1. Vérifier la permission de localisation
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        showPermissionDialog(context);
        return;
      }
    }

    // 2. Vérifier si la localisation est activée
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      showEnableLocationDialog(context);
    }
  }

  void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Permission requise"),
        content: const Text("Veuillez activer la permission de localisation pour continuer."),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void showEnableLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Localisation désactivée"),
        content: const Text("Veuillez activer la localisation pour utiliser la carte."),
        actions: [
          TextButton(
            child: const Text("Activer"),
            onPressed: () {
              Geolocator.openLocationSettings();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
