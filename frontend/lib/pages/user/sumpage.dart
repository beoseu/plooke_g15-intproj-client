import 'package:flutter/material.dart';
import 'package:frontend/pages/layout.dart';

class SumPage extends StatefulWidget {
  const SumPage({super.key});

  @override
  State<SumPage> createState() => _SumPageState();
}

class _SumPageState extends State<SumPage> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              const Text(
                'ORDER PLACED !',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Please wait our Planter to Plant',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
