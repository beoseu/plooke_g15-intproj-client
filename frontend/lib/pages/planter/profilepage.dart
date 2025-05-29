import 'package:flutter/material.dart';
import 'package:frontend/pages/p_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? qrCodeFile;

  @override
  Widget build(BuildContext context) {
    return PLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'PROFILE',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 30),

              const Text(
                'QR CODE CHANGE',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: () {
                  setState(() {
                    qrCodeFile = 'new_qr.png'; // Simulate upload
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.cloud_upload, size: 30),
                ),
              ),
              const SizedBox(height: 30),

              OutlinedButton(
                onPressed: qrCodeFile != null ? () {} : null,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                child: const Text('CONFIRM'),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  // Handle delete logic here
                },
                child: const Text(
                  'DELETE ACCOUNT',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
