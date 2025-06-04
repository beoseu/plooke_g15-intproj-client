import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  final String title;
  final String time;
  final int price;
  final String status;
  final VoidCallback? onConfirm;

  const OrderCard({
    super.key,
    required this.title,
    required this.time,
    required this.price,
    required this.status,
    this.onConfirm,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String? fileName;
  String? localStatus; // เพิ่มตัวแปรนี้

  @override
  void initState() {
    super.initState();
    localStatus = widget.status; // กำหนดค่าเริ่มต้น
  }

  void handleConfirm() async {
    // เรียก API ยืนยัน (สมมติว่าทำสำเร็จ)
    // ถ้าใช้ async API จริง ให้รอ response ก่อนค่อย setState
    setState(() {
      localStatus = 'completed'; // เปลี่ยนสถานะเป็น completed
      fileName = null; // reset ไฟล์
    });
    if (widget.onConfirm != null) widget.onConfirm!();
  }

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
          // Price + Status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.price} บาท', style: const TextStyle(fontSize: 16)),
              if (localStatus != 'paid')
                Text(
                  localStatus ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: localStatus == 'completed'
                        ? Colors.green
                        : localStatus == 'in progress'
                            ? Colors.orange
                            : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
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
              // Confirm Button (show only if status is not paid or completed)
              if (localStatus != 'paid' && localStatus != 'completed')
                OutlinedButton(
                  onPressed: fileName != null ? handleConfirm : null,
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
