import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../services/porter_state_service.dart';
import '../../models/delivery_order.dart';
import '../../widgets/slide_to_confirm_button.dart';

/*
class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _popupShown = false;

  Future<void> _launchMaps(BuildContext context, String destination) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(destination)}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening Google Maps for "$destination"...')),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening Google Maps for "$destination"...')),
        );
      }
    }
  }

  Future<void> _makePhoneCall(BuildContext context, String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Calling $phone...')),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Calling $phone...')),
        );
      }
    }
  }

  void _showCodConfirmationDialog(BuildContext context, PorterStateService state, DeliveryOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.payments_rounded, color: Color(0xFFD97706), size: 28),
            SizedBox(width: 10),
            Text('Confirm COD Cash', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Have you collected the cash payment from customer?'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Text(
                'CASH TO COLLECT: ₹${order.cashToCollect.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFFD97706)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669)),
            onPressed: () {
              Navigator.pop(context);
              state.updateOrderStatus(order.id, OrderDeliveryStatus.delivered);
            },
            child: const Text('YES, CASH COLLECTED'),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant OrderDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orderId != widget.orderId) {
      _popupShown = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PorterStateService>();
    final order = state.orders.firstWhere(
      (o) => o.id == widget.orderId,
      orElse: () => state.orders.first,
    );

    if (order.status == OrderDeliveryStatus.delivered && !_popupShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showCompletionPopup(context, state, order));
      _popupShown = true;
    }

    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Trip #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Text(
              'PAYOUT ₹${order.porterEarning.toStringAsFixed(0)}',
              style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.w900, fontSize: 12),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (order.status == OrderDeliveryStatus.delivered)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF059669), size: 20),
                    SizedBox(width: 8),
                    Text('TRIP COMPLETED', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.w900, fontSize: 14)),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: _buildDriverWorkflowAction(context, state, order),
      ),
    );
  }

  void _showCompletionPopup(BuildContext context, PorterStateService state, DeliveryOrder order) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Completed',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 260,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.check_circle, color: Color(0xFF059669), size: 48),
                  SizedBox(height: 12),
                  Text('Order Completed!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDriverWorkflowAction(BuildContext context, PorterStateService state, DeliveryOrder order) {
    switch (order.status) {
      case OrderDeliveryStatus.assigned:
        return SlideToConfirmButton(
          label: 'SLIDE TO CONFIRM ARRIVED AT STORE',
          icon: Icons.storefront_rounded,
          color: const Color(0xFFEA580C),
          onConfirmed: () {
            state.updateOrderStatus(order.id, OrderDeliveryStatus.arrivedAtStore);
          },
        );
      case OrderDeliveryStatus.arrivedAtStore:
        return SlideToConfirmButton(
          label: 'SLIDE TO CONFIRM ORDER PICKUP',
          icon: Icons.takeout_dining_rounded,
          color: const Color(0xFF2563EB),
          onConfirmed: () {
            state.updateOrderStatus(order.id, OrderDeliveryStatus.pickedUp);
          },
        );
      case OrderDeliveryStatus.pickedUp:
      case OrderDeliveryStatus.inTransit:
        return SlideToConfirmButton(
          label: order.isCashOnDelivery
              ? 'SLIDE TO DELIVER (COLLECT ₹${order.cashToCollect.toStringAsFixed(0)} CASH)'
              : 'SLIDE TO CONFIRM DELIVERED',
          icon: Icons.check_circle_rounded,
          color: const Color(0xFF059669),
          onConfirmed: () {
            if (order.isCashOnDelivery) {
              _showCodConfirmationDialog(context, state, order);
            } else {
              state.updateOrderStatus(order.id, OrderDeliveryStatus.delivered);
            }
          },
        );
      case OrderDeliveryStatus.delivered:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFA7F3D0), width: 1.5),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Color(0xFF059669), size: 22),
              SizedBox(width: 10),
              Text('TRIP DELIVERED & PAYOUT CREDITED!', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.w900, fontSize: 15)),
            ],
          ),
        );
      case OrderDeliveryStatus.cancelled:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(2
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text('TASK CANCELLED', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        );
    }
  }
*/

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  Future<void> _launchMaps(BuildContext context, String destination) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(destination)}',
    );
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening Google Maps for "$destination"...'),
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening Google Maps for "$destination"...')),
        );
      }
    }
  }

  Future<void> _makePhoneCall(BuildContext context, String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Calling $phone...')));
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Calling $phone...')));
      }
    }
  }

  Future<void> _showCodQrDialog(
    BuildContext context,
    PorterStateService state,
    DeliveryOrder order,
  ) async {
    var secondsRemaining = 120;
    Timer? timer;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContentContext, setDialogState) {
          timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
            if (!dialogContentContext.mounted) {
              timer?.cancel();
              return;
            }
            if (secondsRemaining <= 1) {
              timer?.cancel();
              setDialogState(() => secondsRemaining = 0);
              return;
            }
            setDialogState(() => secondsRemaining--);
          });

          final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
          final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');

          return AlertDialog(
            title: const Text('COD payment QR'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ask the customer to scan and pay ₹${order.cashToCollect.toStringAsFixed(0)}.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  height: 220,
                  child: QrImageView(
                    data:
                        'countrymeat://cod/${order.id}?amount=${order.cashToCollect.toStringAsFixed(2)}',
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'QR valid for $minutes:$seconds',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: secondsRemaining == 0
                        ? Colors.red
                        : const Color(0xFFB45309),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  timer?.cancel();
                  Navigator.pop(dialogContext);
                },
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  timer?.cancel();
                  Navigator.pop(dialogContext);
                  _showCodPaymentScreenshotDialog(context, state, order);
                },
                child: const Text('CONTINUE TO PROOF'),
              ),
              OutlinedButton(
                onPressed: () async {
                  timer?.cancel();
                  Navigator.pop(dialogContext);
                  await _showDevPaymentSuccessDialog(context, state, order);
                },
                child: const Text('DEV: PAYMENT SUCCESS'),
              ),
            ],
          );
        },
      ),
    );
    timer?.cancel();
  }

  Future<void> _showDevPaymentSuccessDialog(
    BuildContext context,
    PorterStateService state,
    DeliveryOrder order,
  ) async {
    final reference =
        'CMP-PAY-${DateTime.now().millisecondsSinceEpoch.toString().substring(4)}';

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Color(0xFF059669)),
            SizedBox(width: 8),
            Text('Payment successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₹${order.cashToCollect.toStringAsFixed(0)} payment received.',
            ),
            const SizedBox(height: 10),
            Text(
              'Reference: $reference',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showDeliveryOtpDialog(context, state, order);
            },
            child: const Text('CONTINUE TO OTP'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCodPaymentScreenshotDialog(
    BuildContext context,
    PorterStateService state,
    DeliveryOrder order,
  ) async {
    XFile? paymentProof;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContentContext, setDialogState) {
            return AlertDialog(
              title: const Text('Attach COD payment screenshot'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Take a camera photo or upload a screenshot of the COD payment.',
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null) {
                        setDialogState(() => paymentProof = picked);
                      }
                    },
                    icon: const Icon(Icons.upload_file_rounded),
                    label: Text(
                      paymentProof == null
                          ? 'Upload screenshot'
                          : 'Proof attached',
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                      );
                      if (picked != null) {
                        setDialogState(() => paymentProof = picked);
                      }
                    },
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: const Text('Take camera photo'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: paymentProof == null
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                          _showDeliveryOtpDialog(context, state, order);
                        },
                  child: const Text('CONTINUE TO OTP'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showDeliveryOtpDialog(
    BuildContext context,
    PorterStateService state,
    DeliveryOrder order,
  ) async {
    final controllers = List.generate(4, (_) => TextEditingController());
    final focusNodes = List.generate(4, (_) => FocusNode());
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContentContext, setDialogState) => AlertDialog(
          title: const Text('Confirm delivery with OTP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter the customer\'s 4-digit OTP.'),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: List.generate(4, (index) {
                    final hasValue = controllers[index].text.isNotEmpty;
                    final isFocused = focusNodes[index].hasFocus;

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 5,
                          right: index == 3 ? 0 : 5,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isFocused
                                  ? const Color(0xFF2563EB)
                                  : hasValue
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFFE2E8F0),
                              width: isFocused ? 2 : 1.2,
                            ),
                          ),
                          child: Center(
                            child: TextField(
                              controller: controllers[index],
                              focusNode: focusNodes[index],
                              autofocus: index == 0,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 3) {
                                  focusNodes[index + 1].requestFocus();
                                } else if (value.isEmpty && index > 0) {
                                  focusNodes[index - 1].requestFocus();
                                }
                                setDialogState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () async {
                final otp = controllers
                    .map((controller) => controller.text)
                    .join();
                if (otp.length != 4) {
                  ScaffoldMessenger.of(dialogContentContext).showSnackBar(
                    const SnackBar(
                      content: Text('Enter the customer\'s 4-digit OTP.'),
                    ),
                  );
                  return;
                }
                Navigator.pop(dialogContext);
                state.updateOrderStatus(
                  order.id,
                  OrderDeliveryStatus.delivered,
                );
                await _showCompletionDialog(context, state, order);
                if (context.mounted) context.go('/');
              },
              child: const Text('CONFIRM DELIVERY'),
            ),
          ],
        ),
      ),
    );
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
  }

  Future<void> _showCompletionDialog(
    BuildContext context,
    PorterStateService state,
    DeliveryOrder order,
  ) async {
    final profile = state.profile;
    final previousPayout = profile.todayEarnings - order.porterEarning;
    final previousCash =
        profile.todayCashCollected -
        (order.isCashOnDelivery ? order.cashToCollect : 0.0);
    final previousTrips = profile.completedTrips - 1;

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Delivery completed',
      barrierColor: Colors.black.withValues(alpha: 0.42),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (dialogContext, animation, secondaryAnimation) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 22),
              color: Colors.white.withValues(alpha: 0.96),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.4, end: 1),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) =>
                        Transform.scale(scale: scale, child: child),
                    child: const Icon(
                      Icons.celebration_rounded,
                      color: Color(0xFF059669),
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Congratulations!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Trip ${order.id} completed successfully.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _CompletionStat(
                          label: 'TOTAL PAYOUT',
                          prefix: '₹',
                          begin: previousPayout,
                          end: profile.todayEarnings,
                          color: const Color(0xFF059669),
                        ),
                      ),
                      Expanded(
                        child: _CompletionStat(
                          label: 'COD COLLECTED',
                          prefix: '₹',
                          begin: previousCash,
                          end: profile.todayCashCollected,
                          color: const Color(0xFFD97706),
                        ),
                      ),
                      Expanded(
                        child: _CompletionStat(
                          label: 'TRIPS DONE',
                          begin: previousTrips.toDouble(),
                          end: profile.completedTrips.toDouble(),
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('GO TO DASHBOARD'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PorterStateService>();
    final order = state.orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => state.orders.first,
    );
    final primary = Theme.of(context).colorScheme.primary;
    final verifiedCount = order.items.where((i) => i.isVerified).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Trip #${order.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFA7F3D0)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live GPS Turn-by-Turn Guidance Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: primary.withValues(alpha: 0.2),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.navigation_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'LIVE GPS TURN-BY-TURN NAVIGATION',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              order.status == OrderDeliveryStatus.assigned ||
                                      order.status ==
                                          OrderDeliveryStatus.arrivedAtStore
                                  ? 'Turn Right in 200m towards Store Hub'
                                  : 'Head North on 100ft Rd towards Customer',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${order.distanceKm} km • EST ${order.estimatedTime}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          side: const BorderSide(color: Color(0xFF2563EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          final destination =
                              (order.status == OrderDeliveryStatus.assigned ||
                                  order.status ==
                                      OrderDeliveryStatus.arrivedAtStore)
                              ? order.storeAddress
                              : order.deliveryAddress;
                          _launchMaps(context, destination);
                        },
                        icon: const Icon(
                          Icons.near_me_rounded,
                          size: 16,
                          color: Color(0xFF2563EB),
                        ),
                        label: const Text(
                          'Launch Google Maps',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // COD Warning Alert Pill
            if (order.isCashOnDelivery &&
                order.status != OrderDeliveryStatus.delivered)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFFDE68A),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFD97706),
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CASH ON DELIVERY (COD) MANDATE',
                            style: TextStyle(
                              color: Color(0xFFD97706),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'MUST COLLECT ₹${order.cashToCollect.toStringAsFixed(0)} CASH UPON HANDOVER',
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Store Pickup Location Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.storefront_rounded,
                        color: Color(0xFFEA580C),
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '1. STORE PICKUP HUB',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFEA580C),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.storeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    order.storeAddress,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 44),
                            side: const BorderSide(color: Color(0xFFEA580C)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () =>
                              _makePhoneCall(context, order.storePhone),
                          icon: const Icon(
                            Icons.phone_rounded,
                            color: Color(0xFFEA580C),
                            size: 18,
                          ),
                          label: Text(
                            'CALL STORE (${order.storePhone})',
                            style: const TextStyle(
                              color: Color(0xFFEA580C),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFEA580C),
                        ),
                        icon: const Icon(
                          Icons.near_me_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () =>
                            _launchMaps(context, order.storeAddress),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Customer Delivery Location Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: primary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        '2. CUSTOMER DELIVERY LOCATION',
                        style: TextStyle(
                          fontSize: 10,
                          color: primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.customerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    order.deliveryAddress,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  if (order.customerInstructions.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFBBF24),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.notification_important_rounded,
                            color: Color(0xFFD97706),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CUSTOMER SPECIAL DELIVERY NOTE:',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFB45309),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  order.customerInstructions,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1E293B),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            minimumSize: const Size(0, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () =>
                              _makePhoneCall(context, order.customerPhone),
                          icon: const Icon(
                            Icons.phone_in_talk_rounded,
                            size: 18,
                          ),
                          label: Text(
                            'CALL CUSTOMER (${order.customerPhone})',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                        ),
                        icon: const Icon(
                          Icons.near_me_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () =>
                            _launchMaps(context, order.deliveryAddress),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Item Bag Verification Checklist Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Fresh Meat Bag Verification',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: verifiedCount == order.items.length
                              ? const Color(0xFFECFDF5)
                              : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$verifiedCount / ${order.items.length} VERIFIED',
                          style: TextStyle(
                            color: verifiedCount == order.items.length
                                ? const Color(0xFF059669)
                                : const Color(0xFF2563EB),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Verify each meat & gel-pack seal before leaving hub:',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(order.items.length, (idx) {
                    final item = order.items[idx];
                    return CheckboxListTile(
                      value: item.isVerified,
                      activeColor: const Color(0xFF059669),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '${item.quantity}x ${item.name} (${item.weight})',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      subtitle: Text(
                        'Price: ₹${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      onChanged: (_) {
                        state.toggleItemVerification(order.id, idx);
                      },
                    );
                  }),
                  if (verifiedCount < order.items.length) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          state.verifyAllItems(order.id);
                        },
                        icon: const Icon(Icons.done_all_rounded, size: 20),
                        label: const Text(
                          'VERIFY ALL SEALS (QUICK CHECK)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: _buildDriverWorkflowAction(context, state, order),
      ),
    );
  }

  Widget _buildDriverWorkflowAction(
    BuildContext context,
    PorterStateService state,
    DeliveryOrder order,
  ) {
    switch (order.status) {
      case OrderDeliveryStatus.assigned:
        return SlideToConfirmButton(
          label: 'SLIDE TO CONFIRM ARRIVED AT STORE',
          icon: Icons.storefront_rounded,
          color: const Color(0xFFEA580C),
          onConfirmed: () {
            state.updateOrderStatus(
              order.id,
              OrderDeliveryStatus.arrivedAtStore,
            );
          },
        );
      case OrderDeliveryStatus.arrivedAtStore:
        return SlideToConfirmButton(
          label: 'SLIDE TO CONFIRM ORDER PICKUP',
          icon: Icons.takeout_dining_rounded,
          color: const Color(0xFF2563EB),
          onConfirmed: () {
            if (order.items.any((item) => !item.isVerified)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Verify every item before confirming pickup.'),
                ),
              );
              return;
            }
            state.updateOrderStatus(order.id, OrderDeliveryStatus.pickedUp);
          },
        );
      case OrderDeliveryStatus.pickedUp:
      case OrderDeliveryStatus.inTransit:
        return SlideToConfirmButton(
          label: order.isCashOnDelivery
              ? 'SLIDE TO DELIVER (COLLECT ₹${order.cashToCollect.toStringAsFixed(0)} CASH)'
              : 'SLIDE TO CONFIRM DELIVERED',
          icon: Icons.check_circle_rounded,
          color: const Color(0xFF059669),
          onConfirmed: () {
            if (order.isCashOnDelivery) {
              Future<void>.delayed(Duration.zero, () {
                if (context.mounted) {
                  _showCodQrDialog(context, state, order);
                }
              });
            } else {
              _showDeliveryOtpDialog(context, state, order);
            }
          },
        );
      case OrderDeliveryStatus.delivered:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFA7F3D0), width: 1.5),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Color(0xFF059669), size: 22),
              SizedBox(width: 10),
              Text(
                'TRIP DELIVERED & PAYOUT CREDITED!',
                style: TextStyle(
                  color: Color(0xFF059669),
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      case OrderDeliveryStatus.cancelled:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            'TASK CANCELLED',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        );
    }
  }
}

class _CompletionStat extends StatelessWidget {
  final String label;
  final String prefix;
  final double begin;
  final double end;
  final Color color;

  const _CompletionStat({
    required this.label,
    this.prefix = '',
    required this.begin,
    required this.end,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Column(
        children: [
          Text(
            '$prefix${value.toStringAsFixed(0)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
