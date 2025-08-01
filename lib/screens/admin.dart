import 'package:flutter/material.dart';
import 'package:mapmyhome/widgets/methode.dart';
import 'package:mapmyhome/widgets/connexion_form.dart';


class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
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
                child: const ConnexionForm(),
              ),
            ),
          );
        },
      ),
    );
  }
}
