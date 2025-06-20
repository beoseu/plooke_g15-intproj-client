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
  Map<String, Map<String, dynamic>> plantMap = {}; // name -> {id, price}
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
        plantMap = {
          for (var plant in data)
            plant['name']: {
              'id': plant['id'],
              'price': plant['price'],
            }
        };
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

  Future<dynamic> postOrder(int locationId, int plantId) async {
    return await ApiService.post('orders/create', {
      'location_id': locationId,
      'plant_id': plantId,
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalPrice = (selectedPlantName != null && plantMap[selectedPlantName] != null)
        ? (plantMap[selectedPlantName]!['price'] ?? 0)
        : 0;

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
                        '${locationData?['wildlife'] ?? 'Unknown'}',
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
                        items: plantMap.entries.map((entry) {
                          final name = entry.key;
                          final price = entry.value['price'];
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Row(
                              children: [
                                const Icon(Icons.local_florist_rounded),
                                const SizedBox(width: 8),
                                Text('$name ($price ฿)'),
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
              onPressed: selectedPlantName == null
                  ? null
                  : () async {
                      final selected = plantMap[selectedPlantName]!;
                      final plantId = selected['id'];
                      final price = selected['price'];

                      try {
                        final response = await postOrder(widget.locationId, plantId);
                        final orderId = response['data']?['order']?['id'];

                        if (orderId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order creation failed: No order id')),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PayPage(
                              plantName: selectedPlantName!,
                              price: price,
                              locationTitle: locationData?['name'] ?? '',
                              locationProvince: locationData?['province'] ?? '',
                              orderId: orderId,
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