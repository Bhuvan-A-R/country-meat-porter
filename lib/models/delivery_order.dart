enum OrderDeliveryStatus {
  assigned,
  arrivedAtStore,
  pickedUp,
  inTransit,
  delivered,
  cancelled,
}

class OrderItem {
  final String name;
  final int quantity;
  final String weight;
  final double price;
  bool isVerified;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.weight,
    required this.price,
    this.isVerified = false,
  });
}

class DeliveryOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String customerInstructions;
  final String storeName;
  final String storePhone;
  final String storeAddress;
  final List<OrderItem> items;
  final double totalAmount;
  final double porterEarning;
  final bool isCashOnDelivery;
  final double cashToCollect;
  final OrderDeliveryStatus status;
  final String estimatedTime;
  final double distanceKm;
  final DateTime createdAt;

  DeliveryOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.customerInstructions,
    required this.storeName,
    required this.storePhone,
    required this.storeAddress,
    required this.items,
    required this.totalAmount,
    required this.porterEarning,
    required this.isCashOnDelivery,
    required this.cashToCollect,
    required this.status,
    required this.estimatedTime,
    required this.distanceKm,
    required this.createdAt,
  });

  DeliveryOrder copyWith({
    OrderDeliveryStatus? status,
    List<OrderItem>? items,
  }) {
    return DeliveryOrder(
      id: id,
      customerName: customerName,
      customerPhone: customerPhone,
      deliveryAddress: deliveryAddress,
      customerInstructions: customerInstructions,
      storeName: storeName,
      storePhone: storePhone,
      storeAddress: storeAddress,
      items: items ?? this.items,
      totalAmount: totalAmount,
      porterEarning: porterEarning,
      isCashOnDelivery: isCashOnDelivery,
      cashToCollect: cashToCollect,
      status: status ?? this.status,
      estimatedTime: estimatedTime,
      distanceKm: distanceKm,
      createdAt: createdAt,
    );
  }

  String get statusLabel {
    switch (status) {
      case OrderDeliveryStatus.assigned:
        return 'Assigned - Head to Store';
      case OrderDeliveryStatus.arrivedAtStore:
        return 'Arrived at Store - Verify Items';
      case OrderDeliveryStatus.pickedUp:
        return 'Picked Up - Start Navigation';
      case OrderDeliveryStatus.inTransit:
        return 'In Transit to Customer';
      case OrderDeliveryStatus.delivered:
        return 'Delivered Successfully';
      case OrderDeliveryStatus.cancelled:
        return 'Task Cancelled';
    }
  }

  bool get allItemsVerified {
    return items.every((item) => item.isVerified);
  }
}
