import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/porter_state_service.dart';

class CodCashDepositModal extends StatefulWidget {
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
  State<CodCashDepositModal> createState() => _CodCashDepositModalState();
}

class _CodCashDepositModalState extends State<CodCashDepositModal>
    with WidgetsBindingObserver {
  String? _selectedPaymentMethod;
  bool _isPaymentSuccessful = false;
  bool _externalPaymentOpened = false;
  bool _returnedFromExternalPayment = false;

  static const _paymentMethods = [
    ('Google Pay', Icons.account_balance_wallet_rounded),
    ('PhonePe', Icons.phone_android_rounded),
    ('Paytm', Icons.currency_rupee_rounded),
    ('UPI / Other gateway', Icons.payment_rounded),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _externalPaymentOpened &&
        mounted) {
      setState(() => _returnedFromExternalPayment = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PorterStateService>();
    final profile = state.profile;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
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
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Color(0xFFD97706),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CASH SETTLEMENT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Choose a payment app to complete your settlement',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
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
                  border: Border.all(
                    color: const Color(0xFFF59E0B),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SETTLEMENT AMOUNT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${profile.todayCashCollected.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF78350F),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        size: 36,
                        color: Color(0xFFD97706),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildRemotePaymentOptions(profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemotePaymentOptions(dynamic profile) {
    if (_isPaymentSuccessful) {
      return _buildPaymentSuccess(profile);
    }

    if (_externalPaymentOpened) {
      return _buildPaymentReturnState(profile);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose how to pay',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Choose a payment app. We will open it with the settlement amount ready.',
          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),
        ..._paymentMethods.map(
          (method) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: 0,
            color: const Color(0xFFF8FAFC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            child: ListTile(
              onTap: () => _launchPaymentApp(method.$1, profile),
              leading: Icon(method.$2, color: const Color(0xFF2563EB)),
              title: Text(
                method.$1,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: const Text('Open securely'),
              trailing: const Icon(Icons.open_in_new_rounded, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchPaymentApp(String method, dynamic profile) async {
    final scheme = switch (method) {
      'Google Pay' => 'tez',
      'PhonePe' => 'phonepe',
      'Paytm' => 'paytmmp',
      _ => 'upi',
    };
    final paymentUri = Uri(
      scheme: scheme,
      host: scheme == 'upi' ? 'pay' : 'upi',
      path: scheme == 'upi' ? '' : 'pay',
      queryParameters: {
        'pa': 'countrymeat@upi',
        'pn': 'Country Meat Store Hub',
        'am': profile.todayCashCollected.toStringAsFixed(2),
        'cu': 'INR',
        'tn': 'Driver cash settlement',
      },
    );

    setState(() {
      _selectedPaymentMethod = method;
      _externalPaymentOpened = true;
      _returnedFromExternalPayment = false;
    });

    if (!await canLaunchUrl(paymentUri) ||
        !await launchUrl(paymentUri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      setState(() => _externalPaymentOpened = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('That payment app is not available on this phone.'),
        ),
      );
    }
  }

  Widget _buildPaymentReturnState(dynamic profile) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      child: _returnedFromExternalPayment
          ? Column(
              key: const ValueKey('returned'),
              children: [
                const Icon(
                  Icons.assignment_turned_in_rounded,
                  color: Color(0xFF2563EB),
                  size: 42,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome back',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  'Did you complete the ₹${profile.todayCashCollected.toStringAsFixed(0)} payment in $_selectedPaymentMethod?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        setState(() => _isPaymentSuccessful = true),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('YES, PAYMENT IS COMPLETE'),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      setState(() => _externalPaymentOpened = false),
                  child: const Text('Choose another app'),
                ),
              ],
            )
          : const Column(
              key: ValueKey('opening'),
              children: [
                SizedBox(height: 8),
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text(
                  'Opening your payment app...',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text(
                  'Complete the payment and return here.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
    );
  }

  Widget _buildPaymentSuccess(dynamic profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 32,
          backgroundColor: Color(0xFFDCFCE7),
          child: Icon(Icons.check_rounded, color: Color(0xFF059669), size: 40),
        ),
        const SizedBox(height: 12),
        const Text(
          'Payment successful',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Your cash settlement is complete.',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Column(
            children: [
              Text(
                '₹${profile.todayCashCollected.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF166534),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Paid via $_selectedPaymentMethod',
                style: const TextStyle(fontSize: 12, color: Color(0xFF166534)),
              ),
              const Text(
                'Settlement recorded successfully',
                style: TextStyle(fontSize: 12, color: Color(0xFF166534)),
              ),
              const Text(
                'Reference: CMP-20260826-4821',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<PorterStateService>().completeCashSettlement();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.done_rounded),
            label: const Text('DONE'),
          ),
        ),
      ],
    );
  }
}
