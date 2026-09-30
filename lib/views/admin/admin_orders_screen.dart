import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../controllers/admin_providers.dart';

class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key});

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen> {
  final _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
  final _dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

  void _showUpdateStatusDialog(AdminOrderModel order) {
    String selectedStatus = order.status;
    final statuses = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text('Update Order Status: ${order.id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: ${order.customerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Amount: ${_currencyFormat.format(order.totalAmount)}'),
              const SizedBox(height: 16),
              const Text('Select New Status:', style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) {
                  if (val != null) setModalState(() => selectedStatus = val);
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                ref.read(adminOrdersProvider.notifier).updateOrderStatus(order.id, selectedStatus);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order status updated to $selectedStatus!'),
                    backgroundColor: AdminOrdersScreen.primaryGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AdminOrdersScreen.primaryGreen, foregroundColor: Colors.white),
              child: const Text('Update Status'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(adminOrdersProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Orders Management',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              SizedBox(height: 4),
              Text(
                'Track wholesale orders, update shipping progress, and review payment details',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Orders Data Table
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
                dataRowHeight: 70,
                columns: const [
                  DataColumn(label: Text('Order ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Customer Info', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: orders.map((order) {
                  Color statusColor;
                  switch (order.status) {
                    case 'Delivered':
                      statusColor = AdminOrdersScreen.primaryGreen;
                      break;
                    case 'Shipped':
                      statusColor = const Color(0xFF3B82F6);
                      break;
                    case 'Processing':
                      statusColor = const Color(0xFFF59E0B);
                      break;
                    default:
                      statusColor = const Color(0xFFEF4444);
                  }

                  return DataRow(
                    cells: [
                      DataCell(Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(order.phone, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      DataCell(Text(_dateFormat.format(order.date), style: const TextStyle(fontSize: 12))),
                      DataCell(
                        Text(
                          _currencyFormat.format(order.totalAmount),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataCell(Text(order.paymentMethod)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          onPressed: () => _showUpdateStatusDialog(order),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F4F6),
                            foregroundColor: const Color(0xFF111827),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Update Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
