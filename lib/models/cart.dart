import 'product.dart';

class CartItem {
  final Product product;
  final WeightOption selectedWeight;
  final CutOption selectedCut;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedWeight,
    required this.selectedCut,
    this.quantity = 1,
  });

  double get totalPrice => selectedWeight.price * quantity;
}

class DeliverySlot {
  final String id;
  final String title;
  final String timeWindow;
  final bool isExpress;
  final double fee;

  const DeliverySlot({
    required this.id,
    required this.title,
    required this.timeWindow,
    required this.isExpress,
    required this.fee,
  });
}

class Coupon {
  final String code;
  final String description;
  final double discountAmount;
  final double minOrderValue;

  const Coupon({
    required this.code,
    required this.description,
    required this.discountAmount,
    required this.minOrderValue,
  });
}
