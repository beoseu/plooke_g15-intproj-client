import 'package:flutter/material.dart';
import 'package:frontend/pages/layout.dart';
import 'package:frontend/components/user/place_card.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  String? selectedPlant;

  final Map<String, int> plants = {'ควย1': 18, 'ควย2': 25, 'ควย3': 30};

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PlaceCard(title: 'เขาเขียว'),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'SELECT PLANT',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: const Text('PLEASE SELECT'),
                  value: selectedPlant,
                  isExpanded: true,
                  items:
                      plants.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Row(
                            children: [
                              const Icon(Icons.local_florist_rounded),
                              const SizedBox(width: 8),
                              Text(
                                '${entry.key} (${entry.value} ฿)',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPlant = newValue!;
                    });
                  },
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Total: ${selectedPlant != null ? plants[selectedPlant] : 0} Bath',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed:
                  selectedPlant == null
                      ? null
                      : () {
                        // Continue logic here
                      },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('CONTINUE', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
