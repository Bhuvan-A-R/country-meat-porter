import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
          decoration: BoxDecoration(
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

  void _showCodConfirmationDialog(
    BuildContext context,
    PorterStateService state,
    DeliveryOrder order,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.payments_rounded, color: Color(0xFFD97706), size: 28),
            SizedBox(width: 10),
            Text(
              'Confirm COD Cash',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
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
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: Color(0xFFD97706),
                ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
            ),
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
