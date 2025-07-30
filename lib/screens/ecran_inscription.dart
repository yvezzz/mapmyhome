import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mapmyhome/screens/ecran_connexion.dart';
import 'package:mapmyhome/themes/theme.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EcranInscription extends StatefulWidget {
  const EcranInscription({super.key});

  @override
  State<EcranInscription> createState() => _EcranInscriptionState();
}

class _EcranInscriptionState extends State<EcranInscription> {
  final _formEcranInscriptionKey = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final mdpController = TextEditingController();
  final phoneController = TextEditingController();
  final fullNameController = TextEditingController();

  bool agreePersonalData = false;
  bool _obscureText = true;
  String? selectedRole;
  String? selectedCountry;

  @override
  void dispose() {
    mailController.dispose();
    mdpController.dispose();
    super.dispose();
  }

  Future<void> _handleInscription() async {
    if (_formEcranInscriptionKey.currentState!.validate() &&
        agreePersonalData) {
      _showLoadingDialog(); // Affiche le loader

      try {
        final auth = FirebaseAuth.instance;

        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(
              email: mailController.text.trim(),
              password: mdpController.text.trim(),
            );

        // Enregistrement des infos supplémentaires dans Firestore
        await FirebaseFirestore.instance
            .collection('utilisateurs')
            .doc(userCredential.user!.uid)
            .set({
              'nom_complet': fullNameController.text.trim(),
              'email': mailController.text.trim(),
              'role': selectedRole,
              'pays': selectedCountry,
              'telephone':
                  phoneController.text
                      .trim(), // Récupère si tu as un controller
              'uid': userCredential.user!.uid,
            });
        Navigator.pop(context); // Ferme le loader

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Inscription réussie ✅")));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (e) => const EcranConnexion()),
        );
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context); // Ferme le loader

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          double formWidth;
          if (screenWidth < 600) {
            formWidth = screenWidth;
          } else if (screenWidth < 1000) {
            formWidth = 650;
          } else {
            formWidth = 500;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Container(
                width: formWidth,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Form(
                  key: _formEcranInscriptionKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Créez un compte',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: lightColorScheme.primary,
                          ),
                          textAlign: TextAlign.center,

                        ),
                      ),

                      const SizedBox(height: 25),

                      // Nom complet
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          label: const Text('Nom et prénom'),
                          hintText: 'Entrez le nom complet',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Veuillez saisir le nom complet"
                                    : null,
                      ),
                      const SizedBox(height: 25),

                      // Email
                      TextFormField(
                        controller: mailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: const Text('E-mail'),
                          hintText: "exemple@gmail.com",
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir un e-mail";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'E-mail invalide (exemple@gmail.com)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Mot de passe
                      TextFormField(
                        controller: mdpController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          label: const Text('Mot de passe'),
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
                            onPressed:
                                () => setState(() {
                                  _obscureText = !_obscureText;
                                }),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir le mot de passe";
                          }
                          if (value.length < 8 || value.length > 20) {
                            return '8-20 caractères minimum';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Téléphone
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          label: const Text('Téléphone'),
                          hintText: 'Entrez votre numéro',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Numéro requis';
                          }
                          if (!RegExp(r'^\d{9,}$').hasMatch(value)) {
                            return 'Numéro invalide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Sélecteur de pays
                      GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: true,
                            onSelect: (Country country) {
                              setState(() {
                                selectedCountry = country.displayName;
                              });
                            },
                          );
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            label: const Text('Pays'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            selectedCountry ?? 'Choisissez votre pays',
                            style: TextStyle(
                              color:
                                  selectedCountry == null
                                      ? Colors.grey
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Rôle
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        hint: const Text('Choisir un rôle'),
                        items: const [
                          DropdownMenuItem(
                            value: 'Client',
                            child: Text('Client'),
                          ),
                          DropdownMenuItem(
                            value: 'Propriétaire',
                            child: Text('Propriétaire'),
                          ),
                        ],
                        onChanged: (val) => setState(() => selectedRole = val),
                        validator:
                            (value) =>
                                value == null
                                    ? 'Veuillez sélectionner un rôle'
                                    : null,
                        decoration: InputDecoration(
                          label: const Text('Rôle'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Consentement
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged:
                                (val) => setState(() {
                                  agreePersonalData = val!;
                                }),
                          ),
                          Flexible(
                            child: Wrap(
                              children: [
                                const Text("J'accepte le traitement des "),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "données personnelles",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: lightColorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Bouton Inscription
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleInscription,
                          child: const Text("S'inscrire"),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Ligne
                      const Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("S'inscrire avec"),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Réseaux sociaux
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Logo(Logos.google),
                          Logo(Logos.apple),
                          Logo(Logos.facebook_f),
                          Logo(Logos.twitter),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Connexion
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Vous avez déjà un compte ? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const EcranConnexion(),
                                ),
                              );
                            },
                            child: Text(
                              "Se connecter",
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
