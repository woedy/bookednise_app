class ListUserBookingsModel {
  String? message;
  Data? data;

  ListUserBookingsModel({this.message, this.data});

  ListUserBookingsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Upcoming>? upcoming;
  List<Upcoming>? history;
  List<Upcoming>? allBookings;

  Data({this.upcoming, this.history, this.allBookings});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['upcoming'] != null) {
      upcoming = <Upcoming>[];
      json['upcoming'].forEach((v) {
        upcoming!.add(new Upcoming.fromJson(v));
      });
    }
    if (json['history'] != null) {
      history = <Upcoming>[];
      json['history'].forEach((v) {
        history!.add(new Upcoming.fromJson(v));
      });
    }
    if (json['all_bookings'] != null) {
      allBookings = <Upcoming>[];
      json['all_bookings'].forEach((v) {
        allBookings!.add(new Upcoming.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.upcoming != null) {
      data['upcoming'] = this.upcoming!.map((v) => v.toJson()).toList();
    }
    if (this.history != null) {
      data['history'] = this.history!.map((v) => v.toJson()).toList();
    }
    if (this.allBookings != null) {
      data['all_bookings'] = this.allBookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Upcoming {
  String? bookingId;
  Client? client;
  String? serviceType;
  Service? service;
  Shop? shop;
  Package? package;
  String? bookingDate;
  String? bookingTime;
  String? status;
  int? slot;
  BookingPayments? bookingPayments;
  BookedStaff? bookedStaff;

  Upcoming(
      {this.bookingId,
        this.client,
        this.serviceType,
        this.service,
        this.shop,
        this.package,
        this.bookingDate,
        this.bookingTime,
        this.status,
        this.slot,
        this.bookingPayments,
        this.bookedStaff});

  Upcoming.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    client =
    json['client'] != null ? new Client.fromJson(json['client']) : null;
    serviceType = json['service_type'];
    service =
    json['service'] != null ? new Service.fromJson(json['service']) : null;
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    package =
    json['package'] != null ? new Package.fromJson(json['package']) : null;
    bookingDate = json['booking_date'];
    bookingTime = json['booking_time'];
    status = json['status'];
    slot = json['slot'];
    bookingPayments = json['booking_payments'] != null
        ? new BookingPayments.fromJson(json['booking_payments'])
        : null;
    bookedStaff = json['booked_staff'] != null
        ? new BookedStaff.fromJson(json['booked_staff'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    if (this.client != null) {
      data['client'] = this.client!.toJson();
    }
    data['service_type'] = this.serviceType;
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    if (this.shop != null) {
      data['shop'] = this.shop!.toJson();
    }
    if (this.package != null) {
      data['package'] = this.package!.toJson();
    }
    data['booking_date'] = this.bookingDate;
    data['booking_time'] = this.bookingTime;
    data['status'] = this.status;
    data['slot'] = this.slot;
    if (this.bookingPayments != null) {
      data['booking_payments'] = this.bookingPayments!.toJson();
    }
    if (this.bookedStaff != null) {
      data['booked_staff'] = this.bookedStaff!.toJson();
    }
    return data;
  }
}

class Client {
  String? userId;
  String? email;
  String? fullName;
  PersonalInfo? personalInfo;

  Client({this.userId, this.email, this.fullName, this.personalInfo});

  Client.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    email = json['email'];
    fullName = json['full_name'];
    personalInfo = json['personal_info'] != null
        ? new PersonalInfo.fromJson(json['personal_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    if (this.personalInfo != null) {
      data['personal_info'] = this.personalInfo!.toJson();
    }
    return data;
  }
}

class PersonalInfo {
  String? photo;
  String? phone;

  PersonalInfo({this.photo, this.phone});

  PersonalInfo.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['phone'] = this.phone;
    return data;
  }
}

class Service {
  String? serviceId;
  String? serviceType;
  List<int>? serviceSpecialist;

  Service({this.serviceId, this.serviceType, this.serviceSpecialist});

  Service.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceType = json['service_type'];
    serviceSpecialist = json['service_specialist'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_type'] = this.serviceType;
    data['service_specialist'] = this.serviceSpecialist;
    return data;
  }
}

class Shop {
  String? shopName;
  String? photo;
  String? locationName;
  bool? open;

  Shop({this.shopName, this.photo, this.locationName, this.open});

  Shop.fromJson(Map<String, dynamic> json) {
    shopName = json['shop_name'];
    photo = json['photo'];
    locationName = json['location_name'];
    open = json['open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_name'] = this.shopName;
    data['photo'] = this.photo;
    data['location_name'] = this.locationName;
    data['open'] = this.open;
    return data;
  }
}

class Package {
  int? id;
  String? packageName;
  String? photo;
  String? price;
  int? rating;

  Package({this.id, this.packageName, this.photo, this.price, this.rating});

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageName = json['package_name'];
    photo = json['photo'];
    price = json['price'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['package_name'] = this.packageName;
    data['photo'] = this.photo;
    data['price'] = this.price;
    data['rating'] = this.rating;
    return data;
  }
}

class BookingPayments {
  Null? paymentMethod;
  Null? amount;

  BookingPayments({this.paymentMethod, this.amount});

  BookingPayments.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_method'] = this.paymentMethod;
    data['amount'] = this.amount;
    return data;
  }
}

class BookedStaff {
  String? staffId;
  String? staffName;
  String? role;
  String? photo;
  int? rating;
  User? user;

  BookedStaff(
      {this.staffId,
        this.staffName,
        this.role,
        this.photo,
        this.rating,
        this.user});

  BookedStaff.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    staffName = json['staff_name'];
    role = json['role'];
    photo = json['photo'];
    rating = json['rating'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    data['staff_name'] = this.staffName;
    data['role'] = this.role;
    data['photo'] = this.photo;
    data['rating'] = this.rating;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  List<StaffSlot>? staffSlot;

  User({this.staffSlot});

  User.fromJson(Map<String, dynamic> json) {
    if (json['staff_slot'] != null) {
      staffSlot = <StaffSlot>[];
      json['staff_slot'].forEach((v) {
        staffSlot!.add(new StaffSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.staffSlot != null) {
      data['staff_slot'] = this.staffSlot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffSlot {
  int? id;
  String? slotDate;
  int? timeSlotCount;
  String? state;
  List<SlotTimes>? slotTimes;

  StaffSlot(
      {this.id, this.slotDate, this.timeSlotCount, this.state, this.slotTimes});

  StaffSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slotDate = json['slot_date'];
    timeSlotCount = json['time_slot_count'];
    state = json['state'];
    if (json['slot_times'] != null) {
      slotTimes = <SlotTimes>[];
      json['slot_times'].forEach((v) {
        slotTimes!.add(new SlotTimes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slot_date'] = this.slotDate;
    data['time_slot_count'] = this.timeSlotCount;
    data['state'] = this.state;
    if (this.slotTimes != null) {
      data['slot_times'] = this.slotTimes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotTimes {
  String? time;
  bool? occupied;
  Occupant? occupant;

  SlotTimes({this.time, this.occupied, this.occupant});

  SlotTimes.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    occupied = json['occupied'];
    occupant = json['occupant'] != null
        ? new Occupant.fromJson(json['occupant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['occupied'] = this.occupied;
    if (this.occupant != null) {
      data['occupant'] = this.occupant!.toJson();
    }
    return data;
  }
}

class Occupant {
  String? userId;
  String? email;
  String? fullName;

  Occupant({this.userId, this.email, this.fullName});

  Occupant.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    email = json['email'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    return data;
  }
}
