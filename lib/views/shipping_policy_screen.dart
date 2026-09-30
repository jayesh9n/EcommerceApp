import 'package:flutter/material.dart';

class ShippingPolicyScreen extends StatelessWidget {
  const ShippingPolicyScreen({super.key});

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
          'Shipping Policy',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'Orders are processed within 1–3 business days after payment confirmation and shipped to eligible locations. Delivery times may vary based on location and courier services. Once shipped, tracking details will be provided where available. Customers must provide accurate shipping information. Shipping charges, if applicable, will be displayed during checkout. HIRANIX is not responsible for delays caused by courier partners or circumstances beyond our control.',
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF374151),
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
