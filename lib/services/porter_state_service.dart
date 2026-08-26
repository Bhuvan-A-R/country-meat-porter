import 'package:flutter/material.dart';
import '../models/delivery_order.dart';
import '../models/porter_profile.dart';
import '../models/porter_notification.dart';

class PorterStateService extends ChangeNotifier {
  PorterProfile _profile = const PorterProfile(
    id: 'PTR-8829',
    name: 'Rajesh Kumar',
    phone: '+91 98765 43210',
    vehicleType: 'EV Scooter',
    vehicleNumber: 'KA 03 EV 4912',
    isOnline: true,
    rating: 4.9,
    completedTrips: 14,
    todayEarnings: 850.0,
    todayCashCollected: 960.0,
    weeklyEarnings: 5420.0,
  );

  bool _voiceGuidanceEnabled = false;
  String _selectedLanguage = 'English';

  bool get voiceGuidanceEnabled => _voiceGuidanceEnabled;
  String get selectedLanguage => _selectedLanguage;

  void toggleVoiceGuidance() {
    _voiceGuidanceEnabled = !_voiceGuidanceEnabled;
    notifyListeners();
  }

  void updateSelectedLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  final List<PorterNotification> _notifications = [
    PorterNotification(
      id: 'NOTIF-101',
      title: '🔥 High Demand Surge Bonus!',
      message:
          'Earn ₹25 EXTRA per trip in Indiranagar & Whitefield hubs till 10:00 PM tonight.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      type: NotificationType.surge,
      isRead: false,
    ),
    PorterNotification(
      id: 'NOTIF-102',
      title: '💵 Cash Collection Deposit Reminder',
      message:
          'You have collected ₹960 COD cash today. Please deposit at Indiranagar Store Hub before 9:00 PM.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotificationType.cashDeposit,
      isRead: false,
    ),
    PorterNotification(
      id: 'NOTIF-103',
      title: '✅ Partner KYC & Vehicle Approved',
      message:
          'Your EV Scooter registration (KA 03 EV 4912) and KYC documents have been verified.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.system,
      isRead: true,
    ),
  ];

  final List<DeliveryOrder> _orders = [
    DeliveryOrder(
      id: 'CMP-2026-9041',
      customerName: 'Ananya Sharma',
      customerPhone: '+91 91234 56789',
      deliveryAddress:
          'Flat 402, Sunshine Heights, Indiranagar 100ft Rd, Bengaluru',
      customerInstructions:
          'Leave package with security guard if unreachable by phone.',
      storeName: 'Country Meat Hub - Indiranagar',
      storePhone: '+91 80234 56780',
      storeAddress: '12th Main Rd, Indiranagar, Bengaluru',
      items: [
        OrderItem(
          name: 'Fresh Chicken Breast (Skinless)',
          quantity: 2,
          weight: '500g',
          price: 240.0,
        ),
        OrderItem(
          name: 'Mutton Curry Cut (Bone-in)',
          quantity: 1,
          weight: '500g',
          price: 480.0,
        ),
        OrderItem(
          name: 'Ice Chill Gel Pack',
          quantity: 1,
          weight: 'Pack',
          price: 0.0,
          isVerified: true,
        ),
      ],
      totalAmount: 960.0,
      porterEarning: 85.0,
      isCashOnDelivery: true,
      cashToCollect: 960.0,
      status: OrderDeliveryStatus.assigned,
      estimatedTime: '18 mins',
      distanceKm: 3.2,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    DeliveryOrder(
      id: 'CMP-2026-9038',
      customerName: 'Vikram Mehta',
      customerPhone: '+91 99887 76655',
      deliveryAddress: 'Villa 12, Palm Meadows, Whitefield, Bengaluru',
      customerInstructions: 'Ring doorbell twice. Handle with care.',
      storeName: 'Country Meat Express - Whitefield',
      storePhone: '+91 80987 65430',
      storeAddress: 'ITPL Main Rd, Whitefield, Bengaluru',
      items: [
        OrderItem(
          name: 'Farm Fresh Eggs (Pack of 12)',
          quantity: 1,
          weight: '12 pcs',
          price: 110.0,
          isVerified: true,
        ),
        OrderItem(
          name: 'Cleaned Prawns (Large)',
          quantity: 1,
          weight: '250g',
          price: 350.0,
          isVerified: true,
        ),
      ],
      totalAmount: 460.0,
      porterEarning: 65.0,
      isCashOnDelivery: false,
      cashToCollect: 0.0,
      status: OrderDeliveryStatus.delivered,
      estimatedTime: 'Completed',
      distanceKm: 4.8,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  PorterProfile get profile => _profile;
  List<DeliveryOrder> get orders => _orders;
  List<PorterNotification> get notifications => _notifications;

  int get unreadNotificationCount {
    int count = 0;
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        count++;
      }
    }
    return count;
  }

  DeliveryOrder? get activeOrder {
    try {
      return _orders.firstWhere(
        (o) =>
            o.status != OrderDeliveryStatus.delivered &&
            o.status != OrderDeliveryStatus.cancelled,
      );
    } catch (_) {
      return null;
    }
  }

  void toggleDutyStatus() {
    _profile = _profile.copyWith(isOnline: !_profile.isOnline);
    notifyListeners();
  }

  void updateProfileName(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty || trimmedName == _profile.name) return;

    _profile = _profile.copyWith(name: trimmedName);
    notifyListeners();
  }

