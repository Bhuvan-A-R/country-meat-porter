import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/porter_state_service.dart';

class CodCashDepositModal extends StatelessWidget {
  const CodCashDepositModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CodCashDepositModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PorterStateService>();
    final profile = state.profile;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 18),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFBEB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFFD97706), size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COD CASH-IN-HAND & DEPOSIT',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      'Store Hub Cash Handover Management',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Cash-in-hand summary card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TOTAL CASH COLLECTED TODAY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                    const SizedBox(height: 4),
                    Text(
                      '₹${profile.todayCashCollected.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF78350F)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.qr_code_2_rounded, size: 36, color: Color(0xFFD97706)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Store Hub Handover Locations:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 10),

          _StoreHubDepositTile(
            storeName: 'Country Meat Hub - Indiranagar',
            timing: 'Open till 9:30 PM',
            distance: '1.2 km away',
            cashLimit: 'Deposit up to ₹5,000',
          ),
          const SizedBox(height: 10),
          _StoreHubDepositTile(
            storeName: 'Country Meat Express - Whitefield',
            timing: 'Open till 10:00 PM',
            distance: '4.8 km away',
            cashLimit: 'Deposit up to ₹5,000',
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Handover QR code generated for ₹${profile.todayCashCollected.toStringAsFixed(0)}. Present at Store Hub.'),
                    backgroundColor: const Color(0xFF059669),
                  ),
                );
              },
              icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
              label: const Text('GENERATE HUB HANDOVER QR CODE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreHubDepositTile extends StatelessWidget {
  final String storeName;
  final String timing;
  final String distance;
  final String cashLimit;

  const _StoreHubDepositTile({
    required this.storeName,
    required this.timing,
    required this.distance,
    required this.cashLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.storefront_rounded, color: Color(0xFF2563EB), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(storeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                Text('$timing • $distance', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Text(cashLimit, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
        ],
      ),
    );
  }
}
