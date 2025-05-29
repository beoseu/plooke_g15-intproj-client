import 'package:flutter/material.dart';
import 'package:frontend/pages/layout.dart';
import 'package:frontend/components/user/history_card.dart';
import 'package:frontend/components/user/details_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  void showDetailsPopup(BuildContext context) {
    showDialog(context: context, builder: (context) => const DetailsCard());
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'HISTORY',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            HistoryCard(
              title: 'เขาเขียว',
              date: '2023-10-01',
              status: 'Completed',
              price: 100.0,
              onDetailsPressed: () {
                showDetailsPopup(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
