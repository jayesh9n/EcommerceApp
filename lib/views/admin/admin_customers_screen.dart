import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminCustomersScreen extends StatelessWidget {
  const AdminCustomersScreen({super.key});

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    final mockCustomers = [
      {
        'name': 'Jayesh Patel',
        'email': 'jayesh9n@gmail.com',
        'phone': '+91 8160966370',
        'city': 'Ahmedabad, Gujarat',
        'orders': 3,
        'spent': 16634.46,
      },
      {
        'name': 'Ramesh Hardware & Tools',
        'email': 'ramesh.hardware@example.com',
        'phone': '+91 9876543210',
        'city': 'Surat, Gujarat',
        'orders': 8,
        'spent': 124500.00,
      },
      {
        'name': 'Anil Electricals',
        'email': 'anil.elec@example.com',
        'phone': '+91 9123456789',
        'city': 'Vadodara, Gujarat',
        'orders': 2,
        'spent': 21864.00,
      },
      {
        'name': 'Gujarat Enterprise',
        'email': 'info@gujaraten.com',
        'phone': '+91 9988776655',
        'city': 'Rajkot, Gujarat',
        'orders': 5,
        'spent': 64200.00,
      },
    ];

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
                'Customers & Accounts',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              SizedBox(height: 4),
              Text(
                'Registered B2B buyers, wholesalers, and retail store contacts',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Customer Data Table
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
                  DataColumn(label: Text('Customer Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Contact Number', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Location', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Total Orders', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Total Spent', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: mockCustomers.map((c) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person, color: Color(0xFF64748B), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text(c['email'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(c['phone'] as String)),
                      DataCell(Text(c['city'] as String)),
                      DataCell(Text('${c['orders']} orders')),
                      DataCell(
                        Text(
                          currencyFormat.format(c['spent'] as double),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: primaryGreen),
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
