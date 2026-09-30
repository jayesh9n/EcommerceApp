import 'package:flutter/material.dart';
import 'orders_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final double amount;
  final String paymentMethod;

  const OrderSuccessScreen({
    super.key,
    this.orderId = '5989',
    this.amount = 16634.46,
    this.paymentMethod = 'BT',
  });

  static const Color primaryGreen = Color(0xFF00D26A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Big Green Checkmark Icon Circle
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'Congratulations!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We\'ve received your order!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Thank you!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 36),

              // Order Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        orderId,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Order ID',
                        style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '₹${amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Amount',
                        style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        paymentMethod,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Payment',
                        style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Continue Shopping Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrdersScreen()),
                  );
                },
                child: const Text(
                  'Go to Orders',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
