class UserProfileModel {
  String? message;
  Data? data;

  UserProfileModel({this.message, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? email;
  String? fullName;
  String? phone;
  String? country;
  String? photo;

  Data(
      {this.userId,
        this.email,
        this.fullName,
        this.phone,
        this.country,
        this.photo});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    email = json['email'];
    fullName = json['full_name'];
    phone = json['phone'];
    country = json['country'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['country'] = this.country;
    data['photo'] = this.photo;
    return data;
  }
}
