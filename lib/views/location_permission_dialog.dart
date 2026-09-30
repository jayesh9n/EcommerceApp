import 'package:flutter/material.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const LocationPermissionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on_outlined, color: Color(0xFF2563EB), size: 36),
            const SizedBox(height: 16),
            const Text(
              'Allow Hiranix to access this device\'s location?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 20),

            // Precise vs Approximate Circle Previews
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF2563EB), width: 2),
                        color: const Color(0xFFEFF6FF),
                      ),
                      child: const Center(
                        child: Icon(Icons.location_on, color: Color(0xFF2563EB), size: 32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Precise', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                        color: const Color(0xFFF8FAFC),
                      ),
                      child: const Center(
                        child: Icon(Icons.map_outlined, color: Color(0xFFF59E0B), size: 32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Approximate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'While using the app',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Only this time',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Don\'t allow',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
