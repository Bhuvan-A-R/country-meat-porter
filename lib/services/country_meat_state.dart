import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';

class CountryMeatStateService extends ChangeNotifier {
  String _selectedLocation = 'Indiranagar 100ft Rd, Bengaluru 560038';
  String _searchQuery = '';
  Coupon? _appliedCoupon;
  DeliverySlot _selectedSlot = const DeliverySlot(
    id: 'express',
    title: 'Express Delivery',
    timeWindow: 'Within 30 Mins',
    isExpress: true,
    fee: 29.0,
  );

  final List<CartItem> _cartItems = [];

  final List<MeatCategory> _categories = const [
    MeatCategory(id: 'chicken', name: 'Chicken', icon: '🍗', bannerImage: ''),
    MeatCategory(id: 'mutton', name: 'Mutton', icon: '🥩', bannerImage: ''),
    MeatCategory(id: 'seafood', name: 'Fish & Seafood', icon: '🐟', bannerImage: ''),
    MeatCategory(id: 'eggs', name: 'Farm Eggs', icon: '🥚', bannerImage: ''),
    MeatCategory(id: 'ready', name: 'Ready to Cook', icon: '🍢', bannerImage: ''),
    MeatCategory(id: 'spices', name: 'Meat Spices', icon: '🌶️', bannerImage: ''),
  ];

  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'Fresh Chicken Breast (Skinless, Boneless)',
      categoryId: 'chicken',
      imageUrl: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=500',
      description: 'Tender, juicy, 100% antibiotic-free chicken breast fillets. Perfect for grilling, roasting, or chicken salads.',
      price: 245.0,
      originalPrice: 290.0,
      weight: '500g',
      rating: 4.8,
      reviewsCount: 1240,
      isBestseller: true,
      isAntibioticFree: true,
      weightOptions: const [
        WeightOption(label: '500g', weight: '500g', price: 245.0, originalPrice: 290.0),
        WeightOption(label: '1 kg', weight: '1000g', price: 470.0, originalPrice: 560.0),
      ],
      cutOptions: const [
        CutOption(id: 'fillet', name: 'Fillet / Whole', description: 'Whole tender breast pieces'),
        CutOption(id: 'cubes', name: 'Tikka Cubes', description: 'Bite-sized boneless cubes'),
        CutOption(id: 'mince', name: 'Chicken Mince (Keema)', description: 'Finely ground chicken keema'),
      ],
      recipes: const [
        Recipe(id: 'r1', title: 'Grilled Herb Chicken', prepTime: '25 mins', difficulty: 'Easy', imageUrl: ''),
        Recipe(id: 'r2', title: 'Creamy Butter Chicken', prepTime: '40 mins', difficulty: 'Medium', imageUrl: ''),
      ],
    ),
    Product(
      id: 'p2',
      name: 'Mutton Curry Cut (Bone-in, Premium Goat)',
      categoryId: 'mutton',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500',
      description: 'Rich, tender, pasture-raised goat meat with rib & shoulder pieces. Ideal for traditional curries.',
      price: 490.0,
      originalPrice: 560.0,
      weight: '500g',
      rating: 4.9,
      reviewsCount: 890,
      isBestseller: true,
      isAntibioticFree: true,
      weightOptions: const [
        WeightOption(label: '500g', weight: '500g', price: 490.0, originalPrice: 560.0),
        WeightOption(label: '1 kg', weight: '1000g', price: 950.0, originalPrice: 1100.0),
      ],
      cutOptions: const [
        CutOption(id: 'curry', name: 'Curry Cut (Bone-in)', description: 'Mix of shoulder & rib pieces'),
        CutOption(id: 'biryani', name: 'Biryani Cut (Large)', description: 'Succulent large cuts for biryani'),
        CutOption(id: 'boneless', name: 'Boneless Mutton', description: 'Tender boti cuts without bone'),
      ],
      recipes: const [
        Recipe(id: 'r3', title: 'Hyderabadi Mutton Biryani', prepTime: '60 mins', difficulty: 'Hard', imageUrl: ''),
      ],
    ),
    Product(
      id: 'p3',
      name: 'Freshwater Rohu Fish (Curry Cut)',
      categoryId: 'seafood',
      imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500',
      description: 'Freshly caught Bengal Rohu fish, cleaned and descaled with head & tail cuts.',
      price: 210.0,
      originalPrice: 250.0,
      weight: '500g',
      rating: 4.7,
      reviewsCount: 512,
      isBestseller: false,
      isAntibioticFree: true,
      weightOptions: const [
        WeightOption(label: '500g', weight: '500g', price: 210.0, originalPrice: 250.0),
        WeightOption(label: '1 kg', weight: '1000g', price: 399.0, originalPrice: 480.0),
      ],
      cutOptions: const [
        CutOption(id: 'steaks', name: 'Steaks / Bengali Cut', description: 'Transverse cut steaks with bone'),
        CutOption(id: 'boneless_fillet', name: 'Boneless Fillet', description: 'Skinless boneless fish fillets'),
      ],
      recipes: const [],
    ),
    Product(
      id: 'p4',
      name: 'Farm Fresh Organic Eggs (Pack of 12)',
      categoryId: 'eggs',
      imageUrl: 'https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?w=500',
      description: 'Free-range, brown shell organic eggs rich in Omega-3 and Vitamin D.',
      price: 115.0,
      originalPrice: 135.0,
      weight: '12 pcs',
      rating: 4.9,
      reviewsCount: 2300,
      isBestseller: true,
      isAntibioticFree: true,
      weightOptions: const [
        WeightOption(label: '12 Pcs', weight: '12 pcs', price: 115.0, originalPrice: 135.0),
        WeightOption(label: '30 Pcs Tray', weight: '30 pcs', price: 270.0, originalPrice: 320.0),
      ],
      cutOptions: const [
        CutOption(id: 'standard', name: 'Standard Pack', description: 'Intact fresh eggs'),
      ],
      recipes: const [],
    ),
  ];

  final List<Coupon> _availableCoupons = const [
    Coupon(code: 'MEAT50', description: 'Flat ₹50 OFF on orders above ₹499', discountAmount: 50.0, minOrderValue: 499.0),
    Coupon(code: 'FIRSTCUT', description: '20% OFF up to ₹100 on First Order', discountAmount: 100.0, minOrderValue: 299.0),
  ];

  String get selectedLocation => _selectedLocation;
  String get searchQuery => _searchQuery;
  List<MeatCategory> get categories => _categories;
  List<Product> get products => _products;
  List<CartItem> get cartItems => _cartItems;
  Coupon? get appliedCoupon => _appliedCoupon;
  DeliverySlot get selectedSlot => _selectedSlot;
  List<Coupon> get availableCoupons => _availableCoupons;

  int get cartTotalQuantity {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotalAmount {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get discountAmount {
    if (_appliedCoupon == null) return 0.0;
    if (subtotalAmount < _appliedCoupon!.minOrderValue) return 0.0;
    return _appliedCoupon!.discountAmount;
  }

  double get finalTotalAmount {
    final sub = subtotalAmount;
    if (sub == 0) return 0;
    return (sub - discountAmount + _selectedSlot.fee).clamp(0.0, 99999.0);
  }

  void updateLocation(String newLoc) {
    _selectedLocation = newLoc;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectDeliverySlot(DeliverySlot slot) {
    _selectedSlot = slot;
    notifyListeners();
  }

  void applyCoupon(Coupon coupon) {
    _appliedCoupon = coupon;
    notifyListeners();
  }

  void removeCoupon() {
    _appliedCoupon = null;
    notifyListeners();
  }

  void addToCart(Product product, {WeightOption? weight, CutOption? cut}) {
    final selectedW = weight ?? product.weightOptions.first;
    final selectedC = cut ?? product.cutOptions.first;

    final index = _cartItems.indexWhere(
      (item) => item.product.id == product.id && item.selectedWeight.label == selectedW.label && item.selectedCut.id == selectedC.id,
    );

    if (index != -1) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(CartItem(
        product: product,
        selectedWeight: selectedW,
        selectedCut: selectedC,
        quantity: 1,
      ));
    }
    notifyListeners();
  }

  void updateCartQuantity(int index, int delta) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index].quantity += delta;
      if (_cartItems[index].quantity <= 0) {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _appliedCoupon = null;
    notifyListeners();
  }
}
