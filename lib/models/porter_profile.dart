class PorterProfile {
  final String id;
  final String name;
  final String phone;
  final String vehicleType;
  final String vehicleNumber;
  final bool isOnline;
  final double rating;
  final int completedTrips;
  final double todayEarnings;
  final double todayCashCollected;
  final double weeklyEarnings;

  const PorterProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.isOnline,
    required this.rating,
    required this.completedTrips,
    required this.todayEarnings,
    required this.todayCashCollected,
    required this.weeklyEarnings,
  });

  PorterProfile copyWith({
    bool? isOnline,
    int? completedTrips,
    double? todayEarnings,
    double? todayCashCollected,
    double? weeklyEarnings,
  }) {
    return PorterProfile(
      id: id,
      name: name,
      phone: phone,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      isOnline: isOnline ?? this.isOnline,
      rating: rating,
      completedTrips: completedTrips ?? this.completedTrips,
      todayEarnings: todayEarnings ?? this.todayEarnings,
      todayCashCollected: todayCashCollected ?? this.todayCashCollected,
      weeklyEarnings: weeklyEarnings ?? this.weeklyEarnings,
    );
  }
}
