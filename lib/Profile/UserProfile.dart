import 'dart:convert';
import 'dart:ui';

import 'package:bookednise_app/Authentication/Login/login_screen.dart';
import 'package:bookednise_app/Bookings/user_bookings.dart';
import 'package:bookednise_app/Components/generic_loading_dialogbox.dart';
import 'package:bookednise_app/Components/sho_dialog.dart';
import 'package:bookednise_app/Profile/edit_profile.dart';
import 'package:bookednise_app/ShopView/shop_map.dart';
import 'package:bookednise_app/ShopView/shops_screen.dart';
import 'package:bookednise_app/HomeScreen/home_screen.dart';
import 'package:bookednise_app/Message/chat_screen.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../BankAccount/bank_account.dart';
import '../Bookings/cancel_booking.dart';
import 'models/user_profile_detail_models.dart';

Future<UserProfileDetailModel> get_user_profile() async {
  var token = await getApiPref();
  var user_id = await getUserIDPref();

  final response = await http.get(
    Uri.parse(hostName +
        "user-profile/display-user-profile/?user_id=" +
        user_id.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Token ' + token.toString()
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print(jsonDecode(response.body));
    final result = json.decode(response.body);

    return UserProfileDetailModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return UserProfileDetailModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 403) {
    print(jsonDecode(response.body));
    return UserProfileDetailModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 400) {
    print(jsonDecode(response.body));
    return UserProfileDetailModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic> userData = {};

  Future<UserProfileDetailModel>? _futureUserDetails;

  @override
  void initState() {
    super.initState();
    // Retrieve data from SharedPreferences
    _futureUserDetails = get_user_profile();
  }

  @override
  Widget build(BuildContext context) {
    return (_futureUserDetails == null) ? buildColumn() : buildFutureBuilder();
  }

  buildColumn() {
    return Scaffold(
      body: Container(),
    );
  }

  FutureBuilder<UserProfileDetailModel> buildFutureBuilder() {
    return FutureBuilder<UserProfileDetailModel>(
        future: _futureUserDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingDialogBox(
              text: 'Please Wait..',
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data!;
            var userData = data.data!.userData;
            var bookings = data.data!.bookings;

            if (data.message == "Successful") {
              return Scaffold(
                body: Container(
                  child: SafeArea(
                    bottom: false,
                    top: false,
                    child: Stack(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: bookPrimary,
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
                                            "Profile",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProfile(
                                                              userData:
                                                                  userData)));
                                            },
                                            child: Icon(
                                              Icons.edit_square,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 100.0,
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors
                                                    .white, // First stroke color
                                                width:
                                                    5.0, // First stroke width
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: Image.network(
                                                hostNameMedia +
                                                    userData!.photo.toString(),
                                                width: 130.0,
                                                height: 130.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    userData.fullName
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "Fontspring"),
                                                  ),
                                                  Text(
                                                    userData.email.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        //fontWeight: FontWeight.w500,
                                                        fontFamily:
                                                            "Fontspring"),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              Row(
                                                children: [
                                                  Text(
                                                    userData.bookingsCount
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Bookings Made",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BankAccount()));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.green),
                                                      child: Center(
                                                        child: Text(
                                                          "Transactions",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 5, right: 5, top: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                clearApiKey();

                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginScreen()),
                                                  (route) => false,
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                //margin: EdgeInsets.all(10),
                                                //height: 30,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: bookPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                                child: Center(
                                                  child: Text(
                                                    "Log out",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      if (bookings!.length == 0) ...[
                                        Container(
                                          height: 250,
                                          child: Center(
                                              child: Text(
                                                  "No Bookings Available.")),
                                        ),
                                      ] else ...[
                                        Container(
                                          height: 320,
                                          // color: Colors.blue,
                                          child: ListView.builder(
                                              padding: EdgeInsets.all(0),
                                              itemCount: bookings!.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Column(
                                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      radius:
                                                                          30,
                                                                      backgroundImage: NetworkImage(hostNameMedia +
                                                                          bookings[index]
                                                                              .shop!
                                                                              .photo
                                                                              .toString()),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          bookings[index]
                                                                              .shop!
                                                                              .shopName!
                                                                              .toString(),
                                                                          maxLines:
                                                                              1, // Limit the title to 1 line
                                                                          overflow:
                                                                              TextOverflow.ellipsis, // Use ellipsis for overflow
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontFamily: "Fontspring"),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              2,
                                                                        ),
                                                                        Center(
                                                                            child:
                                                                                Text(
                                                                          bookings[index]
                                                                              .package!
                                                                              .price!
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: const Color.fromARGB(255, 8, 163, 13)),
                                                                        )),
                                                                        SizedBox(
                                                                          height:
                                                                              2,
                                                                        ),
                                                                        Container(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 15,
                                                                              vertical: 3),
                                                                          decoration: BoxDecoration(
                                                                              color: bookPrimary,
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child: Text(
                                                                              bookings[index].service!.serviceType!,
                                                                              style: TextStyle(fontSize: 12, color: Colors.white)),
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
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      bookPrimary,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Center(
                                                                        child: Text(
                                                                      bookings[
                                                                              index]
                                                                          .bookingDate!,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                                  ),
                                                                  Expanded(
                                                                    child: Center(
                                                                        child: Text(
                                                                      bookings[
                                                                              index]
                                                                          .bookingTime!,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.white),
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
                                                );
                                              }),
                                        ),
                                      ],
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _showDeleteAccountModal(context);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              //margin: EdgeInsets.all(10),
                                              //height: 50,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Colors.red
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              child: Center(
                                                child: Text(
                                                  "Delete Account",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ),
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

  void _showDeleteAccountModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Are you sure you want to remove your account from Bookelu?",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.red),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Caution..! This action is irreversible. "),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _showDeleteAccountModal(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              //margin: EdgeInsets.all(10),
                              //height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Center(
                                child: Text(
                                  "Delete Account",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _showDeleteAccountModal(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              //margin: EdgeInsets.all(10),
                              //height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Center(
                                child: Text(
                                  "No",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
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
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UserBookings()),
                          );
                        },
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  "assets/icons/card.png",
                                  height: 20,
                                  color: Colors.white,
                                ),
                                Text('Bookings',
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.white))
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
                        onTap: () {},
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  "assets/icons/person.png",
                                  height: 20,
                                  color: bookPrimary,
                                ),
                                Text('Profile',
                                    style: TextStyle(
                                        fontSize: 9, color: bookPrimary))
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

  Future<void> clearApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("API_Key");
    await prefs.remove("user_data");
  }
}
