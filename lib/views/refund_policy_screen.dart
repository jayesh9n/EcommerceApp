import 'package:flutter/material.dart';

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});

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
          'Refund Policy',
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
          'HIRANIX follows a No Refund Policy for shipped or delivered orders. Refunds are only available for orders cancelled before shipment, failed transactions, or orders cancelled by HIRANIX. Approved refunds will be processed to the original payment method within 5–10 business days.',
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
