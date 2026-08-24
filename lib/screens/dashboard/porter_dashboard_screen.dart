import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/porter_state_service.dart';
import '../../models/delivery_order.dart';
import '../../widgets/country_meat_logo.dart';
import '../../widgets/slide_to_confirm_button.dart';
import '../../widgets/driver_sos_modal.dart';
import '../../widgets/cod_cash_deposit_modal.dart';
import 'notifications_bottom_sheet.dart';

class PorterDashboardScreen extends StatefulWidget {
  const PorterDashboardScreen({super.key});

  @override
  State<PorterDashboardScreen> createState() =>
      _PorterDashboardScreenState();
}

class _PorterDashboardScreenState extends State<PorterDashboardScreen>
    with SingleTickerProviderStateMixin {
  bool _voiceGuidanceEnabled = false;
  String _selectedLanguage = 'English';
  bool _isPlayingAudio = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 12.0,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _launchMaps(
    BuildContext context,
    String query,
  ) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Opening Google Maps for "$query"...',
              ),
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Opening Google Maps for "$query"...',
            ),
          ),
        );
      }
    }
  }

  Future<void> _makePhoneCall(
    BuildContext context,
    String phone,
  ) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: phone,
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Calling $phone...'),
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Calling $phone...'),
          ),
        );
      }
    }
  }

  void _confirmGoOffline(
    BuildContext context,
    PorterStateService state,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFDC2626),
                size: 28,
              ),
              SizedBox(width: 10),
              Text(
                'Go Offline?',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to go offline? You will stop receiving new delivery orders and surge bonuses.',
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: Color(0xFF475569),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'KEEP ONLINE',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                state.toggleDutyStatus();
              },
              child: const Text(
                'GO OFFLINE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showColdChainInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 62,
                  width: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.ac_unit_rounded,
                    color: Color(0xFF2563EB),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Cold Chain Reminder',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Keep the meat packages properly chilled throughout the trip and avoid unnecessary delays during delivery.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: Color(0xFF2563EB),
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Prioritize timely delivery and keep the cold chain intact.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'GOT IT',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _simulateAudioSpeech(String text) {
    if (_isPlayingAudio) return;

    setState(() {
      _isPlayingAudio = true;
    });

    String prefix =
        '🔊 [Voice Assistant - $_selectedLanguage]: ';

    if (_selectedLanguage == 'Hindi') {
      prefix = '🔊 [आवाज़ सहायक - हिंदी]: ';
    } else if (_selectedLanguage == 'Kannada') {
      prefix = '🔊 [ಧ್ವನಿ ಸಹಾಯ - ಕನ್ನಡ]: ';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.volume_up_rounded,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$prefix "$text"',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    Future.delayed(
      const Duration(seconds: 4),
      () {
        if (mounted) {
          setState(() {
            _isPlayingAudio = false;
          });
        }
      },
    );
  }

  String _getVoiceInstruction(DeliveryOrder? activeOrder) {
    if (activeOrder == null) {
      if (_selectedLanguage == 'Hindi') {
        return 'ड्यूटी के लिए तैयार रहें। कोई नया काम मिलते ही आपको सूचित किया जाएगा।';
      } else if (_selectedLanguage == 'Kannada') {
        return 'ಕೆಲಸಕ್ಕಾಗಿ ಸಿದ್ಧರಾಗಿರಿ. ಹೊಸ ಆರ್ಡರ್ ಬಂದ ತಕ್ಷಣ ತಿಳಿಸಲಾಗುವುದು.';
      } else {
        return 'Standby for duty. You will be notified when a new order is assigned.';
      }
    }

    if (activeOrder.status == OrderDeliveryStatus.assigned) {
      if (_selectedLanguage == 'Hindi') {
        return 'स्टोर पर जाएँ: ${activeOrder.storeName}. स्टोर की दूरी ${activeOrder.distanceKm} किलोमीटर है।';
      } else if (_selectedLanguage == 'Kannada') {
        return 'ಸ್ಟೋರ್‌ಗೆ ಹೋಗಿ: ${activeOrder.storeName}. ಒಟ್ಟು ದೂರ ${activeOrder.distanceKm} ಕಿಲೋಮೀಟರ್.';
      } else {
        return 'Proceed to store: ${activeOrder.storeName}. Distance is ${activeOrder.distanceKm} km.';
      }
    }

    if (activeOrder.status == OrderDeliveryStatus.arrivedAtStore) {
      if (_selectedLanguage == 'Hindi') {
        return 'स्टोर पर पहुँच गए हैं। सभी ताज़ा मीट पैक्स का सील चेक करें।';
      } else if (_selectedLanguage == 'Kannada') {
        return 'ಸ್ಟೋರ್ ತಲುಪಿದ್ದೀರಿ. ಎಲ್ಲಾ ಮಾಂಸದ ಪ್ಯಾಕ್‌ಗಳ ಸೀಲ್ ಪರಿಶೀಲಿಸಿ.';
      } else {
        return 'Arrived at store. Check and verify seals on all meat items.';
      }
    }

    if (_selectedLanguage == 'Hindi') {
      return 'ग्राहक के पते पर जाएँ: ${activeOrder.deliveryAddress}. डिलीवरी समय 25 मिनट से कम रखें।';
    } else if (_selectedLanguage == 'Kannada') {
      return 'ಗ್ರಾಹಕರ ವಿಳಾಸಕ್ಕೆ ಹೋಗಿ: ${activeOrder.deliveryAddress}. ಶೀತಲ ಸರಪಳಿ ಕಾಪಾಡಿ.';
    } else {
      return 'Deliver to customer at: ${activeOrder.deliveryAddress}. Keep meat cold and deliver on time.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PorterStateService>();
    final profile = state.profile;
    final activeOrder = state.activeOrder;
    final unreadCount = state.unreadNotificationCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 16,
        title: Row(
          children: [
            const CountryMeatLogo(
              isRed: true,
              fontSize: 18,
            ),
            const SizedBox(width: 10),
            Container(
              height: 18,
              width: 1.2,
              color: const Color(0xFFCBD5E1),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    profile.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '${profile.vehicleType} • ${profile.vehicleNumber}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF0F172A),
                    size: 24,
                  ),
                  onPressed: () {
                    NotificationsBottomSheet.show(context);
                  },
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFC62828),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$unreadCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // 1. TOP PERFORMANCE / MONEY SUMMARY
            // ============================================================
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 17,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFF1F5F9),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.035),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _MinimalistStatItem(
                      title: 'Total Payout',
                      value:
                          '₹${profile.todayEarnings.toStringAsFixed(0)}',
                      color: const Color(0xFF059669),
                    ),
                  ),
                  Container(
                    height: 34,
                    width: 1,
                    color: const Color(0xFFE2E8F0),
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        CodCashDepositModal.show(context);
                      },
                      child: _MinimalistStatItem(
                        title: 'COD Collected',
                        value:
                            '₹${profile.todayCashCollected.toStringAsFixed(0)}',
                        color: const Color(0xFFD97706),
                      ),
                    ),
                  ),
                  Container(
                    height: 34,
                    width: 1,
                    color: const Color(0xFFE2E8F0),
                  ),
                  Expanded(
                    child: _MinimalistStatItem(
                      title: 'Trips Done',
                      value: '${profile.completedTrips}',
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ============================================================
            // 2. DUTY STATUS
            // ============================================================
            GestureDetector(
              onTap: () {
                if (profile.isOnline) {
                  _confirmGoOffline(context, state);
                } else {
                  state.toggleDutyStatus();
                }
              },
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: profile.isOnline
                            ? const [
                                Color(0xFF10B981),
                                Color(0xFF059669),
                              ]
                            : const [
                                Color(0xFF334155),
                                Color(0xFF1E293B),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: (profile.isOnline
                                  ? const Color(0xFF10B981)
                                  : Colors.black87)
                              .withValues(alpha: 0.28),
                          blurRadius: profile.isOnline
                              ? 12.0 + _pulseAnimation.value
                              : 10,
                          spreadRadius: profile.isOnline
                              ? _pulseAnimation.value / 4
                              : 0,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: profile.isOnline
                            ? const Color(0xFF34D399)
                            : Colors.white24,
                        width: 2,
                      ),
                    ),
                    child: child,
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor:
                          Colors.white.withValues(alpha: 0.22),
                      child: Icon(
                        profile.isOnline
                            ? Icons.two_wheeler_rounded
                            : Icons.power_off_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.isOnline
                                ? 'DUTY STATUS: ONLINE 🟢'
                                : 'DUTY STATUS: OFFLINE 🔴',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.isOnline
                                ? 'You are available for new delivery tasks'
                                : 'Tap here to go online and receive tasks',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            profile.isOnline ? 'ONLINE' : 'GO ON',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 9,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ============================================================
            // 3. CURRENT ACTIVE TASK
            // ============================================================
            const Text(
              'CURRENT ACTIVE TASK',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color(0xFF64748B),
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 10),

            if (!profile.isOnline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.power_settings_new_rounded,
                      size: 44,
                      color: Color(0xFF94A3B8),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Go online to receive nearby delivery tasks',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              )
            else if (activeOrder == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 48,
                      color: Color(0xFF059669),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'All Delivery Tasks Completed! 🎉',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tap the button below to restart the driver trip demo process.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          state.resetOrAssignDemoOrder();
                        },
                        icon: const Icon(
                          Icons.replay_rounded,
                          size: 20,
                        ),
                        label: const Text(
                          'RESTART TRIP PROCESS DEMO',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              // ==========================================================
              // ACTIVE TASK + FLOATING COLD CHAIN BUBBLE
              // ==========================================================
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _DriverActiveTaskCard(
                    order: activeOrder,
                    onLaunchMaps: (query) {
                      _launchMaps(context, query);
                    },
                    onCallPhone: (phone) {
                      _makePhoneCall(context, phone);
                    },
                    onUpdateStatus: (nextStatus) {
                      state.updateOrderStatus(
                        activeOrder.id,
                        nextStatus,
                      );
                    },
                    voiceGuidanceEnabled: _voiceGuidanceEnabled,
                    onPlayVoice: () {
                      _simulateAudioSpeech(
                        _getVoiceInstruction(activeOrder),
                      );
                    },
                  ),

                  // ======================================================
                  // FLOATING COLD CHAIN BUBBLE
                  // ======================================================
                  Positioned(
                    right: -5,
                    bottom: 82,
                    child: _ColdChainBubble(
                      animation: _pulseAnimation,
                      onTap: () {
                        _showColdChainInfo(context);
                      },
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 26),

            // ============================================================
            // QUICK ACTIONS
            // ============================================================
            Row(
              children: [
                Expanded(
                  child: _MinimalistQuickButton(
                    icon: Icons.assignment_outlined,
                    label: 'My Tasks',
                    onTap: () {
                      context.go('/orders');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MinimalistQuickButton(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'COD Deposit',
                    color: const Color(0xFFD97706),
                    onTap: () {
                      CodCashDepositModal.show(context);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MinimalistQuickButton(
                    icon: Icons.sos_rounded,
                    label: 'SOS Support',
                    color: const Color(0xFFDC2626),
                    onTap: () {
                      DriverSosModal.show(context);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ==========================================================================
// TOP STAT ITEM
// ==========================================================================

class _MinimalistStatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MinimalistStatItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ==========================================================================
// FLOATING COLD CHAIN BUBBLE
// ==========================================================================

class _ColdChainBubble extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onTap;

  const _ColdChainBubble({
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            animation.value / 3,
            -animation.value / 4,
          ),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 76,
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFBFDBFE),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withValues(
                  alpha: 0.18,
                ),
                blurRadius: 14,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.ac_unit_rounded,
                  color: Color(0xFF2563EB),
                  size: 18,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Cold Chain',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Tap',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================================
// ACTIVE TASK CARD
// ==========================================================================

class _DriverActiveTaskCard extends StatelessWidget {
  final DeliveryOrder order;
  final Function(String) onLaunchMaps;
  final Function(String) onCallPhone;
  final Function(OrderDeliveryStatus) onUpdateStatus;
  final bool voiceGuidanceEnabled;
  final VoidCallback onPlayVoice;

  const _DriverActiveTaskCard({
    required this.order,
    required this.onLaunchMaps,
    required this.onCallPhone,
    required this.onUpdateStatus,
    required this.voiceGuidanceEnabled,
    required this.onPlayVoice,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    final bool isPickupPhase =
        order.status == OrderDeliveryStatus.assigned ||
        order.status == OrderDeliveryStatus.arrivedAtStore;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==============================================================
          // ORDER ID + PAYOUT
          // ==============================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  order.id,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFA7F3D0),
                  ),
                ),
                child: Text(
                  'PAYOUT ₹${order.porterEarning.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Color(0xFF059669),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ==============================================================
          // ROUTE TIMELINE
          // ==============================================================
          _buildVisualRouteTimeline(order),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              color: Color(0xFFF1F5F9),
            ),
          ),

          // ==============================================================
          // PICKUP HUB
          // ==============================================================
          Container(
            padding: EdgeInsets.all(
              isPickupPhase ? 14 : 10,
            ),
            decoration: BoxDecoration(
              color: isPickupPhase
                  ? const Color(0xFFFFF7ED)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: isPickupPhase
                  ? Border.all(
                      color: const Color(0xFFFFEDD5),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isPickupPhase
                        ? const Color(0xFFEA580C)
                        : const Color(0xFFFFF7ED),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    color: isPickupPhase
                        ? Colors.white
                        : const Color(0xFFEA580C),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PICKUP STORE HUB',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFEA580C),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.storeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        order.storeAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==============================================================
          // HUB ACTIONS
          // ==============================================================
          if (isPickupPhase) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFEA580C),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 1,
                    ),
                    onPressed: () {
                      onCallPhone(order.storePhone);
                    },
                    icon: const Icon(
                      Icons.phone_rounded,
                      size: 19,
                    ),
                    label: const Text(
                      'CALL HUB',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 1,
                    ),
                    onPressed: () {
                      onLaunchMaps(order.storeAddress);
                    },
                    icon: const Icon(
                      Icons.near_me_rounded,
                      size: 19,
                    ),
                    label: const Text(
                      'NAVIGATE HUB',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),

          // ==============================================================
          // CUSTOMER DROP
          // ==============================================================
          Container(
            padding: EdgeInsets.all(
              !isPickupPhase ? 14 : 10,
            ),
            decoration: BoxDecoration(
              color: !isPickupPhase
                  ? const Color(0xFFEFF6FF)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: !isPickupPhase
                  ? Border.all(
                      color: const Color(0xFFDBEAFE),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: !isPickupPhase
                        ? primary
                        : const Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: !isPickupPhase
                        ? Colors.white
                        : primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DROP CUSTOMER (${order.distanceKm} km)',
                        style: TextStyle(
                          fontSize: 10,
                          color: primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.customerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        order.deliveryAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==============================================================
          // CUSTOMER ACTIONS
          // ==============================================================
          if (!isPickupPhase) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 1,
                    ),
                    onPressed: () {
                      onCallPhone(order.customerPhone);
                    },
                    icon: const Icon(
                      Icons.phone_in_talk_rounded,
                      size: 19,
                    ),
                    label: const Text(
                      'CALL CUSTOMER',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 1,
                    ),
                    onPressed: () {
                      onLaunchMaps(order.deliveryAddress);
                    },
                    icon: const Icon(
                      Icons.near_me_rounded,
                      size: 19,
                    ),
                    label: const Text(
                      'NAVIGATE DROP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // ==============================================================
          // COD COLLECTION
          // ==============================================================
          if (order.isCashOnDelivery) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFFDE68A),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.payments_rounded,
                    color: Color(0xFFD97706),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'COLLECT CASH: ₹${order.cashToCollect.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Color(0xFFB45309),
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 18),

          // ==============================================================
          // SLIDE ACTION
          // ==============================================================
          if (order.status ==
              OrderDeliveryStatus.assigned) ...[
            SlideToConfirmButton(
              label: 'SLIDE TO ARRIVE AT STORE',
              icon: Icons.storefront_rounded,
              color: const Color(0xFFEA580C),
              onConfirmed: () {
                onUpdateStatus(
                  OrderDeliveryStatus.arrivedAtStore,
                );
              },
            ),
          ] else if (order.status ==
              OrderDeliveryStatus.arrivedAtStore) ...[
            SlideToConfirmButton(
              label: 'SLIDE TO CONFIRM PICKUP',
              icon: Icons.takeout_dining_rounded,
              color: const Color(0xFF2563EB),
              onConfirmed: () {
                onUpdateStatus(
                  OrderDeliveryStatus.pickedUp,
                );
              },
            ),
          ] else if (order.status ==
                  OrderDeliveryStatus.pickedUp ||
              order.status ==
                  OrderDeliveryStatus.inTransit) ...[
            SlideToConfirmButton(
              label: order.isCashOnDelivery
                  ? 'SLIDE FOR COD DELIVERY'
                  : 'SLIDE TO DELIVER',
              icon: Icons.check_circle_rounded,
              color: const Color(0xFF059669),
              onConfirmed: () {
                onUpdateStatus(
                  OrderDeliveryStatus.delivered,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================================================
  // ROUTE TIMELINE
  // ==========================================================================

  Widget _buildVisualRouteTimeline(
    DeliveryOrder order,
  ) {
    final bool step1Done =
        order.status != OrderDeliveryStatus.assigned;

    final bool step2Done =
        order.status == OrderDeliveryStatus.pickedUp ||
        order.status == OrderDeliveryStatus.inTransit ||
        order.status == OrderDeliveryStatus.delivered;

    final bool step3Done =
        order.status == OrderDeliveryStatus.delivered;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 4,
      ),
      child: Row(
        children: [
          _buildStepperNode(
            icon: Icons.storefront_rounded,
            title: 'HUB',
            isCurrent:
                order.status ==
                        OrderDeliveryStatus.assigned ||
                    order.status ==
                        OrderDeliveryStatus.arrivedAtStore,
            isCompleted: step1Done,
            color: const Color(0xFFEA580C),
          ),
          Expanded(
            child: Container(
              height: 3,
              color: step1Done
                  ? const Color(0xFFEA580C)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          _buildStepperNode(
            icon: Icons.two_wheeler_rounded,
            title: 'RIDE',
            isCurrent:
                order.status ==
                        OrderDeliveryStatus.pickedUp ||
                    order.status ==
                        OrderDeliveryStatus.inTransit,
            isCompleted: step2Done,
            color: const Color(0xFF2563EB),
          ),
          Expanded(
            child: Container(
              height: 3,
              color: step2Done
                  ? const Color(0xFF2563EB)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          _buildStepperNode(
            icon: Icons.home_rounded,
            title: 'DROP',
            isCurrent:
                order.status ==
                OrderDeliveryStatus.delivered,
            isCompleted: step3Done,
            color: const Color(0xFF059669),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperNode({
    required IconData icon,
    required String title,
    required bool isCurrent,
    required bool isCompleted,
    required Color color,
  }) {
    Color contentColor = const Color(0xFF64748B);

    if (isCompleted) {
      contentColor = color;
    } else if (isCurrent) {
      contentColor = const Color(0xFF0F172A);
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isCurrent
                ? color
                : isCompleted
                    ? color.withValues(alpha: 0.12)
                    : const Color(0xFFF1F5F9),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent
                  ? color
                  : isCompleted
                      ? color
                      : const Color(0xFFCBD5E1),
              width: 2,
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            isCompleted
                ? Icons.check_rounded
                : icon,
            color: isCurrent
                ? Colors.white
                : isCompleted
                    ? color
                    : const Color(0xFF94A3B8),
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 9,
            fontWeight:
                isCurrent || isCompleted
                    ? FontWeight.w900
                    : FontWeight.bold,
            color: contentColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ==========================================================================
// QUICK ACTION BUTTON
// ==========================================================================

class _MinimalistQuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _MinimalistQuickButton({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary =
        color ?? Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: primary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}