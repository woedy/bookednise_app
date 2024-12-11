import 'dart:convert';

import 'package:bookednise_app/Bookings/user_bookings.dart';
import 'package:bookednise_app/Components/generic_loading_dialogbox.dart';
import 'package:bookednise_app/HomeScreen/home_screen.dart';
import 'package:bookednise_app/Message/chat_screen.dart';
import 'package:bookednise_app/Profile/UserProfile.dart';
import 'package:bookednise_app/ShopView/models/list_shops_model.dart';
import 'package:bookednise_app/ShopView/shop_map.dart';
import 'package:bookednise_app/ShopView/shop_view_1.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<ListShopModel> get_shop_data() async {
  var token = await getApiPref();

  final response = await http.get(
    Uri.parse(hostName + "shop/list-shops/"),
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
    return ListShopModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return ListShopModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 403) {
    print(jsonDecode(response.body));
    return ListShopModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 400) {
    print(jsonDecode(response.body));
    return ListShopModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

class AllShopsScreen extends StatefulWidget {
  const AllShopsScreen({super.key});

  @override
  State<AllShopsScreen> createState() => _AllShopsScreenState();
}

class _AllShopsScreenState extends State<AllShopsScreen> {
  Future<ListShopModel>? _futureShopList;

  @override
  void initState() {
    _futureShopList = get_shop_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (_futureShopList == null) ? buildColumn() : buildFutureBuilder();
  }

  buildColumn() {
    return Scaffold(
      body: Container(),
    );
  }

  FutureBuilder<ListShopModel> buildFutureBuilder() {
    return FutureBuilder<ListShopModel>(
        future: _futureShopList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingDialogBox(
              text: 'Please Wait..',
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data!;

            var _shops = data.data!.shops;

            print("#########################");
            print(data.data!.shops);

            if (data.message == "Successful") {
              return Scaffold(
                body: SafeArea(
                  bottom: false,
                  top: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: bookPrimary.withOpacity(0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  //  color: bookPrimary,
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
                                          InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Icon(
                                                Icons.arrow_back,
                                                size: 20,
                                                color: bookPrimary,
                                              )),
                                          Text(
                                            "Shops",
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
                              if (_shops!.length == 0) ...[
                                Expanded(
                                    child: Container(
                                  child: Center(
                                    child: Text(
                                        "No Shops Available at the moment."),
                                  ),
                                ))
                              ] else ...[
                                Expanded(
                                    child: ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  itemCount: _shops!.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ShopViewScreen1(
                                                            shop_id:
                                                                _shops[index]
                                                                    .shopId)));
                                      },
                                      child: Column(
                                        children: [
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              ShopViewScreen1(
                                                                  shop_id: _shops[
                                                                          index]
                                                                      .shopId)));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.all(5),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 150,
                                                        //width: 200,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    hostNameMedia +
                                                                        _shops[index]
                                                                            .photo!
                                                                            .toString()),
                                                                fit: BoxFit
                                                                    .cover),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                      ),
                                                      Container(
                                                        height: 150,
                                                        //width: 200,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                              Colors
                                                                  .transparent,
                                                              bookPrimary
                                                            ],
                                                          ),
                                                        ),
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 50,
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                _shops[index].shopName!.toString(),
                                                                                style: TextStyle(color: Colors.white, height: 1, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: "Fontspring"),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              height: 30,
                                                                              child: ListView.builder(
                                                                                scrollDirection: Axis.horizontal,
                                                                                itemCount: _shops[index].shopServices!.length,
                                                                                itemBuilder: (context, index2) {
                                                                                  return Container(
                                                                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                                      margin: EdgeInsets.all(5),
                                                                                      decoration: BoxDecoration(color: bookPrimary, borderRadius: BorderRadius.circular(5)),
                                                                                      child: Text(
                                                                                        _shops[index].shopServices![index2].serviceType!,
                                                                                        style: TextStyle(fontSize: 8, color: Colors.white),
                                                                                      ));
                                                                                },
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.location_on,
                                                                                      color: Colors.white,
                                                                                      size: 15,
                                                                                    ),
                                                                                    Text(
                                                                                      _shops[index].locationName!.toString(),
                                                                                      style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: "Fontspring"),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Container(
                                                                                  width: 50,
                                                                                  padding: EdgeInsets.all(2),
                                                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "134 km",
                                                                                      style: TextStyle(color: Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: "Fontspring"),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ))
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
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
}
