import 'package:flutter/material.dart';
import 'package:frontend/pages/user/homepage.dart';
import 'package:frontend/pages/user/historypage.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  bool _isCurrentRoute(BuildContext context, String routeName) {
    final route = ModalRoute.of(context);
    return route?.settings.name == routeName;
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
                      if (!_isCurrentRoute(context, '/home')) {
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
                      if (!_isCurrentRoute(context, '/history')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: const RouteSettings(name: '/history'),
                            builder: (context) => const HistoryPage(),
                          ),
                        );
                      }
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
