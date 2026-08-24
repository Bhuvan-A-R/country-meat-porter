import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/country_meat_state.dart';
import '../../models/cart.dart';

class CustomerCartScreen extends StatelessWidget {
  const CustomerCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CountryMeatStateService>();
    final cartItems = state.cartItems;
    final primary = Theme.of(context).colorScheme.primary;

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Cart')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text('Your cart is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Browse fresh chicken, mutton, or seafood cuts to start ordering.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/categories'),
                child: const Text('Explore Meat Categories'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${state.cartTotalQuantity} Items)'),
        actions: [
          TextButton(
            onPressed: () => state.clearCart(),
            child: const Text('Clear', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart Items List Card
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartItems.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade800,
                            child: Image.network(
                              item.product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, color: Colors.white54),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 2),
                              Text('${item.selectedWeight.label} • ${item.selectedCut.name}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text('₹${item.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: primary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => state.updateCartQuantity(index, -1),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Icon(Icons.remove, size: 16),
                                ),
                              ),
                              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              InkWell(
                                onTap: () => state.updateCartQuantity(index, 1),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Icon(Icons.add, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Delivery Slot Selection
            const Text('Delivery Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _SlotOptionTile(
                      slot: const DeliverySlot(
                        id: 'express',
                        title: 'Express Delivery ⚡',
                        timeWindow: 'Arrives in 30 Mins',
                        isExpress: true,
                        fee: 29.0,
                      ),
                      isSelected: state.selectedSlot.id == 'express',
                      onSelect: (s) => state.selectDeliverySlot(s),
                    ),
                    const Divider(height: 12),
                    _SlotOptionTile(
                      slot: const DeliverySlot(
                        id: 'scheduled',
                        title: 'Scheduled Slot 🕒',
                        timeWindow: 'Tomorrow 7:00 AM - 10:00 AM',
                        isExpress: false,
                        fee: 15.0,
                      ),
                      isSelected: state.selectedSlot.id == 'scheduled',
                      onSelect: (s) => state.selectDeliverySlot(s),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Coupon Code Selector
            const Text('Coupons & Offers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    if (state.appliedCoupon != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.local_offer, color: Colors.green, size: 18),
                              const SizedBox(width: 8),
                              Text('Coupon ${state.appliedCoupon!.code} Applied!', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                            onPressed: () => state.removeCoupon(),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: state.availableCoupons.map((c) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.local_offer_outlined, color: Colors.amber),
                            title: Text(c.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(c.description, style: const TextStyle(fontSize: 11)),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber.shade800,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                minimumSize: Size.zero,
                              ),
                              onPressed: () => state.applyCoupon(c),
                              child: const Text('APPLY', style: TextStyle(fontSize: 11)),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bill Summary Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bill Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    _BillRow(label: 'Item Subtotal', value: '₹${state.subtotalAmount.toStringAsFixed(0)}'),
                    _BillRow(label: 'Delivery Fee', value: '₹${state.selectedSlot.fee.toStringAsFixed(0)}'),
                    if (state.discountAmount > 0)
                      _BillRow(label: 'Coupon Discount', value: '-₹${state.discountAmount.toStringAsFixed(0)}', isGreen: true),
                    const Divider(height: 20),
                    _BillRow(label: 'To Pay', value: '₹${state.finalTotalAmount.toStringAsFixed(0)}', isBold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TOTAL PAYABLE', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                Text(
                  '₹${state.finalTotalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: primary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order Placed Successfully! Redirecting to Tracking...')),
                  );
                  context.go('/order-tracking/CMP-2026-9041');
                },
                icon: const Icon(Icons.payment_rounded),
                label: const Text('Proceed to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotOptionTile extends StatelessWidget {
  final DeliverySlot slot;
  final bool isSelected;
  final Function(DeliverySlot) onSelect;

  const _SlotOptionTile({
    required this.slot,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () => onSelect(slot),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? primary : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(slot.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(slot.timeWindow, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            Text('₹${slot.fee.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isGreen;

  const _BillRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 15 : 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: isBold ? 16 : 13,
              color: isGreen ? Colors.green : (isBold ? Theme.of(context).colorScheme.primary : null),
            ),
          ),
        ],
      ),
    );
  }
}
