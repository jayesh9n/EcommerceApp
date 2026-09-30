import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'addresses_screen.dart';
import 'notifications_screen.dart';
import 'orders_screen.dart';
import 'profile_edit_screen.dart';
import 'recently_ordered_screen.dart';
import 'refund_policy_screen.dart';
import 'shipping_policy_screen.dart';
import 'subscriptions_screen.dart';
import 'wallet_screen.dart';
import 'wishlist_screen.dart';
import 'admin/admin_shell_view.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  static const Color primaryGreen = Color(0xFF00D26A);

  Widget _buildQuickCard(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF111827), size: 26),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF111827), size: 20),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          'Account',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Color(0xFFCBD5E1), size: 36),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Jayesh',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'jayesh9n@gmail.com',
                          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF111827)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3 Quick Cards (Wallet, Notifications, Wishlist)
            Row(
              children: [
                _buildQuickCard(
                  context,
                  icon: Icons.credit_card_outlined,
                  label: 'Wallet',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen())),
                ),
                const SizedBox(width: 12),
                _buildQuickCard(
                  context,
                  icon: Icons.notifications_none,
                  label: 'Notifications',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
                ),
                const SizedBox(width: 12),
                _buildQuickCard(
                  context,
                  icon: Icons.favorite_border,
                  label: 'Wishlist',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WishlistScreen())),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Admin Portal Access Card Block
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A), // Dark elegant background
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 3)),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminShellView()),
                    );
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.shield_outlined, color: Colors.white, size: 24),
                  ),
                  title: const Text(
                    'Admin Portal Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: const Text(
                    'Manage Products, Stock, Orders & Analytics',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: primaryGreen, size: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Orders Card Block
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(width: 5, height: 18, color: primaryGreen),
                          const SizedBox(width: 8),
                          const Text(
                            'Orders',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      context,
                      icon: Icons.shopping_bag_outlined,
                      label: 'Orders',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersScreen())),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.location_on_outlined,
                      label: 'Addresses',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressesScreen())),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.calendar_month_outlined,
                      label: 'Subscriptions',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionsScreen())),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.list_alt_outlined,
                      label: 'Recently Ordered',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RecentlyOrderedScreen())),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Support Card Block
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(width: 5, height: 18, color: primaryGreen),
                          const SizedBox(width: 8),
                          const Text(
                            'Support',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      context,
                      icon: Icons.local_shipping_outlined,
                      label: 'Shipping Policy',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingPolicyScreen())),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.receipt_long_outlined,
                      label: 'Refund Policy',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RefundPolicyScreen())),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
