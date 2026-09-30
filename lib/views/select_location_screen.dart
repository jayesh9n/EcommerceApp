import 'package:flutter/material.dart';
import 'location_permission_dialog.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key});

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add or select a location',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search box
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Use current location row
                  ListTile(
                    onTap: () {
                      LocationPermissionDialog.show(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE6F9F0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.my_location, color: primaryGreen, size: 22),
                    ),
                    title: const Text(
                      'Use your current location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: primaryGreen,
                      ),
                    ),
                    subtitle: const Text(
                      'Mark your location using the map',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Saved locations
                  const Text(
                    'Saved locations',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 12),

                  ListTile(
                    onTap: () => Navigator.pop(context),
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.home, color: Color(0xFF1E293B), size: 24),
                    title: const Text(
                      'Home',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF111827)),
                    ),
                    subtitle: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2),
                        Text(
                          'Jayesh, +91 8160966370',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '2HFC+2G3, Narolgam, Narolgam, Ahmedabad, Gujarat, India - 380006',
                          style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Recent locations
                  const Text(
                    'Recent locations',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 12),

                  ListTile(
                    onTap: () => Navigator.pop(context),
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.map, color: primaryGreen, size: 24),
                    title: const Text(
                      'Ahmedabad',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF111827)),
                    ),
                    subtitle: const Text(
                      'Gujarat, India',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Google branding footer
          Padding(
            padding: const EdgeInsets.only(bottom: 24, top: 8),
            child: Column(
              children: [
                const Text('powered by', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                const SizedBox(height: 2),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: 'G', style: TextStyle(color: Color(0xFF4285F4))),
                      TextSpan(text: 'o', style: TextStyle(color: Color(0xFFEA4335))),
                      TextSpan(text: 'o', style: TextStyle(color: Color(0xFFFBBC05))),
                      TextSpan(text: 'g', style: TextStyle(color: Color(0xFF4285F4))),
                      TextSpan(text: 'l', style: TextStyle(color: Color(0xFF34A853))),
                      TextSpan(text: 'e', style: TextStyle(color: Color(0xFFEA4335))),
                    ],
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
