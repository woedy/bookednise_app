import 'dart:convert';

import 'package:bookednise_app/Bookings/user_bookings.dart';
import 'package:bookednise_app/Components/generic_loading_dialogbox.dart';
import 'package:bookednise_app/Components/sho_dialog.dart';
import 'package:bookednise_app/ShopView/models/shop_model.dart';
import 'package:bookednise_app/ShopView/shops_screen.dart';
import 'package:bookednise_app/HomeScreen/home_screen.dart';
import 'package:bookednise_app/Message/chat_screen.dart';
import 'package:bookednise_app/Profile/UserProfile.dart';
import 'package:bookednise_app/ShopView/Services/service_details.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<ShopModel> get_shop_detail(shop_id) async {
  var token = await getApiPref();
  var user_id = await getUserIDPref();

  var theurl = hostName +
      "shop/shop-details/?shop_id=" +
      shop_id.toString() +
      "&user_id=" +
      user_id.toString();
  print("theurltheurltheurltheurl");
  print(theurl);

  final response = await http.get(
    Uri.parse(hostName +
        "shop/shop-details/?shop_id=" +
        shop_id.toString() +
        "&user_id=" +
        user_id.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Token ' + token.toString()
    },
  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    final result = json.decode(response.body);

    return ShopModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return ShopModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 403) {
    print(jsonDecode(response.body));
    return ShopModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 400) {
    print(jsonDecode(response.body));
    return ShopModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

class ShopViewScreen1 extends StatefulWidget {
  final shop_id;
  const ShopViewScreen1({super.key, required this.shop_id});

  @override
  State<ShopViewScreen1> createState() => _ShopViewScreen1State();
}

class _ShopViewScreen1State extends State<ShopViewScreen1> {
  PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  var _packages = [];

  Future<ShopModel>? _futureShopDetail;

  @override
  void initState() {
    print(widget.shop_id);
    _futureShopDetail = get_shop_detail(widget.shop_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (_futureShopDetail == null) ? buildColumn() : buildFutureBuilder();
  }

  buildColumn() {
    return Scaffold(
      body: Container(),
    );
  }

  FutureBuilder<ShopModel> buildFutureBuilder() {
    return FutureBuilder<ShopModel>(
        future: _futureShopDetail,
        builder: (context, snapshot) {
          print("Snapshot connection state: ${snapshot.connectionState}");
          print("Snapshot error: ${snapshot.error}");
          print("Snapshot data: ${snapshot.data}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingDialogBox(
              text: 'Please Wait..',
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data!;
            print("########################");
            print("########################");
            print("########################");
            print(data);

            var _shopDetail = data.data!;

            var _gallery = {
              "exterior": _shopDetail.shopExterior,
              "interior": _shopDetail.shopInterior,
              "works": _shopDetail.shopWork,
            };
            // var _packages = _shopDetail.shopPackages;

            print("#########################");
            print(_shopDetail);

            if (data.message == "Successful") {
              return Scaffold(
                body: Container(
                  color: bookPrimary.withOpacity(0.1),
                  child: SafeArea(
                    bottom: false,
                    top: false,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                        height: 250,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    hostNameMedia +
                                                        _shopDetail
                                                            .shopExterior![0]
                                                            .photo!),
                                                fit: BoxFit.cover))),
                                    Container(
                                      height: 250,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            bookPrimary
                                          ],
                                        ),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 70, left: 5, right: 5),
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            _shopDetail
                                                                .shopName!
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Fontspring"),
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on_outlined,
                                                                size: 20,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                  child: Text(
                                                                _shopDetail
                                                                    .locationName!
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                ),
                                                              )),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          if (_shopDetail
                                                              .open!) ...[
                                                            Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(2),
                                                                width: 70,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .green,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Center(
                                                                    child: Text(
                                                                  "Open",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                                ))),
                                                          ] else ...[
                                                            Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(2),
                                                                width: 70,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Center(
                                                                    child: Text(
                                                                  "Closed",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10,
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
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        child: Container(
                                          margin: EdgeInsets.all(15),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  buildNavItem(
                                                    "Services",
                                                    0,
                                                  ),
                                                  buildNavItem(
                                                    "Gallery",
                                                    1,
                                                  ),
                                                  buildNavItem(
                                                    "Saloon Staff",
                                                    2,
                                                  ),
                                                  //buildNavItem("Packages", 3,),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 40),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.arrow_back,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              )),
                                          Image.asset(
                                            "assets/icons/message.png",
                                            height: 18,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    child: PageView(
                                      controller: _pageController,
                                      onPageChanged: (int page) {
                                        setState(() {
                                          currentPage = page;
                                        });
                                      },
                                      children: [
                                        _services_page(
                                            _shopDetail.shopServices!,
                                            _shopDetail.open,
                                            _shopDetail.locationName,
                                            _shopDetail.shopStaffs,
                                            _shopDetail.shopId),
                                        _gallery_page(_gallery),
                                        _staff_page(_shopDetail.shopStaffs!),
                                        //_package_page(_packages, _shopDetail.open, _shopDetail.locationName!, _shopDetail.shopStaffs, _shopDetail.shopId)

                                        // Add more pages as needed
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              // Handle other cases, like displaying an error message or navigating to a different screen
              return Scaffold(
                body: Center(
                  child: Text('Error: ${data.message}'),
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

  Widget _services_page(
      services, bool? open, shop_location, shop_staffs, shop_id) {
    return Column(
      children: [
        Container(
          height: 75,
          //color: Colors.red,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _packages = services[index].packageService;
                  });

                  print(_packages);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        //height: 89,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: bookPrimary,
                            borderRadius: BorderRadius.circular(50)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/hair_cut.png",
                              height: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        services[index].serviceType,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        //Packages here

        Expanded(
          child: ListView.builder(
            itemCount: _packages.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ServiceDetails(
                            shop_id: shop_id,
                            service_name: _packages[index].packageName,
                            service_rating: _packages[index].rating,
                            shop_location: shop_location,
                            open: open,
                            service_id: services[index].serviceId,
                            service_price: _packages[index].price,
                            package_id: _packages[index].id,
                            service_photo: _packages[index].photo,
                            staffs: services[index].serviceSpecialist,
                          )));
                },
                child: Column(
                  children: [
                    Container(
                      //height: 200,
                      child: Stack(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                                //color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(hostNameMedia +
                                        _packages[index].photo.toString()),
                                    fit: BoxFit.cover)),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 70,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: bookPrimary,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _packages[index].packageName.toString(),
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 15,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 15,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 15,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 15,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      _packages[index].price.toString(),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _gallery_page(data) {
    var all_images = [];

    for (var _image in data["exterior"]) {
      all_images.add(_image);
    }

    for (var _image in data["interior"]) {
      all_images.add(_image);
    }

    for (var _image in data["works"]) {
      all_images.add(_image);
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
            ),
            itemCount: all_images
                .length, // Replace with the actual number of items you want to display
            itemBuilder: (BuildContext context, int index) {
              return Container(
                //height: 150,
                decoration: BoxDecoration(
                    //color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(
                            hostNameMedia + all_images[index].photo),
                        fit: BoxFit.cover)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _staff_page(data) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 30.0,
              mainAxisSpacing: 15.0,
            ),
            itemCount: data
                .length, // Replace with the actual number of items you want to display
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.all(10),
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
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(hostNameMedia +
                                    data[index].photo.toString()),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      data[index].staffName.toString(),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Text(
                      data[index].role.toString(),
                      style: TextStyle(fontSize: 10, color: Colors.white),
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
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
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
        //margin: EdgeInsets.all(5),
        width: 100,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : null,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? bookPrimary : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
