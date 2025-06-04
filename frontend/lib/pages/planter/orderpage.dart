import 'package:flutter/material.dart';
import 'package:frontend/pages/p_layout.dart';
import 'package:frontend/components/planter/order_card.dart';
import 'package:frontend/services/api.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      final result = await getOrders();
      if (result['status'] != 'success') {
        throw Exception(result['message'] ?? 'Failed to fetch orders');
      }

      final List<dynamic> rawOrders = result['data']?['orders'] ?? [];
      
      final mappedOrders = rawOrders.map((order) {
        return {
          'id': order['id'],
          'status': order['status'],
          'title': order['location']?['name'] ?? 'Unknown location',
          'time': order['date'] ?? '',
          'price': order['plant']?['price'] ?? 0,
        };
      }).toList();

      setState(() {
        orders = List<Map<String, dynamic>>.from(mappedOrders);
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> confirmOrder(int orderId) async {
    try {
      final response = await postOrderConfirm(orderId, "example_plated.jpg");
      if (response['status'] != 'success') {
        throw Exception(response['message'] ?? 'Failed to confirm order');
      }

      setState(() {
        final idx = orders.indexWhere((o) => o['id'] == orderId);
        if (idx != -1) {
          orders[idx]['status'] = 'paid';
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order confirmed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming order: ${e.toString()}')),
      );
    }
  }

  String _formatOrderTime(String timeString) {
    if (timeString.isEmpty) return 'No time specified';
    
    final dt = DateTime.tryParse(timeString);
    if (dt == null) return 'Invalid date format';
    
    return DateFormat('yyyy-MM-dd HH:mm').format(dt);
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchOrders,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (orders.isEmpty) {
      return const Center(child: Text('No orders found.'));
    }
    
    return RefreshIndicator(
      onRefresh: fetchOrders,
      child: ListView.separated(
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            title: order['title'],
            time: _formatOrderTime(order['time']),
            price: order['price'],
            status: order['status'],
            onConfirm: () => confirmOrder(order['id']),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PLayout(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ORDERS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }
}