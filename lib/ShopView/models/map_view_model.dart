class Shop {
  final String shopName;
  final String shopId;
  final String location;  // Added location field
  final double latitude;
  final double longitude;
  final double distance;
  final String photo;

  Shop({
    required this.shopName,
    required this.shopId,
    required this.location,  // Added to constructor
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.photo,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      shopName: json['shop_name'],
      shopId: json['shop_id'],
      location: json['location'],  // Added to fromJson
      latitude: json['lat'],
      longitude: json['lng'],
      distance: json['distance'],
      photo: json['photo'],
    );
  }
}
