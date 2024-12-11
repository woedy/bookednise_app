class BookingModel {
  String? message;
  Data? data;
  Map<String, List<String>>? errors;

  BookingModel({this.message, this.data, this.errors});

  BookingModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['errors'] != null) {
      errors = {};
      json['errors'].forEach((key, value) {
        errors![key] = List<String>.from(value);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (errors != null) {
      data['errors'] = errors!.map((key, value) => MapEntry(key, value));
    }
    return data;
  }
}

class Data {
  String? bookingId;

  Data({this.bookingId});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['booking_id'] = bookingId;
    return data;
  }
}
