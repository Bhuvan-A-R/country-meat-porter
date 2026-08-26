import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/porter_ui_tokens.dart';
import '../../services/porter_state_service.dart';
import '../../models/delivery_order.dart';
import 'widgets/order_list_card.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PorterStateService>();
    final orders = state.orders;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: PorterUiTokens.bg,
        appBar: AppBar(
          title: const Text(
            'Driver Task List',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            labelColor: Color(0xFFC62828),
            unselectedLabelColor: PorterUiTokens.mutedText,
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
              orders: orders
                  .where(
                    (o) =>
                        o.status != OrderDeliveryStatus.delivered &&
                        o.status != OrderDeliveryStatus.cancelled,
                  )
                  .toList(),
              emptyMessage: 'No pending delivery tasks assigned.',
            ),
            _DriverOrdersListView(
              orders: orders
                  .where((o) => o.status == OrderDeliveryStatus.delivered)
                  .toList(),
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
              Text(
                emptyMessage,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
        return OrderListCard(
          order: order,
          onTap: () => context.push('/order/${order.id}'),
        );
      },
    );
  }
}
