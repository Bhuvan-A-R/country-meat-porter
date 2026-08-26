import 'package:flutter/material.dart';

import '../../../core/theme/porter_ui_tokens.dart';
import '../../../models/delivery_order.dart';

class DriverActiveTaskCard extends StatelessWidget {
  final DeliveryOrder order;
  final VoidCallback onOpenDetails;
  final ValueChanged<String> onLaunchMaps;
  final ValueChanged<String> onCallPhone;
  final bool voiceGuidanceEnabled;
  final VoidCallback onPlayVoice;

  const DriverActiveTaskCard({
    super.key,
    required this.order,
    required this.onOpenDetails,
    required this.onLaunchMaps,
    required this.onCallPhone,
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
      decoration: PorterUiTokens.surfaceCard(
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
                    color: PorterUiTokens.strongText,
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
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Text(
                  'PAYOUT ₹${order.porterEarning.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: PorterUiTokens.success,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _VisualRouteTimeline(order: order),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: PorterUiTokens.border),
          ),
          Container(
            padding: EdgeInsets.all(isPickupPhase ? 14 : 10),
            decoration: BoxDecoration(
              color: isPickupPhase
                  ? const Color(0xFFFFF7ED)
                  : Colors.transparent,
              borderRadius: PorterUiTokens.brMd,
              border: isPickupPhase
                  ? Border.all(color: const Color(0xFFFFEDD5), width: 1.5)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isPickupPhase
                        ? PorterUiTokens.pickup
                        : const Color(0xFFFFF7ED),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    color: isPickupPhase ? Colors.white : PorterUiTokens.pickup,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PICKUP STORE HUB',
                        style: TextStyle(
                          fontSize: 10,
                          color: PorterUiTokens.pickup,
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
                          color: PorterUiTokens.strongText,
                        ),
                      ),
                      Text(
                        order.storeAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: PorterUiTokens.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isPickupPhase) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PorterUiTokens.pickup,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: PorterUiTokens.brSm,
                      ),
                      elevation: 1,
                    ),
                    onPressed: () => onCallPhone(order.storePhone),
                    icon: const Icon(Icons.phone_rounded, size: 19),
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
                      backgroundColor: PorterUiTokens.info,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: PorterUiTokens.brSm,
                      ),
                      elevation: 1,
                    ),
                    onPressed: () => onLaunchMaps(order.storeAddress),
                    icon: const Icon(Icons.near_me_rounded, size: 19),
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
          Container(
            padding: EdgeInsets.all(!isPickupPhase ? 14 : 10),
            decoration: BoxDecoration(
              color: !isPickupPhase
                  ? const Color(0xFFEFF6FF)
                  : Colors.transparent,
              borderRadius: PorterUiTokens.brMd,
              border: !isPickupPhase
                  ? Border.all(color: const Color(0xFFDBEAFE), width: 1.5)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: !isPickupPhase ? primary : const Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: !isPickupPhase ? Colors.white : primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          color: PorterUiTokens.strongText,
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
          if (!isPickupPhase) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PorterUiTokens.success,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: PorterUiTokens.brSm,
                      ),
                      elevation: 1,
                    ),
                    onPressed: () => onCallPhone(order.customerPhone),
                    icon: const Icon(Icons.phone_in_talk_rounded, size: 19),
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
                      backgroundColor: PorterUiTokens.info,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: PorterUiTokens.brSm,
                      ),
                      elevation: 1,
                    ),
                    onPressed: () => onLaunchMaps(order.deliveryAddress),
                    icon: const Icon(Icons.near_me_rounded, size: 19),
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
          if (order.isCashOnDelivery) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: PorterUiTokens.brSm,
                border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.payments_rounded,
                    color: PorterUiTokens.warning,
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onOpenDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: PorterUiTokens.brSm,
                ),
                elevation: 1,
              ),
              icon: const Icon(Icons.open_in_new_rounded, size: 19),
              label: const Text(
                'VIEW TASK DETAILS',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisualRouteTimeline extends StatelessWidget {
  final DeliveryOrder order;

  const _VisualRouteTimeline({required this.order});

  @override
  Widget build(BuildContext context) {
    final bool step1Done = order.status != OrderDeliveryStatus.assigned;

    final bool step2Done =
        order.status == OrderDeliveryStatus.pickedUp ||
        order.status == OrderDeliveryStatus.inTransit ||
        order.status == OrderDeliveryStatus.delivered;

    final bool step3Done = order.status == OrderDeliveryStatus.delivered;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          _StepperNode(
            icon: Icons.storefront_rounded,
            title: 'HUB',
            isCurrent:
                order.status == OrderDeliveryStatus.assigned ||
                order.status == OrderDeliveryStatus.arrivedAtStore,
            isCompleted: step1Done,
            color: PorterUiTokens.pickup,
          ),
          Expanded(
            child: Container(
              height: 3,
              color: step1Done
                  ? PorterUiTokens.pickup
                  : const Color(0xFFE2E8F0),
            ),
          ),
          _StepperNode(
            icon: Icons.two_wheeler_rounded,
            title: 'RIDE',
            isCurrent:
                order.status == OrderDeliveryStatus.pickedUp ||
                order.status == OrderDeliveryStatus.inTransit,
            isCompleted: step2Done,
            color: PorterUiTokens.info,
          ),
          Expanded(
            child: Container(
              height: 3,
              color: step2Done ? PorterUiTokens.info : const Color(0xFFE2E8F0),
            ),
          ),
          _StepperNode(
            icon: Icons.home_rounded,
            title: 'DROP',
            isCurrent: order.status == OrderDeliveryStatus.delivered,
            isCompleted: step3Done,
            color: PorterUiTokens.success,
          ),
        ],
      ),
    );
  }
}

class _StepperNode extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCurrent;
  final bool isCompleted;
  final Color color;

  const _StepperNode({
    required this.icon,
    required this.title,
    required this.isCurrent,
    required this.isCompleted,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    Color contentColor = PorterUiTokens.mutedText;

    if (isCompleted) {
      contentColor = color;
    } else if (isCurrent) {
      contentColor = PorterUiTokens.strongText;
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
                : PorterUiTokens.border,
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
            isCompleted ? Icons.check_rounded : icon,
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
            fontWeight: isCurrent || isCompleted
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
