import 'package:flutter/material.dart';
import 'package:frontend/components/header.dart';
import 'package:frontend/components/p_navbar.dart';

class PLayout extends StatelessWidget {
  final Widget child;
  final bool showHeader;
  final bool showNav;

  const PLayout({
    super.key,
    required this.child,
    this.showHeader = true,
    this.showNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            if (showHeader) const Header(),
            Expanded(child: child),
            if (showNav) const PnavBar(),
          ],
        ),
      ),
    );
  }
}
