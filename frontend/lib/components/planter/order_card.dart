import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  final String title;
  final String time;
  final int price;

  const OrderCard({
    super.key,
    required this.title,
    required this.time,
    required this.price,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String? fileName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.time, style: const TextStyle(fontSize: 14)),
            ],
          ),

          const SizedBox(height: 8),
          Text('${widget.price} บาท', style: const TextStyle(fontSize: 16)),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Upload Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('upload proof', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        fileName = 'uploaded_image.jpg'; // simulate
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.cloud_upload, size: 24),
                    ),
                  ),
                ],
              ),

              // Confirm Button
              OutlinedButton(
                onPressed: fileName != null ? () {} : null,
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
            ],
          ),
        ],
      ),
    );
  }
}
