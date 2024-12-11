class Message {
  final int id;
  final Room room;
  final String message;
  final String sender;
  final DateTime timestamp;
  final bool read;

  Message({
    required this.id,
    required this.room,
    required this.message,
    required this.sender,
    required this.timestamp,
    required this.read,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      room: Room.fromJson(json['room']),
      message: json['message'],
      sender: json['sender'],
      timestamp: DateTime.parse(json['timestamp']),
      read: json['read'],
    );
  }
}

class Room {
  final String roomId;
  final Shop shop;
  final Client client;

  Room({
    required this.roomId,
    required this.shop,
    required this.client,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['room_id'],
      shop: Shop.fromJson(json['shop']),
      client: Client.fromJson(json['client']),
    );
  }
}

class Shop {
  final String userId;
  final String email;
  final String fullName;
  final ShopUser shopUser;

  Shop({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.shopUser,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      userId: json['user_id'],
      email: json['email'],
      fullName: json['full_name'],
      shopUser: ShopUser.fromJson(json['shop_user']),
    );
  }
}

class ShopUser {
  final String shopId;
  final String shopName;
  final String photo;

  ShopUser({
    required this.shopId,
    required this.shopName,
    required this.photo,
  });

  factory ShopUser.fromJson(Map<String, dynamic> json) {
    return ShopUser(
      shopId: json['shop_id'],
      shopName: json['shop_name'],
      photo: json['photo'],
    );
  }
}

class Client {
  final String userId;
  final String email;
  final String fullName;
  final PersonalInfo personalInfo;

  Client({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.personalInfo,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      userId: json['user_id'],
      email: json['email'],
      fullName: json['full_name'],
      personalInfo: PersonalInfo.fromJson(json['personal_info']),
    );
  }
}

class PersonalInfo {
  final String photo;
  final String phone;

  PersonalInfo({
    required this.photo,
    required this.phone,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      photo: json['photo'],
      phone: json['phone'],
    );
  }
}
