import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mapmyhome/screens/ecran_connexion.dart';
import 'package:mapmyhome/themes/theme.dart';
import 'package:country_picker/country_picker.dart';
import 'package:mapmyhome/widgets/methode.dart';

class EcranInscription extends StatefulWidget {
  const EcranInscription({super.key});

  @override
  State<EcranInscription> createState() => _EcranInscriptionState();
}

class _EcranInscriptionState extends State<EcranInscription> {

  final mailController = TextEditingController();
  final mdpController = TextEditingController();
  final phoneController = TextEditingController();
  final fullNameController = TextEditingController();

  @override
  void dispose() {
    mailController.dispose();
    mdpController.dispose();
    phoneController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final formWidth = getFormWidth(screenWidth);

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
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        'Créez un compte',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          label: const Text('Nom et prénom'),
                          hintText: 'Entrez le nom complet',
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
                      TextFormField(
                        controller: mailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: const Text('E-mail'),
                          hintText: "exemple@gmail.com",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir un e-mail";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'E-mail invalide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: mdpController,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          label: const Text('Mot de passe'),
                          hintText: 'Entrez le mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed:
                                () =>
                                    setState(() => obscureText = !obscureText),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir le mot de passe";
                          }
                          if (value.length < 8 || value.length > 20) {
                            return '8-20 caractères requis';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          label: const Text('Téléphone'),
                          hintText: 'Entrez votre numéro',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged:
                                (val) =>
                                    setState(() => agreePersonalData = val!),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: Colors.black),
                                children: [
                                  const TextSpan(
                                    text: "J'accepte le traitement des ",
                                  ),
                                  TextSpan(
                                    text: " données personnelles",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: lightColorScheme.primary,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            // Action lors du clic
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            handleInscription(context);
                          },
                          style: customButtonStyle(context),
                          child: const Text("S'inscrire"),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "S'inscrire avec",
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Logo(Logos.google, size: 35),
                            onPressed: () => signInWithGoogle(context),
                          ),
                          IconButton(
                            icon: Logo(Logos.facebook_f, size: 35),
                            onPressed: () {
                              // À implémenter
                            },
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
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Vous avez déjà un compte ? ",
                            style: TextStyle(color: Colors.black45),
                          ),
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
                              " Se connecter",
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
}
