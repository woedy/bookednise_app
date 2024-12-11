import 'dart:convert';
import 'dart:core';

import 'package:bookednise_app/ShopView/Services/service_details_appointment.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ServiceDetails extends StatefulWidget {
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

  const ServiceDetails({
    super.key,
    required this.service_name,
    required this.service_rating,
    required this.shop_location,
    required this.open,
    required this.service_price,
    required this.service_id,
    required this.package_id,
    required this.service_photo,
    required this.staffs,
    required this.shop_id,
  });

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  bool home_service = false; // Flag to control month picker visibility
  String? _selectedTime;

  String _selectedStaffId = "";
  String _selectedStaffPhoto = "";
  String _selectedStaffName = "";
  String _selectedStaffRole = "";
  var _selectedAvailabilities;
  var _selectedAvailability;

  @override
  void initState() {
    super.initState();

    if (widget.staffs.length != 0) {
      _selectedStaffId = widget.staffs[0].specialist.staffId;
      _selectedStaffName = widget.staffs[0].specialist.staffName;
      _selectedStaffPhoto = widget.staffs[0].specialist.photo;
      _selectedStaffRole = widget.staffs[0].specialist.role;
      _selectedAvailabilities = widget.staffs[0].specialist.user.staffSlot;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.black,
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
                      if (_selectedAvailabilities != null) ...[
                        Container(
                          decoration: BoxDecoration(color: bookPrimary),
                          //padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    _buildAvailability(_selectedAvailabilities),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Available Slots",
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_selectedAvailability != null) ...[
                            Container(
                              height: 35,
                              //color: Colors.blueGrey,
                              child: ListView.builder(
                                  itemCount:
                                      _selectedAvailability.slotTimes.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    bool isSelected = _selectedTime ==
                                        _selectedAvailability
                                            .slotTimes[index].time;
                                    if (_selectedAvailability
                                            .slotTimes[index].occupied ==
                                        true) {
                                      return GestureDetector(
                                        onTap: () {
                                          /*         setState(() {
                                              _selectedTime = _selectedAvailability.slotTimes[index].time;
                                            });*/
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          padding: EdgeInsets.all(5),
                                          //height: 45,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? bookPrimary
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _selectedAvailability
                                                  .slotTimes[index].time
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedTime =
                                                _selectedAvailability
                                                    .slotTimes[index].time;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          padding: EdgeInsets.all(5),
                                          // height: 45,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? bookPrimary
                                                : bookPrimary.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _selectedAvailability
                                                  .slotTimes[index].time
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            )
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          CupertinoSwitch(
                              value: home_service,
                              onChanged: (value) {
                                setState(() {
                                  home_service = value;
                                });
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Home Service",
                              style: TextStyle(
                                fontSize: 10,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(widget.service_name + " Specialist",
                          style: TextStyle(
                            fontSize: 12,
                          )),
                    ),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: widget.staffs.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedStaffId =
                                    widget.staffs[index].specialist.staffId;
                                _selectedStaffName =
                                    widget.staffs[index].specialist.staffName;
                                _selectedStaffPhoto =
                                    widget.staffs[index].specialist.photo;
                                _selectedStaffRole =
                                    widget.staffs[index].specialist.role;
                                _selectedAvailabilities = widget
                                    .staffs[index].specialist.user.staffSlot;
                              });

                              print(_selectedAvailabilities);
                            },
                            child: Container(
                              width: 200,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _selectedStaffId ==
                                        widget.staffs[index].specialist.staffId
                                    ? Colors.green
                                    : bookPrimary,
                                borderRadius: BorderRadius.circular(15),
                                border: _selectedStaffId ==
                                        widget.staffs[index].specialist.staffId
                                    ? Border.all(color: Colors.green, width: 2)
                                    : null, // Add border when selected
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: NetworkImage(hostNameMedia +
                                              widget.staffs[index].specialist
                                                  .photo),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    widget.staffs[index].specialist.staffName,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    widget.staffs[index].specialist.role,
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    if (_selectedAvailability == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please select a day to book",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (_selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please select a time to book",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (_selectedStaffId == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please select a prefared staff",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      Map<String, dynamic> appointmentData = {
                        "service_id": widget.service_id,
                        "slot_id": _selectedAvailability.id,
                        "slot_time": _selectedTime,
                        "home_service": home_service,
                        "staff_id": _selectedStaffId,
                        "package_id": widget.package_id,
                      };
                      String jsonData = jsonEncode(appointmentData);

                      print(appointmentData);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ServiceDetailsAppointment(
                                    data: appointmentData,
                                    service_name: widget.service_name,
                                    service_rating: widget.service_rating,
                                    shop_location: widget.shop_location,
                                    shop_id: widget.shop_id,
                                    open: widget.open,
                                    service_price: widget.service_price,
                                    service_id: widget.service_id,
                                    package_id: widget.package_id,
                                    service_photo: widget.service_photo,
                                    the_month: DateFormat('MMM')
                                        .format(DateTime.parse(
                                            _selectedAvailability.slotDate))
                                        .toString()
                                        .toUpperCase(),
                                    the_day: DateFormat('E')
                                        .format(DateTime.parse(
                                            _selectedAvailability.slotDate))
                                        .toString(),
                                    the_date: DateTime.parse(
                                            _selectedAvailability.slotDate)
                                        .day
                                        .toString(),
                                    staffs: widget.staffs,
                                    staff_name: _selectedStaffName,
                                    staff_photo: _selectedStaffPhoto,
                                    staff_role: _selectedStaffRole,
                                  )));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    // height: 59,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: bookPrimary,
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                      child: Text(
                        "Book Appointment",
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

  Widget _buildAvailability(availability) {
    return Container(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availability.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedAvailability == availability[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedAvailability = availability[index];
              });
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(6),
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: isSelected ? Colors.white : Colors.transparent,
                border:
                    Border.all(color: Colors.white), // Add border for clarity
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('E')
                        .format(DateTime.parse(availability[index].slotDate))
                        .toString(),
                    style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2),
                  Text(
                    DateTime.parse(availability[index].slotDate).day.toString(),
                    style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2),
                  Text(
                    DateFormat('MMM')
                        .format(DateTime.parse(availability[index].slotDate))
                        .toString()
                        .toUpperCase(),
                    style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
