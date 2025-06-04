import 'package:flutter/material.dart';
import 'package:frontend/pages/layout.dart';
import 'package:frontend/pages/user/sumpage.dart';
import 'package:frontend/services/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PayPage extends StatefulWidget {
  final String plantName;
  final int price;
  final String locationTitle;
  final String locationProvince;
  final int orderId; // <-- Add orderId to constructor

  const PayPage({
    super.key,
    required this.plantName,
    required this.price,
    required this.locationTitle,
    required this.locationProvince,
    required this.orderId, // <-- Add orderId to constructor
  });

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  String? fileName;

  Future<void> confirmPayment() async {
    final orderId = widget.orderId;
    final response = await postConfirmPayment(orderId, fileName ?? "receipt_image.jpg");
    if (!mounted) return; // <-- Guard context after async gap
    if (response['status'] == 'success') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SumPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment failed')),
      );
    }
  }

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
                'PAYMENT',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Static image placeholder (gray box)
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              const SizedBox(height: 32),

              // File name (shown only after "upload")
              if (fileName != null) ...[
                Text(
                  fileName!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Upload button
              GestureDetector(
                onTap: () {
                  setState(() {
                    fileName = 'receipt_image.jpg';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.cloud_upload, size: 32),
                ),
              ),

              const SizedBox(height: 8),
              const Text('upload receipt', style: TextStyle(fontSize: 14)),

              const SizedBox(height: 40),

              // Price
              Text(
                'Total: ${widget.price} Bath',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: fileName != null
                    ? confirmPayment
                    : null,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                child: const Text('CONFIRM', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
