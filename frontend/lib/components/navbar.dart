import 'package:flutter/material.dart';
import 'package:frontend/pages/user/homepage.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  bool _isCurrentRouteHome(BuildContext context) {
    final route = ModalRoute.of(context);
    return route?.settings.name == '/home';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(thickness: 1),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: Stack(
              children: [
                // Home icon centered
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      // Prevent pushing if already on HomePage
                      if (!_isCurrentRouteHome(context)) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            settings: const RouteSettings(name: '/home'),
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.home, size: 32),
                  ),
                ),
                // Receipt icon on right
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      // Navigate to receipt/history
                    },
                    icon: const Icon(Icons.receipt_long, size: 28),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
