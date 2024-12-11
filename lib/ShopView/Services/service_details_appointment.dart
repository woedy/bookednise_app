import 'dart:convert';

import 'package:bookednise_app/Components/generic_error_dialog_box.dart';
import 'package:bookednise_app/Components/generic_loading_dialogbox.dart';
import 'package:bookednise_app/Components/generic_success_dialog_box.dart';
import 'package:bookednise_app/Components/keyboard_utils.dart';
import 'package:bookednise_app/HomeScreen/home_screen.dart';
import 'package:bookednise_app/PayStack/booking_paayment.dart';
import 'package:bookednise_app/ShopView/Services/service_details.dart';
import 'package:bookednise_app/ShopView/models/booking_model.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<BookingModel> bookAppointment(data) async {
  var token = await getApiPref();
  var userId = await getUserIDPref();

  final response = await http.post(
    Uri.parse(hostName + "bookings/book-appointment/"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Token ' + token.toString()
    },
    body: jsonEncode({
      "user_id": userId.toString(),
      "shop_id": data["shop_id"],
      "service_id": data["service_id"],
      "staff_id": data["staff_id"],
      "package_id": data["package_id"],
      "slot_id": data["slot_id"],
      "slot_time": data["slot_time"],
      "home_service": data["home_service"],
      "notes": data["notes"],
    }),
  );

  try {
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(jsonDecode(response.body));
      final result = json.decode(response.body);

      print("############");
      print("WE ARE INNNNNNNN");
      print(result);

      return BookingModel.fromJson(result);
    } else if (response.statusCode == 422 ||
        response.statusCode == 403 ||
        response.statusCode == 400 ||
        response.statusCode == 404) {
      print(jsonDecode(response.body));
      final result = json.decode(response.body);

      print("############");
      print("ERRORRRRRR");
      print(result);

      return BookingModel.fromJson(result);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to load data');
  }
}

class ServiceDetailsAppointment extends StatefulWidget {
  final data;
  final service_name;
  final service_rating;
  final shop_location;
  final shop_id;
  final open;
  final service_price;
  final service_id;
  final package_id;
  final service_photo;
  final staffs;
  final staff_name;
  final staff_role;
  final staff_photo;

  final the_month;
  final the_day;
  final the_date;

  const ServiceDetailsAppointment({
    super.key,
    required this.data,
    required this.service_name,
    required this.service_rating,
    required this.shop_location,
    required this.shop_id,
    required this.open,
    required this.service_price,
    required this.service_id,
    required this.package_id,
    required this.service_photo,
    required this.the_month,
    required this.the_day,
    required this.the_date,
    required this.staffs,
    required this.staff_name,
    required this.staff_role,
    required this.staff_photo,
  });

  @override
  State<ServiceDetailsAppointment> createState() =>
      _ServiceDetailsAppointmentState();
}

class _ServiceDetailsAppointmentState extends State<ServiceDetailsAppointment> {
  final _formKey = GlobalKey<FormState>();

  Future<BookingModel>? _futureBooking;

  String note = "";

  @override
  Widget build(BuildContext context) {
    return (_futureBooking == null) ? buildColumn() : buildFutureBuilder();
  }

  buildColumn() {
    return Scaffold(
      body: Container(
        //height: MediaQuery.of(context).size.height,
        child: SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.red,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          hostNameMedia + widget.service_photo),
                                      fit: BoxFit.cover))),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, bookPrimary],
                              ),
                            ),
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: 70, left: 5, right: 5),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.service_name,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Fontspring"),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 20,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      widget.shop_location,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                if (widget.open!) ...[
                                                  Container(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Center(
                                                          child: Text(
                                                        "Open",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ))),
                                                ] else ...[
                                                  Container(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Center(
                                                          child: Text(
                                                        "Closed",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ))),
                                                ]
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 40),
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.arrow_back,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    )),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    widget.service_price.toString(),
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Column(
                      children: [
                        Container(
                          //width: 200,
                          height: 200,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: bookPrimary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  //height: 70,
                                  decoration: BoxDecoration(
                                      //color: Colors.red,
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image: NetworkImage(hostNameMedia +
                                              widget.staff_photo),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.staff_name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        widget.staff_role,
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            size: 15,
                                            color: Colors.yellow,
                                          ),
                                          Icon(
                                            Icons.star_rounded,
                                            size: 15,
                                            color: Colors.yellow,
                                          ),
                                          Icon(
                                            Icons.star_rounded,
                                            size: 15,
                                            color: Colors.yellow,
                                          ),
                                          Icon(
                                            Icons.star_rounded,
                                            size: 15,
                                            color: Colors.yellow,
                                          ),
                                          Icon(
                                            Icons.star_rounded,
                                            size: 15,
                                            color: Colors.yellow,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      widget.service_price,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      width: 60,
                      margin: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          color: bookPrimary,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          Text(
                            widget.the_day.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            widget.the_date,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            widget.the_month,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(10),
                        height: 73,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: bookPrimary,
                            borderRadius: BorderRadius.circular(7)),
                        child: Center(
                          child: Text(
                            widget.data['slot_time'],
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.1))),
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        //hintText: 'Enter Username/Email',

                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        labelText: "Add Note",
                        labelStyle: TextStyle(
                            fontSize: 13, color: Colors.black.withOpacity(0.5)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        border: InputBorder.none,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(225),
                        PasteTextInputFormatter(),
                      ],
                      /* validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                  */
                      maxLines: 4,
                      textInputAction: TextInputAction.next,
                      autofocus: false,
                      onSaved: (value) {
                        setState(() {
                          note = value!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      KeyboardUtil.hideKeyboard(context);

                      //Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmail()));

                      widget.data['notes'] = note;
                      widget.data['shop_id'] = widget.shop_id;

                      var email = await getEmailPref();

                      print("################ widget.data");
                      print(widget.data);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingPaymentPage(
                                    amount: widget.service_price.toString(),
                                    booking_data: widget.data,
                                    email: email,
                                  )));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    //height: 59,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: bookPrimary,
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                      child: Text(
                        "Make Payment",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 45,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<BookingModel> buildFutureBuilder() {
    return FutureBuilder<BookingModel>(
        future: _futureBooking,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingDialogBox(
              text: 'Please Wait..',
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data!;

            print("#########################");
            //print(data.data!.token!);

            if (data.message == "Appointment added successfully") {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );

                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      // Show the dialog
                      return SuccessDialogBox(text: "Booking Successful");
                    });
              });
            } else if (data.message == "Errors") {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetails(
                      service_id: widget.service_id,
                      service_name: widget.service_name,
                      service_rating: widget.service_rating,
                      shop_location: widget.shop_location,
                      shop_id: widget.shop_id,
                      package_id: widget.package_id,
                      open: widget.open,
                      service_price: widget.service_price,
                      service_photo: widget.service_photo,
                      staffs: widget.staffs,
                    ),
                  ),
                );

                // Extract error messages
                List<String> errorMessages = [];
                if (data.errors != null) {
                  data.errors!.forEach((key, value) {
                    errorMessages.addAll(value);
                  });
                }

                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialogBox(text: errorMessages[0].toString());
                  },
                );
              });
            }
          }

          return LoadingDialogBox(
            text: 'Please Wait..',
          );
        });
  }

  void dispose() {
    super.dispose();
  }
}
