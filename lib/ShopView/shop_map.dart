import 'dart:convert'; // For jsonDecode
import 'dart:ui';
import 'package:bookednise_app/Bookings/user_bookings.dart';
import 'package:bookednise_app/Components/sho_dialog.dart';
import 'package:bookednise_app/HomeScreen/home_screen.dart';
import 'package:bookednise_app/Message/chat_screen.dart';
import 'package:bookednise_app/Profile/UserProfile.dart';
import 'package:bookednise_app/ShopView/models/map_view_model.dart';
import 'package:bookednise_app/ShopView/shop_view_1.dart';
import 'package:bookednise_app/ShopView/shops_screen.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:location/location.dart'; // For user location

class ShopMap extends StatefulWidget {
  @override
  _ShopMapState createState() => _ShopMapState();
}

class _ShopMapState extends State<ShopMap> {
  late GoogleMapController mapController;
  List<Marker> _markers = [];
  List<Shop> nearestShops = [];
  LatLng? _currentLocation;
  late BitmapDescriptor customIcon;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadCustomIcon();
    fetchShops();
  }

  Future<void> _loadCustomIcon() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)), // Specify the size
      'assets/icons/shop_icon.png',
    );
    setState(() {}); // Update the state to refresh the map
  }

  Future<void> _getCurrentLocation() async {
    Location location = new Location();

    try {
      var userLocation = await location.getLocation();
      setState(() {
        _currentLocation =
            LatLng(userLocation.latitude!, userLocation.longitude!);
        // Add a marker for the user's current location
        _markers.add(Marker(
          markerId: MarkerId('user_location'),
          position: _currentLocation!,
          infoWindow: InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue), // Change color for the user's location
        ));
      });
      // Move the camera to the current location
      mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
    } catch (e) {
      print('Could not get the location: $e');
    }
  }

  Future<void> fetchShops() async {
    var token = await getApiPref();
    var user_id = await getUserIDPref();

    final response = await http.get(
      Uri.parse(hostName +
          "shop/list-nearby-shops/?user_id=" +
          user_id.toString() +
          "&radius="),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Token ' + token.toString(),
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['message'] == 'Successful') {
        List<dynamic> shops = data['data']['nearest_shops'];

        setState(() {
          // Clear existing data
          _markers.clear();
          nearestShops.clear();

          // Convert JSON to Shop objects and store in nearestShops
          nearestShops = shops.map((shop) => Shop.fromJson(shop)).toList();

          // Create markers from the shop data
          _markers.addAll(nearestShops.map((shop) {
            return Marker(
              markerId: MarkerId(shop.shopId!),
              position: LatLng(shop.latitude, shop.longitude),
              infoWindow: InfoWindow(
                title: shop.shopName,
                snippet: "${shop.distance.toStringAsFixed(2)} km",
                onTap: () {
                  print(shop.shopId);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ShopViewScreen1(shop_id: shop.shopId)),
                  );
                },
              ),
              icon: customIcon,
            );
          }).toList());
        });
      }
    } else {
      // Handle error case
      print('Failed to load shops: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              if (_currentLocation != null) {
                // Center the map on the current location if available
                mapController
                    .animateCamera(CameraUpdate.newLatLng(_currentLocation!));
              }
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(5.622164357, -0.17336083), // Fallback center
              zoom: 12.0,
            ),
            markers: Set.from(_markers),
          ),
          Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.all(7),
                        width: 150,
                        decoration: BoxDecoration(
                            color: bookPrimary,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            'Shops Near You',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AllShopsScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    width: 50,
                    decoration: BoxDecoration(
                        color: bookPrimary,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        "See All",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontFamily: "Fontspring"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 120,
                  // color: Colors.white,
                  child: nearestShops.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.store_mall_directory_rounded,
                                size: 30,
                                color: Colors.red,
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: bookPrimary,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  'No shops found nearby',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: nearestShops.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ShopViewScreen1(
                                            shop_id:
                                                nearestShops[index].shopId)));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 200,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      hostNameMedia +
                                                          nearestShops[index]
                                                              .photo
                                                              .toString()),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        Container(
                                          height: 100,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                            margin: EdgeInsets.all(15),
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
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  nearestShops[
                                                                          index]
                                                                      .shopName!
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      height: 1,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          "Fontspring"),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .location_on,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      Text(
                                                                        nearestShops[index]
                                                                            .location
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                "Fontspring"),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    width: 50,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(2),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        nearestShops[index]
                                                                            .distance
                                                                            .toStringAsFixed(2),
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .redAccent,
                                                                            fontSize:
                                                                                9,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontFamily: "Fontspring"),
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
                                ],
                              ),
                            );
                          }),
                ),
              ],
            ),
          ),
          customNavBar(context)
        ],
      ),
    );
  }

  Positioned customNavBar(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            // padding: EdgeInsets.symmetric(vertical: 13),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  bookPrimary,
                  Colors.transparent
                ], // Blue gradient effect
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
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.white))
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
                            onTap: () {},
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.explore, color: bookPrimary),
                                    Text('Explore',
                                        style: TextStyle(
                                            fontSize: 9, color: bookPrimary))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ChatScreen()));
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
        ],
      ),
    );
  }
}
