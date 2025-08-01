import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mapmyhome/screens/ecran_inscription.dart';
import 'package:mapmyhome/themes/theme.dart';
import 'package:mapmyhome/widgets/methode.dart';

class ConnexionForm extends StatefulWidget {
  const ConnexionForm({super.key});

  @override
  State<ConnexionForm> createState() => _ConnexionFormState();
}

class _ConnexionFormState extends State<ConnexionForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
            obscureText: obscureText,
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
                  obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
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
                if (formKey.currentState!.validate()) {
                  login(context);
                }
              },
              style: customButtonStyle(context),
              child: const Text("Connexion"),
            ),
          ),
          const SizedBox(height: 25.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Divider(thickness: 0.7, color: Colors.grey)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Se connecter avec",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              Expanded(child: Divider(thickness: 0.7, color: Colors.grey)),
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
                    MaterialPageRoute(builder: (_) => const EcranInscription()),
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
    );
  }
}
