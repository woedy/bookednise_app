import 'dart:ui';

import 'package:bookednise_app/Bookings/user_bookings.dart';
import 'package:bookednise_app/Components/sho_dialog.dart';
import 'package:bookednise_app/HomeScreen/home_screen.dart';
import 'package:bookednise_app/Message/chat_page.dart';
import 'package:bookednise_app/Message/messages.dart';
import 'package:bookednise_app/Profile/UserProfile.dart';
import 'package:bookednise_app/ShopView/shop_map.dart';
import 'package:bookednise_app/ShopView/shops_screen.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<dynamic> chatData = [];

  @override
  void initState() {
    super.initState();
    fetchChatData();
  }

  Future<void> fetchChatData() async {
    var token = await getApiPref();
    var user_id = await getUserIDPref();

    final url = hostName +
        'bookings/get-client-bookings-chats/?user_id=$user_id&search';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Token ' + token.toString(),
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          chatData = data['data'];
        });
      } else {
        throw Exception('Failed to load chats');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          bottom: false,
          top: false,
          child: Stack(
            children: [
              Column(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Chats",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: bookPrimary),
                              ),
                              Icon(
                                Icons.search,
                                size: 20,
                                color: bookPrimary,
                              ),
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
                    margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chat List
                        Expanded(
                          child: chatData.isEmpty
                              ? Center(child: Text('No Chats available'))
                              : ListView.builder(
                                  itemCount: chatData.length,
                                  padding: EdgeInsets.all(5),
                                  itemBuilder: (context, index) {
                                    var chatItem = chatData[index];
                                    var shopName = chatItem['shop']['shop_user']
                                        ['shop_name'];
                                    var shopPhoto =
                                        chatItem['shop']['shop_user']['photo'];

                                    var booking_id = chatItem['room_id'];

                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    ChatPage(
                                                        booking_id: booking_id,
                                                        shop_name: shopName)));
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 30,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                hostNameMedia +
                                                                    shopPhoto
                                                                        .toString()), // Replace with actual host name
                                                      ),
                                                      SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          shopName,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                "Fontspring",
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_right,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                            Divider()
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
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
                        onTap: () {},
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  "assets/icons/message.png",
                                  height: 20,
                                  color: bookPrimary,
                                ),
                                Text('Messages',
                                    style: TextStyle(
                                        fontSize: 9, color: bookPrimary))
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
