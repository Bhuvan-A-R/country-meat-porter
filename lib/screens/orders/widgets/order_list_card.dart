import 'package:flutter/material.dart';

import '../../../core/theme/porter_ui_tokens.dart';
import '../../../models/delivery_order.dart';

class OrderListCard extends StatelessWidget {
  final DeliveryOrder order;
  final VoidCallback onTap;

  const OrderListCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isCompleted = order.status == OrderDeliveryStatus.delivered;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: PorterUiTokens.surfaceCard(
        boxShadow: PorterUiTokens.surfaceShadow,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: PorterUiTokens.brLg,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: PorterUiTokens.strongText,
                    ),
                  ),
                  Text(
                    'Payout: ₹${order.porterEarning.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: PorterUiTokens.success,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(height: 1, color: PorterUiTokens.border),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.storefront_rounded,
                    color: PorterUiTokens.pickup,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Store: ${order.storeName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: PorterUiTokens.strongText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFFC62828),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Drop: ${order.deliveryAddress}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: PorterUiTokens.mutedText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCompleted
                            ? const Color(0xFFA7F3D0)
                            : const Color(0xFFFFEDD5),
                      ),
                    ),
                    child: Text(
                      order.statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isCompleted
                            ? PorterUiTokens.success
                            : PorterUiTokens.pickup,
                      ),
                    ),
                  ),
                  if (order.isCashOnDelivery && !isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'COD: ₹${order.cashToCollect.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: PorterUiTokens.warning,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