  void completeCashSettlement() {
    if (_profile.todayCashCollected <= 0) return;

    _profile = _profile.copyWith(todayCashCollected: 0);
    notifyListeners();
  }

  void toggleItemVerification(String orderId, int itemIndex) {
    final orderIdx = _orders.indexWhere((o) => o.id == orderId);
    if (orderIdx != -1 && itemIndex < _orders[orderIdx].items.length) {
      _orders[orderIdx].items[itemIndex].isVerified =
          !_orders[orderIdx].items[itemIndex].isVerified;
      notifyListeners();
    }
  }

  void verifyAllItems(String orderId) {
    final orderIdx = _orders.indexWhere((o) => o.id == orderId);
    if (orderIdx != -1) {
      for (var item in _orders[orderIdx].items) {
        item.isVerified = true;
      }
      notifyListeners();
    }
  }

  void markNotificationAsRead(String notifId) {
    final idx = _notifications.indexWhere((n) => n.id == notifId);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i].isRead = true;
    }
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderDeliveryStatus nextStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final updatedOrder = _orders[index].copyWith(status: nextStatus);
      _orders[index] = updatedOrder;

      if (nextStatus == OrderDeliveryStatus.delivered) {
        _profile = _profile.copyWith(
          completedTrips: _profile.completedTrips + 1,
          todayEarnings: _profile.todayEarnings + updatedOrder.porterEarning,
          todayCashCollected:
              _profile.todayCashCollected +
              (updatedOrder.isCashOnDelivery
                  ? updatedOrder.cashToCollect
                  : 0.0),
          weeklyEarnings: _profile.weeklyEarnings + updatedOrder.porterEarning,
        );
      }

      notifyListeners();
    }
  }

  void resetOrAssignDemoOrder() {
    // If order exists in completed state, reset its status to assigned
    for (int i = 0; i < _orders.length; i++) {
      if (_orders[i].status == OrderDeliveryStatus.delivered) {
        _orders[i] = _orders[i].copyWith(status: OrderDeliveryStatus.assigned);
        for (var item in _orders[i].items) {
          item.isVerified = false;
        }
      }
    }

    // Also add a new fresh task if none are active
    if (activeOrder == null) {
      _orders.insert(
        0,
        DeliveryOrder(
          id: 'CMP-2026-${9042 + _orders.length}',
          customerName: 'Priya Sundaram',
          customerPhone: '+91 98450 12345',
          deliveryAddress: 'Apt 104, Green Glen Layout, Indiranagar, Bengaluru',
          customerInstructions: 'Ring bell and hand over fresh meat gel pouch.',
          storeName: 'Country Meat Hub - Indiranagar',
          storePhone: '+91 80234 56780',
          storeAddress: '12th Main Rd, Indiranagar, Bengaluru',
          items: [
            OrderItem(
              name: 'Fresh Chicken Breast (Skinless)',
              quantity: 2,
              weight: '500g',
              price: 240.0,
            ),
            OrderItem(
              name: 'Mutton Curry Cut (Bone-in)',
              quantity: 1,
              weight: '500g',
              price: 480.0,
            ),
            OrderItem(
              name: 'Ice Chill Gel Pack',
              quantity: 1,
              weight: 'Pack',
              price: 0.0,
              isVerified: false,
            ),
          ],
          totalAmount: 960.0,
          porterEarning: 95.0,
          isCashOnDelivery: true,
          cashToCollect: 960.0,
          status: OrderDeliveryStatus.assigned,
          estimatedTime: '15 mins',
          distanceKm: 2.8,
          createdAt: DateTime.now(),
        ),
      );
    }
    notifyListeners();
  }
}
