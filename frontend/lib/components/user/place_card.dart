import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const PlaceCard({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.black12,
          highlightColor: Colors.black12,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
