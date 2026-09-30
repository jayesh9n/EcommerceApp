import 'package:flutter/material.dart';
import 'admin_dashboard_screen.dart';
import 'admin_products_screen.dart';
import 'admin_categories_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_customers_screen.dart';

class AdminShellView extends StatefulWidget {
  const AdminShellView({super.key});

  static const Color primaryGreen = Color(0xFF00D26A);
  static const Color sidebarBg = Color(0xFF0F172A);

  @override
  State<AdminShellView> createState() => _AdminShellViewState();
}

class _AdminShellViewState extends State<AdminShellView> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard_outlined, 'activeIcon': Icons.dashboard},
    {'title': 'Products', 'icon': Icons.inventory_2_outlined, 'activeIcon': Icons.inventory_2},
    {'title': 'Categories', 'icon': Icons.grid_view_outlined, 'activeIcon': Icons.grid_view_rounded},
    {'title': 'Orders', 'icon': Icons.shopping_bag_outlined, 'activeIcon': Icons.shopping_bag},
    {'title': 'Customers', 'icon': Icons.people_outline, 'activeIcon': Icons.people},
  ];

  final List<Widget> _adminPages = const [
    AdminDashboardScreen(),
    AdminProductsScreen(),
    AdminCategoriesScreen(),
    AdminOrdersScreen(),
    AdminCustomersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          // Left Sidebar Navigation
          Container(
            width: 250,
            color: AdminShellView.sidebarBg,
            child: Column(
              children: [
                // Brand Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AdminShellView.primaryGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.shield_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HIRANIX',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            'Admin Portal',
                            style: TextStyle(
                              color: AdminShellView.primaryGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF334155), height: 1),
                const SizedBox(height: 16),

                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = _selectedIndex == index;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? AdminShellView.primaryGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () => setState(() => _selectedIndex = index),
                          leading: Icon(
                            isSelected ? item['activeIcon'] : item['icon'],
                            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                            size: 22,
                          ),
                          title: Text(
                            item['title'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Return to Storefront Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF475569)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.storefront, size: 20),
                      label: const Text('Store Front', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Admin Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _menuItems[_selectedIndex]['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const Spacer(),
                      // Admin Profile Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: AdminShellView.primaryGreen,
                              child: Icon(Icons.person, color: Colors.white, size: 16),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Admin Mode (Jayesh)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Active Admin Page
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _adminPages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
