import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/porter_state_service.dart';
import '../../models/delivery_order.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PorterStateService>();
    final orders = state.orders;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text('Driver Task List', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            labelColor: Color(0xFFC62828),
            unselectedLabelColor: Color(0xFF64748B),
            indicatorColor: Color(0xFFC62828),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              Tab(text: 'Active Tasks'),
              Tab(text: 'Completed Trips'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _DriverOrdersListView(
              orders: orders.where((o) => o.status != OrderDeliveryStatus.delivered && o.status != OrderDeliveryStatus.cancelled).toList(),
              emptyMessage: 'No pending delivery tasks assigned.',
            ),
            _DriverOrdersListView(
              orders: orders.where((o) => o.status == OrderDeliveryStatus.delivered).toList(),
              emptyMessage: 'No completed trips recorded today.',
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverOrdersListView extends StatelessWidget {
  final List<DeliveryOrder> orders;
  final String emptyMessage;

  const _DriverOrdersListView({
    required this.orders,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 56, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(emptyMessage, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 4)),
            ],
          ),
          child: InkWell(
            onTap: () => context.push('/order/${order.id}'),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.id, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF0F172A))),
                      Text(
                        'Payout: ₹${order.porterEarning.toStringAsFixed(0)}',
                        style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.w900, fontSize: 15),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.storefront_rounded, color: Color(0xFFEA580C), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Store: ${order.storeName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Color(0xFFC62828), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Drop: ${order.deliveryAddress}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: order.status == OrderDeliveryStatus.delivered ? const Color(0xFFECFDF5) : const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: order.status == OrderDeliveryStatus.delivered ? const Color(0xFFA7F3D0) : const Color(0xFFFFEDD5)),
                        ),
                        child: Text(
                          order.statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: order.status == OrderDeliveryStatus.delivered ? const Color(0xFF059669) : const Color(0xFFEA580C),
                          ),
                        ),
                      ),
                      if (order.isCashOnDelivery && order.status != OrderDeliveryStatus.delivered)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'COD: ₹${order.cashToCollect.toStringAsFixed(0)}',
                            style: const TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
