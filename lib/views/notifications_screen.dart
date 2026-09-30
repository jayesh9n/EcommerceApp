import 'package:flutter/material.dart';
import 'widgets/empty_state_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTab = 0;
  static const Color primaryGreen = Color(0xFF00D26A);

  final List<Map<String, String>> _generalNotifications = const [
    {
      'title': 'स्टॉक कम है 📦',
      'body': 'आवश्यक मात्रा के लिए समय रहते ऑर्डर करें।',
      'time': 'Sep 22, 2026 2:48 PM',
    },
    {
      'title': 'जो डर गया, समझो 🤫',
      'body': 'रेट बढ़ने से पहले ऑर्डर कर गया! 😎',
      'time': 'Sep 21, 2026 1:11 PM',
    },
    {
      'title': 'रेट का मूड बदल सकता है!😈',
      'body': 'ऑर्डर अभी कर लीजिए।😉',
      'time': 'Sep 19, 2026 2:06 PM',
    },
    {
      'title': 'RAW MATERIAL RATES⬆️',
      'body': 'our stock⬇️',
      'time': 'Sep 18, 2026 5:50 PM',
    },
    {
      'title': '5 minutes to go live🔥',
      'body': 'Be quick or wait for "notify me" option😉',
      'time': 'Sep 18, 2026 4:54 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 0 ? primaryGreen : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'General',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _selectedTab == 0 ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 1 ? primaryGreen : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'My Notifications',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _selectedTab == 1 ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedTab == 0
                ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _generalNotifications.length,
                    itemBuilder: (context, index) {
                      final item = _generalNotifications[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x05000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F4F6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_none,
                                color: Color(0xFF111827),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['body']!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF4B5563),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['time']!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const EmptyStateWidget(
                    title: 'Oh, no!',
                    message: 'No personal notifications found.',
                  ),
          ),
        ],
      ),
    );
  }
}
