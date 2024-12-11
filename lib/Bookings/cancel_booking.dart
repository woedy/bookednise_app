import 'dart:convert';
import 'dart:core';

import 'package:bookednise_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../HomeScreen/home_screen.dart';

class CancelBookings extends StatefulWidget {
  final booking_data;

  const CancelBookings({
    super.key,
    required this.booking_data,
  });

  @override
  State<CancelBookings> createState() => _CancelBookingsState();
}

class _CancelBookingsState extends State<CancelBookings> {
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
    print("widget.booking_data.slot");
    print(widget.booking_data.slot);
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
                                      image: NetworkImage(hostNameMedia +
                                          widget.booking_data.package.photo),
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
                                                  widget.booking_data.service
                                                      .serviceType,
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
                                                      widget.booking_data.shop
                                                          .locationName,
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
                                                if (widget.booking_data.shop
                                                    .open!) ...[
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
                                    widget.booking_data.package.price
                                        .toString(),
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
                            DateFormat('E')
                                .format(DateTime.parse(
                                    widget.booking_data.bookingDate))
                                .toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            DateTime.parse(widget.booking_data.bookingDate)
                                .day
                                .toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            DateFormat('MMM')
                                .format(DateTime.parse(
                                    widget.booking_data.bookingDate))
                                .toString()
                                .toUpperCase(),
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
                        height: 68,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: bookPrimary,
                            borderRadius: BorderRadius.circular(7)),
                        child: Center(
                          child: Text(
                            widget.booking_data.bookingTime,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap:
                      showCancelConfirmationDialog, // Show the confirmation dialog when tapped,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.red.withOpacity(0.8))),
                    child: Center(
                      child: Text(
                        "Cancel Appointment",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
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
                            height: 15,
                          ),
                          Container(
                            //height: 50,
                            child: Row(
                              children: [
                                for (int index = 0;
                                    index <
                                        widget.booking_data.bookedStaff.user
                                            .staffSlot.length;
                                    index++)
                                  if (widget.booking_data.bookedStaff.user
                                          .staffSlot[index].slotDate ==
                                      widget.booking_data.bookingDate)
                                    for (int timeIndex = 0;
                                        timeIndex <
                                            widget
                                                .booking_data
                                                .bookedStaff
                                                .user
                                                .staffSlot[index]
                                                .slotTimes
                                                .length;
                                        timeIndex++)
                                      if (widget
                                              .booking_data
                                              .bookedStaff
                                              .user
                                              .staffSlot[index]
                                              .slotTimes[timeIndex]
                                              .occupied ==
                                          true) ...[
                                        GestureDetector(
                                          onTap: () {
                                            /*     setState(() {
                                              _selectedTime = widget.booking_data.bookedStaff.user.staffSlot[index].slotTimes[timeIndex].time; // Update the selected time
                                            });*/
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            padding: EdgeInsets.all(5),
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: widget
                                                          .booking_data
                                                          .bookedStaff
                                                          .user
                                                          .staffSlot[index]
                                                          .slotTimes[timeIndex]
                                                          .time ==
                                                      _selectedTime
                                                  ? bookPrimary
                                                  : Colors
                                                      .red, // Highlight the selected time
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                widget
                                                    .booking_data
                                                    .bookedStaff
                                                    .user
                                                    .staffSlot[index]
                                                    .slotTimes[timeIndex]
                                                    .time
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedTime = widget
                                                  .booking_data
                                                  .bookedStaff
                                                  .user
                                                  .staffSlot[index]
                                                  .slotTimes[timeIndex]
                                                  .time; // Update the selected time
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            padding: EdgeInsets.all(5),
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: widget
                                                          .booking_data
                                                          .bookedStaff
                                                          .user
                                                          .staffSlot[index]
                                                          .slotTimes[timeIndex]
                                                          .time ==
                                                      _selectedTime
                                                  ? bookPrimary
                                                  : bookPrimary.withOpacity(
                                                      0.2), // Highlight the selected time
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                widget
                                                    .booking_data
                                                    .bookedStaff
                                                    .user
                                                    .staffSlot[index]
                                                    .slotTimes[timeIndex]
                                                    .time
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: bookWhite),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                              ],
                            ),
                          ),
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

/*
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(widget.booking_data.service.serviceType  + " Specialist", style: TextStyle(fontSize: 10,)),
                    ),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: widget.booking_data.service.serviceSpecialist.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedStaffId = widget.booking_data.service.serviceSpecialist[index].specialist.staffId;
                                _selectedStaffName = widget.booking_data.service.serviceSpecialist[index].specialist.staffName;
                                _selectedStaffPhoto = widget.booking_data.service.serviceSpecialist[index].specialist.photo;
                                _selectedStaffRole = widget.booking_data.service.serviceSpecialist[index].specialist.role;
                                _selectedAvailabilities = widget.booking_data.service.serviceSpecialist[index].specialist.user.staffSlot;
                              });

                              print(_selectedAvailabilities);
                            },
                            child: Container(
                              width: 200,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _selectedStaffId == widget.booking_data.service.serviceSpecialist[index].specialist.staffId ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                                border: _selectedStaffId == widget.booking_data.service.serviceSpecialist[index].specialist.staffId ? Border.all(color: Colors.blue, width: 2) : null, // Add border when selected
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: NetworkImage(hostNameMedia + widget.booking_data.service.serviceSpecialist[index].specialist.photo),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(widget.booking_data.service.serviceSpecialist[index].specialist.staffName, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
                                  Text(widget.booking_data.service.serviceSpecialist[index].specialist.role, style: TextStyle(fontSize: 10,),),
                                  Row(
                                    children: [
                                      Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                      Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                      Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                      Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                      Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
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
                ),*/
                InkWell(
                  onTap: () {
                    if (_selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please select a time to reschedule",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      var _data = {
                        "booking_id": widget.booking_data.bookingId,
                        "slot_id": widget.booking_data.slot,
                        "slot_time": _selectedTime,
                      };

                      print(_data);

                      showRescheduleDialog(_data);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: bookPrimary,
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                      child: Text(
                        "Reschedule Appointment",
                        style: TextStyle(color: Colors.white, fontSize: 12),
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
/*  @override
  Widget build22(BuildContext context) {
    return Scaffold(
      body: Container(
        //height: MediaQuery.of(context).size.height,
        child: SafeArea(
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
                              height: 250,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(hostNameMedia + widget.service_photo),
                                      fit: BoxFit.cover
                                  )
                              )

                          ),
                          Container(
                            height: 250,
                            decoration: BoxDecoration(

                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black],
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          onTap: (){
                                            Navigator.of(context).pop();
                                          },
                                          child: Icon(Icons.arrow_back, size: 35, color: Colors.white,)),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Text(
                                          widget.service_price,
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                      ),

                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(widget.service_name.toString(), style: TextStyle(color: Colors.white,fontSize: 48, fontWeight: FontWeight.w500, fontFamily: "Fontspring"),),


                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.location_on_outlined, size: 20, color: Colors.white,),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(child: Text(widget.shop_location.toString(), style: TextStyle(color: Colors.white,fontSize: 14,),)),

                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              if(widget.open)...[
                                                Container(
                                                    padding: EdgeInsets.all(2),
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child: Center(child: Text("Open", style: TextStyle(color: Colors.white,fontSize: 10,),))),
                                              ]else...[
                                                Container(
                                                    padding: EdgeInsets.all(2),
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child: Center(child: Text("Close", style: TextStyle(color: Colors.white,fontSize: 10,),))),
                                              ]

                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Icon(Icons.star_rounded, color: Colors.yellow, size: 40,),
                                          Text(widget.service_rating.toString(), style: TextStyle(color: Colors.white,fontSize: 20,),),

                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if(_selectedAvailabilities != null)...[

                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black
                          ),
                          padding: EdgeInsets.only(bottom: 20),
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
                              Text("Available Slots", style: TextStyle(fontSize: 10,),),
                            ],
                          ),
                          SizedBox(height: 15,),
                          if (_selectedAvailability != null) ...[
                            Container(
                              height: 50,
                              child: ListView.builder(
                                  itemCount: _selectedAvailability.slotTimes.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index){
                                    bool isSelected = _selectedTime == _selectedAvailability.slotTimes[index].time;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedTime = _selectedAvailability.slotTimes[index].time;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.all(10),
                                        height: 45,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: isSelected ? Colors.blue.withOpacity(0.7) : Colors.grey.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(_selectedAvailability.slotTimes[index].time.toString(), style: TextStyle(fontSize: 14),),
                                        ),
                                      ),
                                    );
                                  }
                              ),
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
                          SizedBox(width: 10,),

                          Text("Home Service", style: TextStyle(fontSize: 10,))
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
                      child: Text(widget.service_name  + " Specialist", style: TextStyle(fontSize: 10,)),
                    ),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: widget.staffs.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedStaffId = widget.staffs[index].specialist.staffId;
                                _selectedStaffName = widget.staffs[index].specialist.staffName;
                                _selectedStaffPhoto = widget.staffs[index].specialist.photo;
                                _selectedStaffRole = widget.staffs[index].specialist.role;
                                _selectedAvailabilities = widget.staffs[index].specialist.user.staffSlot;
                              });

                              print(_selectedAvailabilities);
                            },
                            child: Container(
                              width: 200,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _selectedStaffId == widget.staffs[index].specialist.staffId ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                                border: _selectedStaffId == widget.staffs[index].specialist.staffId ? Border.all(color: Colors.blue, width: 2) : null, // Add border when selected
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: NetworkImage(hostNameMedia + widget.staffs[index].specialist.photo),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(widget.staffs[index].specialist.staffName, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
                                  Text(widget.staffs[index].specialist.role, style: TextStyle(fontSize: 10,),),
                                  Row(
                                    children: [
                                      Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                      Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                      Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                      Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                      Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
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




                    if (_selectedAvailability == null){

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select a day to book",),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    else if (_selectedTime == null){

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select a time to book",),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    else if (_selectedStaffId == ""){

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select a prefared staff",),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }else {


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



                      Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsAppointment(

                        data: appointmentData,
                        service_name:widget.service_name,
                        service_rating: widget.service_rating,
                        shop_location: widget.shop_location,
                        shop_id: widget.shop_id,
                        open:widget.open,
                        service_price:widget.service_price,
                        service_id: widget.service_id,
                        package_id: widget.package_id,
                        service_photo: widget.service_photo,

                        the_month: DateFormat('MMM').format(DateTime.parse(_selectedAvailability.slotDate)).toString().toUpperCase(),
                        the_day: DateFormat('E').format(DateTime.parse(_selectedAvailability.slotDate)).toString(),
                        the_date: DateTime.parse(_selectedAvailability.slotDate).day.toString(),

                        staffs: widget.staffs,
                        staff_name: _selectedStaffName,
                        staff_photo: _selectedStaffPhoto,
                        staff_role: _selectedStaffRole,





                      )));

                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    height: 59,
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
                SizedBox(height: 45,)



              ],
            ),
          ),
        ),
      ),
    );
  }*/

  void cancelAppointment() async {
    // Make a request to your server's API endpoint

    var token = await getApiPref();
    var userId = await getUserIDPref();

    var response = await http.post(
      Uri.parse(hostName + "bookings/cancel-appointment/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Token ' + token.toString()
      },
      body: jsonEncode(<String, String>{
        'booking_id': widget.booking_data
            .bookingId, // Pass the appointment ID to identify the appointment
      }),
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Appointment cancelled successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment cancelled successfully'),
          backgroundColor: Colors.green,
        ),
      );
      // You may want to navigate back to the previous screen or update the UI
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Failed to cancel the appointment
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to cancel appointment'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void rescheduleAppointment(data) async {
    // Make a request to your server's API endpoint

    var token = await getApiPref();
    var userId = await getUserIDPref();

    var response = await http.post(
      Uri.parse(hostName + "bookings/reschedule-appointment/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Token ' + token.toString()
      },
      body: jsonEncode(<String, String>{
        'booking_id': data['booking_id'],
        'slot_id': data['slot_id'].toString(),
        'slot_time': data['slot_time']
      }),
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Appointment cancelled successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment rescheduled successfully'),
          backgroundColor: Colors.green,
        ),
      );
      // You may want to navigate back to the previous screen or update the UI
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Failed to cancel the appointment
      print(json.decode(response.body)['errors']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Booking for this date and time already exists."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showCancelConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancellation'),
          content: Text('Are you sure you want to cancel this appointment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                cancelAppointment(); // Call the cancelAppointment method
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void showRescheduleDialog(data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reschedule Appointment'),
          content:
              Text('Are you sure you want to reschedule this appointment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                rescheduleAppointment(
                    data); // Call the cancelAppointment method
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
