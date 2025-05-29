import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final double price;
  final VoidCallback? onDetailsPressed;

  const HistoryCard({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    required this.price,
    this.onDetailsPressed,
  });

  // Determine color based on status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'unpaid':
        return Colors.red;
      default:
        return Colors.black45;
    }
  }

  @override
  Widget build(BuildContext context) {
    final parsedDate = DateTime.tryParse(date);
    final timeString =
        parsedDate != null
            ? DateFormat('HH:mm:ss').format(parsedDate.toLocal())
            : 'Invalid date';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 14,
                  color: _getStatusColor(status),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Time
          Text('$timeString GMT+7', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),

          // Price
          Text(
            '${price.toStringAsFixed(0)} บาท',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),

          // Order details button
          GestureDetector(
            onTap: onDetailsPressed,
            child: const Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'order details',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
