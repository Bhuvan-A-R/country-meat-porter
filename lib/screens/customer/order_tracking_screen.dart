import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerOrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const CustomerOrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status #$orderId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ETA Countdown Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, Colors.red.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.bolt, color: Colors.amber, size: 20),
                      SizedBox(width: 6),
                      Text('EXPRESS 30 MIN DELIVERY', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Arriving in 18 Mins', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Delivery Partner Rajesh is on the way to your door!', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Live Map Simulation View
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.navigation_rounded, size: 48, color: primary),
                    const SizedBox(height: 8),
                    const Text('Live Porter GPS Tracking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text('Indiranagar Store ➔ Your Location (2.4 km)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Driver Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: primary,
                      child: const Icon(Icons.two_wheeler, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rajesh Kumar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('Country Meat Express Porter • 4.9 ★', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.green),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Calling Porter Rajesh Kumar (+91 98765 43210)...')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Step Progress Timeline
            const Text('Order Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    _TimelineStepTile(
                      title: 'Order Placed & Confirmed',
                      subtitle: 'Store received your order at 11:30 AM',
                      isCompleted: true,
                      isCurrent: false,
                    ),
                    Divider(height: 16),
                    _TimelineStepTile(
                      title: 'Fresh Cut & Temperature Checked ❄️',
                      subtitle: 'Antibiotic-free meat packed with ice chill gel',
                      isCompleted: true,
                      isCurrent: false,
                    ),
                    Divider(height: 16),
                    _TimelineStepTile(
                      title: 'Out for Delivery 🛵',
                      subtitle: 'Porter Rajesh picked up order from Indiranagar Hub',
                      isCompleted: false,
                      isCurrent: true,
                    ),
                    Divider(height: 16),
                    _TimelineStepTile(
                      title: 'Delivered to Doorstep',
                      subtitle: 'Contactless delivery at Indiranagar 100ft Rd',
                      isCompleted: false,
                      isCurrent: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _TimelineStepTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;

  const _TimelineStepTile({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor = Colors.grey;
    if (isCompleted) iconColor = Colors.green;
    if (isCurrent) iconColor = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : (isCurrent ? Icons.radio_button_checked : Icons.radio_button_unchecked),
          color: iconColor,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isCurrent || isCompleted ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent ? Theme.of(context).colorScheme.primary : null,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
