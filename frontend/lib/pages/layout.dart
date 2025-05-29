import 'package:flutter/material.dart';
import 'package:frontend/components/header.dart';
import 'package:frontend/components/navbar.dart';

class Layout extends StatelessWidget {
  final Widget child;
  final bool showHeader;
  final bool showNav;

  const Layout({
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
            if (showNav) const NavBar(),
          ],
        ),
      ),
    );
  }
}
