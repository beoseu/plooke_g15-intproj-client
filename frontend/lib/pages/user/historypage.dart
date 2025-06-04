import 'package:flutter/material.dart';
import 'package:frontend/pages/layout.dart';
import 'package:frontend/components/user/history_card.dart';
import 'package:frontend/services/api.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> orders = [];
  bool isLoading = true;
  int? selectedOrderIndex;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final result = await getOrders();
      final List<dynamic> rawOrders = result['data']?['orders'] ?? [];

      final mappedOrders = rawOrders.map((order) {
        return {
          'id': order['id'], // <-- เพิ่มบรรทัดนี้
          'locationName': order['location']?['name'] ?? '',
          'date': order['date'] ?? '',
          'status': order['status'] ?? '',
          'plantPrice': order['plant']?['price'] ?? 0,
        };
      }).toList();
      setState(() {
        orders = mappedOrders;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
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
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (orders.isEmpty)
              const Center(child: Text('No order history found.'))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final rawDate = order['date'] ?? '';
                    String formattedDateTime = '';
                    if (rawDate.isNotEmpty) {
                      final dt = DateTime.tryParse(rawDate);
                      if (dt != null) {
                        formattedDateTime = DateFormat(
                          'yyyy-MM-dd HH:mm',
                        ).format(dt);
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HistoryCard(
                          title: order['locationName'] ?? '',
                          date: formattedDateTime,
                          status: order['status'] ?? '',
                          price: order['plantPrice']?.toDouble() ?? 0.0,
                          onDetailsPressed: () {
                            setState(() {
                              selectedOrderIndex = selectedOrderIndex == index ? null : index;
                            });
                          },
                        ),
                        if (selectedOrderIndex == index)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                            child: DetailsCard(
                              order: order,
                              onClose: () {
                                setState(() {
                                  selectedOrderIndex = null;
                                });
                              },
                              onStatusChanged: fetchOrders, // <-- เพิ่มบรรทัดนี้
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DetailsCard extends StatefulWidget {
  final VoidCallback? onClose;
  final Map<String, dynamic>? order;
  final VoidCallback? onStatusChanged; // <-- เพิ่ม

  const DetailsCard({Key? key, this.onClose, this.order, this.onStatusChanged}) : super(key: key);

  @override
  State<DetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  String? fileName;
  bool isConfirming = false;

  Future<void> confirmOrder() async {
    setState(() {
      isConfirming = true;
    });
    try {
      final orderId = widget.order?['id'];
      if (orderId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No order id')),
        );
        return;
      }
      final response = await postConfirmPayment(orderId, fileName ?? "receipt_image.jpg");
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Confirm success')),
        );
        widget.onStatusChanged?.call();
        widget.onClose?.call(); // <-- เพิ่มบรรทัดนี้
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Confirm failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isConfirming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    if (order == null) return const SizedBox.shrink();
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: widget.onClose),
              ],
            ),
            const SizedBox(height: 16),
            Text('Location: ${order['locationName']}'),
            Text('Date: ${order['date']}'),
            Text('Status: ${order['status']}'),
            Text('Price: \$${order['plantPrice']}'),
            const SizedBox(height: 8),
            // แสดงปุ่ม DELETE เฉพาะ status == 'unpaid'
            if (order['status'] == 'unpaid')
              ElevatedButton(
                onPressed: isConfirming
                    ? null
                    : () async {
                        final orderId = widget.order?['id'];
                        if (orderId == null) return;
                        setState(() => isConfirming = true);
                        try {
                          final response = await deleteOrder(orderId);
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Order deleted')),
                            );
                            widget.onStatusChanged?.call();
                            widget.onClose?.call();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response['message'] ?? 'Delete failed')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        } finally {
                          setState(() => isConfirming = false);
                        }
                      },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
                child: const Text('DELETE', style: TextStyle(fontSize: 16)),
              ),
            const SizedBox(height: 16),
            // Upload & Confirm button
            if (order['status'] == 'unpaid')
              Row(
                children: [
                  // Upload button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        fileName = 'receipt_image.jpg';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.cloud_upload, size: 32),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // File name (ใช้ Flexible)
                  if (fileName != null)
                    Flexible(
                      child: Text(
                        fileName!,
                        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(width: 8),
                  // Confirm button
                  ElevatedButton(
                    onPressed: (fileName != null && !isConfirming) ? confirmOrder : null,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                    child: isConfirming
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('CONFIRM', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
