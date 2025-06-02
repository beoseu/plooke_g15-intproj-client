import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/signin.dart';
import 'package:frontend/services/api.dart';

class Header extends StatelessWidget {
  final bool showBackButton;
  
  const Header({
    super.key,
    this.showBackButton = false,
  });

  Future<void> _logout(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Call logout API
      await ApiService.post('logout', {});

      // Navigate to login page and remove all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
        (route) => false,
      );
    } catch (e) {
      // Close loading dialog if still mounted
      if (context.mounted) Navigator.of(context).pop();

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

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
                // Left-aligned back button (conditionally shown)
                if (showBackButton)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black,),
                      tooltip: 'Back',
                    ),
                  ),
                
                // Centered title
                const Align(
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
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout, size: 28),
                    tooltip: 'Logout',
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(thickness: 1),
        ),
      ],
    );
  }
}