class ShopModel {
  String? message;
  Data? data;

  ShopModel({this.message, this.data});

  ShopModel.fromJson(Map<String, dynamic> json) {
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
  String? shopId;
  String? shopName;
  String? email;
  String? businessType;
  String? country;
  String? phone;
  String? description;
  String? businessDays;
  String? businessHoursOpen;
  String? businessHoursClose;
  String? specialFeatures;
  String? photo;
  String? streetAddress1;
  String? streetAddress2;
  String? city;
  String? state;
  String? zipcode;
  String? locationName;
  String? lat;
  String? lng;
  String? rating;
  bool? open;
  List<ShopServices>? shopServices;
  List<ShopInterior>? shopInterior;
  List<ShopInterior>? shopExterior;
  List<ShopInterior>? shopWork;
  List<ShopStaffs>? shopStaffs;

  Data(
      {this.shopId,
        this.shopName,
        this.email,
        this.businessType,
        this.country,
        this.phone,
        this.description,
        this.businessDays,
        this.businessHoursOpen,
        this.businessHoursClose,
        this.specialFeatures,
        this.photo,
        this.streetAddress1,
        this.streetAddress2,
        this.city,
        this.state,
        this.zipcode,
        this.locationName,
        this.lat,
        this.lng,
        this.rating,
        this.open,
        this.shopServices,
        this.shopInterior,
        this.shopExterior,
        this.shopWork,
        this.shopStaffs});

  Data.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    email = json['email'];
    businessType = json['business_type'];
    country = json['country'];
    phone = json['phone'];
    description = json['description'];
    businessDays = json['business_days'];
    businessHoursOpen = json['business_hours_open'];
    businessHoursClose = json['business_hours_close'];
    specialFeatures = json['special_features'];
    photo = json['photo'];
    streetAddress1 = json['street_address1'];
    streetAddress2 = json['street_address2'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    locationName = json['location_name'];
    lat = json['lat'];
    lng = json['lng'];
    rating = json['rating'];
    open = json['open'];
    if (json['shop_services'] != null) {
      shopServices = <ShopServices>[];
      json['shop_services'].forEach((v) {
        shopServices!.add(new ShopServices.fromJson(v));
      });
    }
    if (json['shop_interior'] != null) {
      shopInterior = <ShopInterior>[];
      json['shop_interior'].forEach((v) {
        shopInterior!.add(new ShopInterior.fromJson(v));
      });
    }
    if (json['shop_exterior'] != null) {
      shopExterior = <ShopInterior>[];
      json['shop_exterior'].forEach((v) {
        shopExterior!.add(new ShopInterior.fromJson(v));
      });
    }
    if (json['shop_work'] != null) {
      shopWork = <ShopInterior>[];
      json['shop_work'].forEach((v) {
        shopWork!.add(new ShopInterior.fromJson(v));
      });
    }
    if (json['shop_staffs'] != null) {
      shopStaffs = <ShopStaffs>[];
      json['shop_staffs'].forEach((v) {
        shopStaffs!.add(new ShopStaffs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['shop_name'] = this.shopName;
    data['email'] = this.email;
    data['business_type'] = this.businessType;
    data['country'] = this.country;
    data['phone'] = this.phone;
    data['description'] = this.description;
    data['business_days'] = this.businessDays;
    data['business_hours_open'] = this.businessHoursOpen;
    data['business_hours_close'] = this.businessHoursClose;
    data['special_features'] = this.specialFeatures;
    data['photo'] = this.photo;
    data['street_address1'] = this.streetAddress1;
    data['street_address2'] = this.streetAddress2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipcode'] = this.zipcode;
    data['location_name'] = this.locationName;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['rating'] = this.rating;
    data['open'] = this.open;
    if (this.shopServices != null) {
      data['shop_services'] =
          this.shopServices!.map((v) => v.toJson()).toList();
    }
    if (this.shopInterior != null) {
      data['shop_interior'] =
          this.shopInterior!.map((v) => v.toJson()).toList();
    }
    if (this.shopExterior != null) {
      data['shop_exterior'] =
          this.shopExterior!.map((v) => v.toJson()).toList();
    }
    if (this.shopWork != null) {
      data['shop_work'] = this.shopWork!.map((v) => v.toJson()).toList();
    }
    if (this.shopStaffs != null) {
      data['shop_staffs'] = this.shopStaffs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShopServices {
  String? serviceId;
  String? serviceType;
  List<PackageService>? packageService;
  List<ServiceSpecialist>? serviceSpecialist;

  ShopServices(
      {this.serviceId,
        this.serviceType,
        this.packageService,
        this.serviceSpecialist});

  ShopServices.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceType = json['service_type'];
    if (json['package_service'] != null) {
      packageService = <PackageService>[];
      json['package_service'].forEach((v) {
        packageService!.add(new PackageService.fromJson(v));
      });
    }
    if (json['service_specialist'] != null) {
      serviceSpecialist = <ServiceSpecialist>[];
      json['service_specialist'].forEach((v) {
        serviceSpecialist!.add(new ServiceSpecialist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_type'] = this.serviceType;
    if (this.packageService != null) {
      data['package_service'] =
          this.packageService!.map((v) => v.toJson()).toList();
    }
    if (this.serviceSpecialist != null) {
      data['service_specialist'] =
          this.serviceSpecialist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PackageService {
  int? id;
  String? packageName;
  String? price;
  int? rating;
  String? photo;

  PackageService(
      {this.id, this.packageName, this.price, this.rating, this.photo});

  PackageService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageName = json['package_name'];
    price = json['price'];
    rating = json['rating'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['package_name'] = this.packageName;
    data['price'] = this.price;
    data['rating'] = this.rating;
    data['photo'] = this.photo;
    return data;
  }
}

class ServiceSpecialist {
  Specialist? specialist;

  ServiceSpecialist({this.specialist});

  ServiceSpecialist.fromJson(Map<String, dynamic> json) {
    specialist = json['specialist'] != null
        ? new Specialist.fromJson(json['specialist'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.specialist != null) {
      data['specialist'] = this.specialist!.toJson();
    }
    return data;
  }
}

class Specialist {
  String? staffId;
  User? user;
  String? staffName;
  String? photo;
  String? role;
  int? rating;

  Specialist(
      {this.staffId,
        this.user,
        this.staffName,
        this.photo,
        this.role,
        this.rating});

  Specialist.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    staffName = json['staff_name'];
    photo = json['photo'];
    role = json['role'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['staff_name'] = this.staffName;
    data['photo'] = this.photo;
    data['role'] = this.role;
    data['rating'] = this.rating;
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

class ShopInterior {
  String? photo;

  ShopInterior({this.photo});

  ShopInterior.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    return data;
  }
}

class ShopStaffs {
  String? staffId;
  String? userId;
  String? staffName;
  String? photo;
  String? role;
  int? rating;

  ShopStaffs(
      {this.staffId,
        this.userId,
        this.staffName,
        this.photo,
        this.role,
        this.rating});

  ShopStaffs.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    userId = json['user_id'];
    staffName = json['staff_name'];
    photo = json['photo'];
    role = json['role'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    data['user_id'] = this.userId;
    data['staff_name'] = this.staffName;
    data['photo'] = this.photo;
    data['role'] = this.role;
    data['rating'] = this.rating;
    return data;
  }
}
