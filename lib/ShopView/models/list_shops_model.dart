class ListShopModel {
  String? message;
  Data? data;

  ListShopModel({this.message, this.data});

  ListShopModel.fromJson(Map<String, dynamic> json) {
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
  List<Shops>? shops;

  Data({this.shops});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['shops'] != null) {
      shops = <Shops>[];
      json['shops'].forEach((v) {
        shops!.add(new Shops.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shops != null) {
      data['shops'] = this.shops!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shops {
  String? shopId;
  String? shopName;
  String? photo;
  String? locationName;
  List<ShopServices>? shopServices;

  Shops(
      {this.shopId,
        this.shopName,
        this.photo,
        this.locationName,
        this.shopServices});

  Shops.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    photo = json['photo'];
    locationName = json['location_name'];
    if (json['shop_services'] != null) {
      shopServices = <ShopServices>[];
      json['shop_services'].forEach((v) {
        shopServices!.add(new ShopServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['shop_name'] = this.shopName;
    data['photo'] = this.photo;
    data['location_name'] = this.locationName;
    if (this.shopServices != null) {
      data['shop_services'] =
          this.shopServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShopServices {
  String? serviceType;

  ShopServices({this.serviceType});

  ShopServices.fromJson(Map<String, dynamic> json) {
    serviceType = json['service_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_type'] = this.serviceType;
    return data;
  }
}
