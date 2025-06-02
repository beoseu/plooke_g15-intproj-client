import 'package:flutter/material.dart';
import 'package:frontend/pages/layout.dart';
import 'package:frontend/components/user/location_card.dart';
import 'package:frontend/pages/user/selectpage.dart';
import 'package:frontend/services/api.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final futureLocations = getLocations();

    return Layout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SELECT PLACE',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            FutureBuilder(
              future: futureLocations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final locations = snapshot.data?['data'] as List? ?? [];

                return Column(
                  children:
                      locations
                          .map(
                            (location) => LocationCard(
                              locationId: location['id'],
                              title: location['name'] ?? 'Unknown',
                              province: location['province'] ?? 'Unknown',
                              wildlife: location['wildlife'] ?? 'Unknown',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => SelectPage(
                                          locationId: location['id'],
                                        ),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
