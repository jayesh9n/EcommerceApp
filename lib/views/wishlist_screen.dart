import 'package:flutter/material.dart';
import 'widgets/empty_state_widget.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Wishlist',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: const EmptyStateWidget(
        title: 'Oh, no!',
        message: 'There are no items in the wishlist.',
        subMessage: 'To add items to wishlist, click on the heart icon.',
      ),
    );
  }
}
