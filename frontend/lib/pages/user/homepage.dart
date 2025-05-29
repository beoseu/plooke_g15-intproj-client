import 'package:flutter/material.dart';
import 'package:frontend/pages/layout.dart';
import 'package:frontend/components/user/place_card.dart';
import 'package:frontend/pages/user/selectpage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SELECT PLACE',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            PlaceCard(
              title: 'เขาเขียว',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectPage()),
                );
              },
            ),
            PlaceCard(title: 'หีหมาดำ', onTap: () {}),
            PlaceCard(title: 'อ่าวหาโคตรแม่มึงติ', onTap: () {}),
          ],
        ),
      ),
    );
  }
}
