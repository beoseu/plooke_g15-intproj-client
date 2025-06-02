import 'package:flutter/material.dart';
import 'package:frontend/pages/layout.dart';
import 'package:frontend/components/user/location_card.dart';
import 'package:frontend/pages/user/paypage.dart';
import 'package:frontend/services/api.dart';

class SelectPage extends StatefulWidget {
  final int locationId;

  const SelectPage({super.key, required this.locationId});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  String? selectedPlantName;
  Map<String, int> plantMap = {}; // name -> price
  Map<String, dynamic>? locationData;

  bool isLoadingPlants = true;
  bool isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    fetchPlants();
    fetchLocation();
  }

  Future<void> fetchPlants() async {
    try {
      final result = await getPlants();
      final List data = result['data'] ?? [];

      setState(() {
        plantMap = {for (var plant in data) plant['name']: plant['price']};
        isLoadingPlants = false;
      });
    } catch (e) {
      print('Error fetching plants: $e');
      setState(() => isLoadingPlants = false);
    }
  }

  Future<void> fetchLocation() async {
    try {
      final result = await getLocationById(widget.locationId);
      setState(() {
        locationData = result['data'];
        isLoadingLocation = false;
      });
    } catch (e) {
      print('Error fetching location: $e');
      setState(() => isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalPrice =
        selectedPlantName != null ? plantMap[selectedPlantName] ?? 0 : 0;

    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            isLoadingLocation
                ? const Center(child: CircularProgressIndicator())
                : LocationCard(
                  locationId: widget.locationId,
                  title: locationData?['name'] ?? 'Unknown',
                  province: locationData?['province'] ?? 'Unknown',
                  wildlife:
                      'Wildlife: ${locationData?['wildlife'] ?? 'Unknown'}',
                  onTap: () {},
                ),
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

            isLoadingPlants
                ? const Center(child: CircularProgressIndicator())
                : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: const Text('PLEASE SELECT'),
                      value: selectedPlantName,
                      isExpanded: true,
                      items:
                          plantMap.entries.map((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Row(
                                children: [
                                  const Icon(Icons.local_florist_rounded),
                                  const SizedBox(width: 8),
                                  Text('${entry.key} (${entry.value} ฿)'),
                                ],
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPlantName = newValue;
                        });
                      },
                    ),
                  ),
                ),

            const Spacer(),
            Text(
              'Total: $totalPrice Bath',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed:
                  selectedPlantName == null
                      ? null
                      : () async {
                        final selectedPrice = plantMap[selectedPlantName]!;
                        try {
                          await postOrder(widget.locationId, selectedPrice);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PayPage(
                                    plantName: selectedPlantName!,
                                    price: selectedPrice,
                                    locationTitle: locationData?['name'] ?? '',
                                    locationProvince:
                                        locationData?['province'] ?? '',
                                  ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Order failed: $e')),
                          );
                        }
                      },
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
              child: const Text('ORDER', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
