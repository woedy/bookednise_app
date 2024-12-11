import 'dart:convert';
import 'dart:ui';

import 'package:bookednise_app/Bookings/cancel_booking.dart';
import 'package:bookednise_app/Bookings/models/user_bookings_model.dart';
import 'package:bookednise_app/Components/generic_loading_dialogbox.dart';
import 'package:bookednise_app/Components/sho_dialog.dart';
import 'package:bookednise_app/ShopView/shop_map.dart';
import 'package:bookednise_app/ShopView/shops_screen.dart';
import 'package:bookednise_app/HomeScreen/home_screen.dart';
import 'package:bookednise_app/Message/chat_screen.dart';
import 'package:bookednise_app/Profile/UserProfile.dart';
import 'package:bookednise_app/constants.dart';
import 'package:bookednise_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

Future<ListUserBookingsModel> get_bookings_data() async {
  var token = await getApiPref();
  var user_id = await getUserIDPref();

  final response = await http.get(
    Uri.parse(
        hostName + "bookings/client-bookings/?user_id=" + user_id.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Token ' + token.toString()
    },
  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    final result = json.decode(response.body);
    if (result != null) {}
    return ListUserBookingsModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return ListUserBookingsModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 403) {
    print(jsonDecode(response.body));
    return ListUserBookingsModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 400) {
    print(jsonDecode(response.body));
    return ListUserBookingsModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

class UserBookings extends StatefulWidget {
  const UserBookings({super.key});

  @override
  State<UserBookings> createState() => _UserBookingsState();
}

class _UserBookingsState extends State<UserBookings> {
  PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  Future<ListUserBookingsModel>? _futureBookingList;

  @override
  void initState() {
    _futureBookingList = get_bookings_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (_futureBookingList == null) ? buildColumn() : buildFutureBuilder();
  }

  buildColumn() {
    return Scaffold(
      body: Container(),
    );
  }

  FutureBuilder<ListUserBookingsModel> buildFutureBuilder() {
    return FutureBuilder<ListUserBookingsModel>(
        future: _futureBookingList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingDialogBox(
              text: 'Please Wait..',
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data!;

            //var _all_bookings = data.data!.allBookings;
            //var _upcoming_booking = data.data!.upcoming;
            //var _history_booking = data.data!.history;

            var _upcoming_booking = data.data!.upcoming!;
            var _history_booking = data.data!.history!;

            print("###########################333");
            print(data.data!.history!.length);

            if (data.message == "Successful") {
              return Scaffold(
                body: Container(
                  color: bookPrimary.withOpacity(0.1),
                  child: SafeArea(
                    top: false,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                //color: bookPrimary,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(7),
                                  bottomLeft: Radius.circular(7),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Bookings",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: bookPrimary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        //color: bookPrimary,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        buildNavItem("Upcoming", 0),
                                        buildNavItem("History", 1),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              margin:
                                  EdgeInsets.only(left: 0, right: 0, top: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: PageView(
                                            controller: _pageController,
                                            onPageChanged: (int page) {
                                              setState(() {
                                                currentPage = page;
                                              });
                                            },
                                            children: [
                                              _upcoming(_upcoming_booking),
                                              _history(_history_booking)
                                              // Add more pages as needed
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                          ],
                        ),
                        customNavBar(context)
                      ],
                    ),
                  ),
                ),
              );
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

  Widget _upcoming(_upcoming_booking) {
    if (_upcoming_booking.length == 0) {
      return Container(
        child: Center(
          child: Text("No Upcoming Bookings"),
        ),
      );
    }
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(5),
        itemCount: _upcoming_booking.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              print(_upcoming_booking[index].shop);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CancelBookings(
                        booking_data: _upcoming_booking[index],
                      )));
            },
            child: Column(
              children: [
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(hostNameMedia +
                                      _upcoming_booking[index].shop.photo),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _upcoming_booking[index].shop.shopName,
                                      maxLines: 1, // Limit the title to 1 line
                                      overflow: TextOverflow
                                          .ellipsis, // Use ellipsis for overflow
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Fontspring"),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Center(
                                        child: Text(
                                      _upcoming_booking[index]
                                          .package
                                          .price
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 8, 163, 13)),
                                    )),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 3),
                                      decoration: BoxDecoration(
                                          color: bookPrimary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                          _upcoming_booking[index]
                                              .service
                                              .serviceType,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: bookPrimary,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                    child: Text(
                                  _upcoming_booking[index].bookingDate,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                )),
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(
                                  _upcoming_booking[index].bookingTime,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                )),
                              ),
                            ],
                          )),
                    ),
                    /*    Icon(Icons.arrow_forward_rounded),
                    Container(
                        width: 150,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: bookPrimary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(child: Text("7 : 50 am", style: TextStyle(fontSize: 16,),))),*/
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _history(_history_booking) {
    if (_history_booking.length == 0) {
      return Container(
        child: Center(
          child: Text("No History Available"),
        ),
      );
    }

    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(5),
        itemCount: _history_booking.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              print(_history_booking[index].shop);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CancelBookings(
                        booking_data: _history_booking[index],
                      )));
            },
            child: Column(
              children: [
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(hostNameMedia +
                                      _history_booking[index].shop.photo),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _history_booking[index].shop.shopName,
                                      maxLines: 1, // Limit the title to 1 line
                                      overflow: TextOverflow
                                          .ellipsis, // Use ellipsis for overflow
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Fontspring"),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Center(
                                        child: Text(
                                      _history_booking[index]
                                          .package
                                          .price
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 8, 163, 13)),
                                    )),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 3),
                                      decoration: BoxDecoration(
                                          color: bookPrimary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                          _history_booking[index]
                                              .service
                                              .serviceType,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: bookPrimary,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                    child: Text(
                                  _history_booking[index].bookingDate,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                )),
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(
                                  _history_booking[index].bookingTime,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                )),
                              ),
                            ],
                          )),
                    ),
                    /*    Icon(Icons.arrow_forward_rounded),
                    Container(
                        width: 150,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: bookPrimary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(child: Text("7 : 50 am", style: TextStyle(fontSize: 16,),))),*/
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildNavItem(String title, int pageIndex) {
    bool isSelected = currentPage == pageIndex;

    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          pageIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: EdgeInsets.all(5),
        width: 120,
        decoration: BoxDecoration(
          color: isSelected ? bookPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Positioned customNavBar(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 13),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bookPrimary, Colors.transparent], // Blue gradient effect
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          /*           boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ], */
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ), // Match the container's border radius
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 2.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors
                        .transparent, // Use transparent to let the gradient show
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                      0.2), // Slightly transparent white background
                ),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomeScreen()),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/home.png",
                              height: 20,
                              color: Colors
                                  .white, // Change color to contrast with blue
                            ),
                            Text('Home',
                                style:
                                    TextStyle(fontSize: 9, color: Colors.white))
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  "assets/icons/card.png",
                                  height: 20,
                                  color: bookPrimary,
                                ),
                                Text('Bookings',
                                    style: TextStyle(
                                        fontSize: 9, color: bookPrimary))
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ShopMap();
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Icon(Icons.explore, color: Colors.white),
                                Text('Explore',
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.white))
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ChatScreen()),
                          );
                        },
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  "assets/icons/message.png",
                                  height: 20,
                                  color: Colors.white,
                                ),
                                Text('Messages',
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.white))
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UserProfile()),
                          );
                        },
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  "assets/icons/person.png",
                                  height: 20,
                                  color: Colors.white,
                                ),
                                Text('Profile',
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.white))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
