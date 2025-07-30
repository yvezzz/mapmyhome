import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapmyhome/themes/theme.dart';

class ConnexionNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onValueChanged;

  const ConnexionNavbar({
    super.key,
    required this.currentIndex,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<int>(
      groupValue: currentIndex,
      onValueChanged: (int? newIndex) {
        if (newIndex != null) {
          onValueChanged(newIndex);
        }
      },
      backgroundColor: Colors.grey.shade100,
      thumbColor: lightColorScheme.primary,
      children: <int, Widget>{
        0: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Client",
            style: TextStyle(
              color: currentIndex == 0 ? Colors.white : lightColorScheme.primary,
            ),
          ),
        ),
        1: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Propriétaire",
            style: TextStyle(
              color: currentIndex == 1 ? Colors.white : lightColorScheme.primary,
            ),
          ),
        ),
        2: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Admin",
            style: TextStyle(
              color: currentIndex == 2 ? Colors.white : lightColorScheme.primary,
            ),
          ),
        ),
      },
    );
  }
}
