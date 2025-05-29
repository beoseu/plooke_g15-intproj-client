import 'package:flutter/material.dart';
import 'package:frontend/pages/p_layout.dart';
import 'package:frontend/components/planter/order_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return PLayout(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ORDER',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            OrderCard(title: 'เขาเขียว', time: '2023-10-01', price: 100),
          ],
        ),
      ),
    );
    ;
  }
}
