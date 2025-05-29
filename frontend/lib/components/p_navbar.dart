import 'package:flutter/material.dart';
import 'package:frontend/pages/planter/orderpage.dart';
import 'package:frontend/pages/planter/profilepage.dart';

class PnavBar extends StatelessWidget {
  const PnavBar({super.key});

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
                      if (!_isCurrentRoute(context, '/order')) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            settings: const RouteSettings(name: '/order'),
                            builder: (context) => const OrderPage(),
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
                      if (!_isCurrentRoute(context, '/profile')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: const RouteSettings(name: '/profile'),
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.person, size: 28),
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
