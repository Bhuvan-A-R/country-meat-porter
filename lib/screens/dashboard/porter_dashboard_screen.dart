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

class PorterDashboardScreen extends StatelessWidget {
  const PorterDashboardScreen({super.key});

  Future<void> _launchMaps(BuildContext context, String query) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening Google Maps for "$query"...')),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening Google Maps for "$query"...')),
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

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PorterStateService>();
    final profile = state.profile;
    final activeOrder = state.activeOrder;
    final unreadCount = state.unreadNotificationCount;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            const CountryMeatLogo(isRed: true, fontSize: 18),
            const SizedBox(width: 10),
            Container(height: 18, width: 1.2, color: const Color(0xFFCBD5E1)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(profile.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${profile.vehicleType} • ${profile.vehicleNumber}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
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
                  icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0F172A), size: 24),
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Performance Pill Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MinimalistStatItem(
                    title: "Today Payout",
                    value: '₹${profile.todayEarnings.toStringAsFixed(0)}',
                    color: const Color(0xFF059669),
                  ),
                  Container(height: 28, width: 1, color: const Color(0xFFF1F5F9)),
                  InkWell(
                    onTap: () => CodCashDepositModal.show(context),
                    child: _MinimalistStatItem(
                      title: 'COD Collected',
                      value: '₹${profile.todayCashCollected.toStringAsFixed(0)}',
                      color: const Color(0xFFD97706),
                    ),
                  ),
                  Container(height: 28, width: 1, color: const Color(0xFFF1F5F9)),
                  _MinimalistStatItem(
                    title: 'Trips Done',
                    value: '${profile.completedTrips}',
                    color: const Color(0xFF2563EB),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // High Contrast Uber-Style GO Switch Pill
            InkWell(
              onTap: () => state.toggleDutyStatus(),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: profile.isOnline
                        ? [const Color(0xFF059669), const Color(0xFF047857)]
                        : [const Color(0xFF334155), const Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (profile.isOnline ? const Color(0xFF059669) : Colors.black87).withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Icon(
                        profile.isOnline ? Icons.two_wheeler_rounded : Icons.power_off_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.isOnline ? 'DUTY STATUS: ONLINE 🟢' : 'DUTY STATUS: OFFLINE 🔴',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profile.isOnline ? 'High order volume near Indiranagar Hub' : 'Tap to go online & start receiving orders',
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Live Cold-Chain Meat Freshness Banner (if active order exists)
            if (activeOrder != null && activeOrder.status != OrderDeliveryStatus.delivered) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBFDBFE), width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.ac_unit_rounded, color: Color(0xFF2563EB), size: 22),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COLD-CHAIN FRESHNESS GUARANTEE ❄️',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF1E40AF)),
                          ),
                          Text(
                            'Deliver within 25 mins to keep meat below 4°C',
                            style: TextStyle(fontSize: 11, color: Color(0xFF3B82F6)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '18:42 mins',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Active Task Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('CURRENT ACTIVE TASK', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 1.2)),
                if (activeOrder != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('ACTION REQUIRED', style: TextStyle(color: primary, fontSize: 10, fontWeight: FontWeight.w900)),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            if (!profile.isOnline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.power_settings_new_rounded, size: 44, color: Color(0xFF94A3B8)),
                    SizedBox(height: 12),
                    Text('Go online to receive nearby delivery tasks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                  ],
                ),
              )
            else if (activeOrder == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 48, color: Color(0xFF059669)),
                    const SizedBox(height: 12),
                    const Text(
                      'All Delivery Tasks Completed! 🎉',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tap the button below to restart the driver trip demo process.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => state.resetOrAssignDemoOrder(),
                      icon: const Icon(Icons.replay_rounded, size: 20),
                      label: const Text('RESTART TRIP PROCESS DEMO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
              )

            else
              _DriverActiveTaskCard(
                order: activeOrder,
                onLaunchMaps: (query) => _launchMaps(context, query),
                onCallPhone: (phone) => _makePhoneCall(context, phone),
                onUpdateStatus: (nextStatus) => state.updateOrderStatus(activeOrder.id, nextStatus),
              ),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _MinimalistQuickButton(
                    icon: Icons.assignment_outlined,
                    label: 'My Tasks',
                    onTap: () => context.go('/orders'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MinimalistQuickButton(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'COD Deposit',
                    color: const Color(0xFFD97706),
                    onTap: () => CodCashDepositModal.show(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MinimalistQuickButton(
                    icon: Icons.sos_rounded,
                    label: 'SOS Support',
                    color: const Color(0xFFDC2626),
                    onTap: () => DriverSosModal.show(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _DriverActiveTaskCard extends StatelessWidget {
  final DeliveryOrder order;
  final Function(String) onLaunchMaps;
  final Function(String) onCallPhone;
  final Function(OrderDeliveryStatus) onUpdateStatus;

  const _DriverActiveTaskCard({
    required this.order,
    required this.onLaunchMaps,
    required this.onCallPhone,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.id, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF0F172A))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Text(
                  'PAYOUT ₹${order.porterEarning.toStringAsFixed(0)}',
                  style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.w900, fontSize: 13),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // 1. Pickup Store Hub Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0xFFFFF7ED), shape: BoxShape.circle),
                child: const Icon(Icons.storefront_rounded, color: Color(0xFFEA580C), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PICKUP STORE HUB', style: TextStyle(fontSize: 10, color: Color(0xFFEA580C), fontWeight: FontWeight.w900, letterSpacing: 0.8)),
                    Text(order.storeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                  ],
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: const Color(0xFFFFF7ED)),
                icon: const Icon(Icons.phone, color: Color(0xFFEA580C), size: 18),
                onPressed: () => onCallPhone(order.storePhone),
              ),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: const Color(0xFFEFF6FF)),
                icon: const Icon(Icons.near_me_rounded, color: Color(0xFF2563EB), size: 18),
                onPressed: () => onLaunchMaps(order.storeAddress),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Drop Customer Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: primary.withValues(alpha: 0.08), shape: BoxShape.circle),
                child: Icon(Icons.location_on_rounded, color: primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DROP CUSTOMER (${order.distanceKm} km)', style: TextStyle(fontSize: 10, color: primary, fontWeight: FontWeight.w900, letterSpacing: 0.8)),
                    Text(order.deliveryAddress, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: const Color(0xFFECFDF5)),
                icon: const Icon(Icons.phone_in_talk, color: Color(0xFF059669), size: 18),
                onPressed: () => onCallPhone(order.customerPhone),
              ),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: const Color(0xFFEFF6FF)),
                icon: const Icon(Icons.near_me_rounded, color: Color(0xFF2563EB), size: 18),
                onPressed: () => onLaunchMaps(order.deliveryAddress),
              ),
            ],
          ),

          if (order.isCashOnDelivery) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payments_rounded, color: Color(0xFFD97706), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'COLLECT CASH: ₹${order.cashToCollect.toStringAsFixed(0)}',
                    style: const TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.w900, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Safe Slide-to-Confirm Gesture Button
          if (order.status == OrderDeliveryStatus.assigned) ...[
            SlideToConfirmButton(
              label: 'SLIDE TO CONFIRM STORE ARRIVAL',
              icon: Icons.storefront_rounded,
              color: const Color(0xFFEA580C),
              onConfirmed: () => onUpdateStatus(OrderDeliveryStatus.arrivedAtStore),
            ),
          ] else if (order.status == OrderDeliveryStatus.arrivedAtStore) ...[
            SlideToConfirmButton(
              label: 'SLIDE TO CONFIRM ORDER PICKUP',
              icon: Icons.takeout_dining_rounded,
              color: const Color(0xFF2563EB),
              onConfirmed: () => onUpdateStatus(OrderDeliveryStatus.pickedUp),
            ),
          ] else if (order.status == OrderDeliveryStatus.pickedUp || order.status == OrderDeliveryStatus.inTransit) ...[
            SlideToConfirmButton(
              label: order.isCashOnDelivery
                  ? 'SLIDE TO DELIVER & CONFIRM ₹${order.cashToCollect.toStringAsFixed(0)} CASH'
                  : 'SLIDE TO CONFIRM DELIVERY',
              icon: Icons.check_circle_rounded,
              color: const Color(0xFF059669),
              onConfirmed: () => onUpdateStatus(OrderDeliveryStatus.delivered),
            ),
          ],

          const SizedBox(height: 10),
          Center(
            child: TextButton.icon(
              onPressed: () => context.push('/order/${order.id}'),
              icon: const Icon(Icons.receipt_long_rounded, size: 16),
              label: const Text('View Full Checklist & Order Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

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
    final primary = color ?? Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: primary),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
          ],
        ),
      ),
    );
  }
}
