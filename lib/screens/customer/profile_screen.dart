import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/country_meat_state.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CountryMeatStateService>();
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile & Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            CircleAvatar(
              radius: 40,
              backgroundColor: primary,
              child: const Text('A', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            const Text('Ananya Sharma', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('+91 98765 43210 • ananya@example.com', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),

            // Meat Cash Wallet Banner
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.account_balance_wallet, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('MeatCash Balance', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                          Text('₹150.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Use in Cart'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Profile Options Card
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined, color: Colors.redAccent),
                    title: const Text('Saved Addresses'),
                    subtitle: Text(state.selectedLocation, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.receipt_long_outlined, color: Colors.blue),
                    title: const Text('Order History & Invoices'),
                    subtitle: const Text('View past 12 fresh meat deliveries'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.card_giftcard_rounded, color: Colors.purple),
                    title: const Text('Refer & Earn ₹100'),
                    subtitle: const Text('Invite friends to Country Meat'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.headset_mic_outlined, color: Colors.green),
                    title: const Text('Customer Support & FAQs'),
                    subtitle: const Text('Chat with us or call support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out of Country Meat')),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text('Log Out', style: TextStyle(color: Colors.redAccent)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
