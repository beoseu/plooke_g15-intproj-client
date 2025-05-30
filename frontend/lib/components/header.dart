import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  
  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: Stack(
              children: [
                // Centered title
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'PLOOKE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                // Right-aligned logout icon
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      // Add logout logic here
                    },
                    icon: Icon(Icons.logout, size: 28),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Divider(thickness: 1),
        ),
      ],
    );
  }
}
