import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

// --- Controllers centralisés ---
final TextEditingController mdpController = TextEditingController();
final TextEditingController mailController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController fullNameController = TextEditingController();

// --- Variables globales ---
bool obscureText = true;
bool rememberPassword = false;
bool agreePersonalData = false;
String? selectedRole;
String? selectedCountry;

// --- Google Sign-In ---
final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: "472099826779-hfa8o4hdai8lvqmlbl85j80263n47mb8.apps.googleusercontent.com",
  scopes: ['email'],
);

// --- Méthodes utilitaires ---

// Affiche un dialogue responsive
void showResponsiveDialog({
  required BuildContext context,
  required String title,
  required String content,
  required List<Widget> actions,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final dialogWidth = screenWidth < 600 ? screenWidth * 0.85 : 400.0;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: SizedBox(width: dialogWidth, child: Text(content)),
      actions: actions,
    ),
  );
}

// Permission & localisation
Future<void> checkPermissions(BuildContext context) async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    status = await Permission.location.request();
    if (!status.isGranted) {
      showResponsiveDialog(
        context: context,
        title: "Permission requise",
        content: "Veuillez activer la permission de localisation pour continuer.",
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
          ),
        ],
      );
      return;
    }
  }

  if (!await Geolocator.isLocationServiceEnabled()) {
    showResponsiveDialog(
      context: context,
      title: "Localisation désactivée",
      content: "Veuillez activer la localisation pour utiliser la carte.",
      actions: [
        TextButton(
          child: const Text("Activer"),
          onPressed: () {
            Geolocator.openLocationSettings();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

// Dialogue de chargement
void showLoadingDialog(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final size = screenWidth < 600 ? 50.0 : 70.0;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        height: size,
        width: size,
        child: const Center(child: CircularProgressIndicator()),
      ),
    ),
  );
}

// Nettoyage des controllers
void disposeControllers() {
  mdpController.dispose();
  mailController.dispose();
  phoneController.dispose();
  fullNameController.dispose();
}

// Formulaire responsive
double getFormWidth(double screenWidth) {
  if (screenWidth < 600) return screenWidth * 0.9;
  if (screenWidth < 1000) return 650;
  return 500;
}

double getButtonWidth(double screenWidth) {
  if (screenWidth < 600) return screenWidth * 0.8;
  return screenWidth * 0.35;
}

// Bouton responsive réutilisable
Widget responsiveButton({
  required BuildContext context,
  required String label,
  required VoidCallback onPressed,
}) {
  final width = getButtonWidth(MediaQuery.of(context).size.width);

  return SizedBox(
    width: width,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    ),
  );
}
