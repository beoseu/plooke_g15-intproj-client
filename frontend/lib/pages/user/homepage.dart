import 'package:flutter/material.dart';
import 'package:frontend/pages/layout.dart';
import 'package:frontend/components/user/location_card.dart';
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

            // LocationCard 1
            LocationCard(
              title: 'เขาเขียว',
              province: 'ชลบุรี',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const SelectPage(
                          title: 'เขาเขียว',
                          province: 'ชลบุรี',
                        ),
                  ),
                );
              },
            ),

            // LocationCard 2
            LocationCard(
              title: 'หาดพัทยา',
              province: 'ชลบุรี',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const SelectPage(
                          title: 'หาดพัทยา',
                          province: 'ชลบุรี',
                        ),
                  ),
                );
              },
            ),

            // LocationCard 3
            LocationCard(
              title: 'ภูเขาทอง',
              province: 'กรุงเทพฯ',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const SelectPage(
                          title: 'ภูเขาทอง',
                          province: 'กรุงเทพฯ',
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
