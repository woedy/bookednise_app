import 'dart:convert';
import 'dart:ui';

import 'package:bookednise_app/Bookings/cancel_booking.dart';
import 'package:bookednise_app/Bookings/user_bookings.dart';
import 'package:bookednise_app/Components/sho_dialog.dart';
import 'package:bookednise_app/HomeScreen/models/home_data_model.dart';
import 'package:bookednise_app/ShopView/shop_map.dart';
import 'package:bookednise_app/ShopView/shops_screen.dart';
import 'package:bookednise_app/Message/chat_screen.dart';
import 'package:bookednise_app/Profile/UserProfile.dart';
import 'package:bookednise_app/SplashScreen/spalsh_screen.dart';
import 'package:bookednise_app/SplashScreen/spalsh_screen_first.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../Components/generic_loading_dialogbox.dart';

Future<HomeDataModel> get_home_data(String lat, String lng) async {
  print('##################');
  print(lat);
  print(lng);
  var token = await getApiPref();
  var user_id = await getUserIDPref();

  final response = await http.get(
    Uri.parse(hostName +
        "homepage/client-homepage/?user_id=" +
        user_id.toString() +
        "&lat=" +
        lat.toString() +
        "&lng=" +
        lng.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Token ' + token.toString()
    },
  );
  print(response.statusCode);
  if (response.statusCode == 200 || response.statusCode == 201) {
    print(jsonDecode(response.body));
    final result = json.decode(response.body);

    return HomeDataModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return HomeDataModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 403) {
    print(jsonDecode(response.body));
    return HomeDataModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 400) {
    print(jsonDecode(response.body));
    return HomeDataModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    print(jsonDecode(response.body));
    return HomeDataModel.fromJson(jsonDecode(response.body));
  } else {
    //throw Exception('Failed to load data');
    print(jsonDecode(response.body));
    return HomeDataModel.fromJson(jsonDecode(response.body));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;
  Map<String, dynamic> userData = {};

  String _locationMessage = "";
  double latitude = 0.0;
  double longitude = 0.0;

  Future<HomeDataModel>? _futureHomeData;

  @override
  void initState() {
    super.initState();
    // Retrieve data from SharedPreferences
    getUserData().then((_) {
      sendCurrentLocation(); // Call after user data is fetched
    });
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userDataString = prefs.getString('user_data') ?? '';

    // Check if the string is not empty before decoding
    if (userDataString.isNotEmpty) {
      try {
        // Attempt to decode the JSON string
        setState(() {
          userData = json.decode(userDataString);

          _futureHomeData =
              get_home_data(latitude.toString(), longitude.toString());
        });
      } catch (e) {
        // Handle any errors during JSON decoding
        print('Error decoding user data: $e');
        // Optionally, set userData to a default value or handle the error as needed
        setState(() {
          userData = {}; // or null, or some default value
        });
      }
    } else {
      // Handle the case where there is no user data
      print('No user data found');
      setState(() {
        userData = {}; // or null, or some default value

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SplashScreenFirst()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_futureHomeData == null) ? buildColumn() : buildFutureBuilder();
  }

  Future<void> sendCurrentLocation() async {
    print('YUUUUUUUUUUUUUUUUUUUU'); // Check if function is called

    // Check if location services are enabled
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    print('Location services enabled: $isLocationServiceEnabled'); // Log status

    if (!isLocationServiceEnabled) {
      _showLocationServiceDialog();
      return;
    }

    try {
      // Check the current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      print('Current permission status: $permission'); // Log permission status

      // If permission is denied, request permission
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print(
            'Requested permission status: $permission'); // Log requested permission
        if (permission == LocationPermission.denied) {
          print('Location permission denied.');
          return;
        }
      }

      // If permission is denied forever
      if (permission == LocationPermission.deniedForever) {
        print(
            'Location permission permanently denied. Please enable it in settings.');
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        print(
            'YUUUUUUUUUUUUUUUUUUUU22222'); // This should print if everything works

        print(
            'About to get current position...'); // Debug before getting position
        // If permission is granted, get the current position
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        latitude = position.latitude; // Use class variables
        longitude = position.longitude;
        print(
            'YUUUUUUUUUUUUUU4444444444'); // This should print if everything works

        print('Latitude: $latitude'); // Print latitude
        print('Longitude: $longitude'); // Print longitude

        // await sendLocationData(latitude, longitude);
      }
    } catch (e) {
      print('Error getting location: $e'); // Catch any error
    }
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text('Please enable location services to use this feature.'),
          actions: <Widget>[
            TextButton(
              child: Text('Settings'),
              onPressed: () {
                // Open location settings
                Geolocator.openLocationSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> sendLocationData(double latitude, double longitude) async {
    print('WOOOOOOOOOOOOOOOOOOOTTTTTTTTTTT');
    var token = await getApiPref(); // Fetch your token
    var userId = await getUserIDPref(); // Fetch user ID

    final response = await http.post(
      Uri.parse(hostName + "location/update-endpoint/"), // Your endpoint here
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Token ' + token.toString(),
      },
      body: jsonEncode({
        'user_id': userId,
        'lat': latitude,
        'lng': longitude,
      }),
    );

    if (response.statusCode == 200) {
      print('Location updated successfully');
    } else {
      print('Failed to update location: ${response.statusCode}');
      print(jsonDecode(response.body));
    }
  }

  buildColumn() {
    return Scaffold(
      body: Container(),
    );
  }

  FutureBuilder<HomeDataModel> buildFutureBuilder() {
    return FutureBuilder<HomeDataModel>(
        future: _futureHomeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingDialogBox(
              text: 'Please Wait..',
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data!;

            if (data.message == "Successful") {
              var bookings = data.data!.bookings;
              var promotions = data.data!.promotions;
              var services_cat = data.data!.serviceCategories;

              return Scaffold(
                body: Container(
                  color: bookPrimary.withOpacity(0.1),
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
                                gradient: LinearGradient(
                                  colors: [bookPrimary, Colors.transparent],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        UserProfile()),
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(
                                                  hostNameMedia +
                                                      userData['photo']
                                                          .toString()),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                // Dynamic greeting based on time of day
                                                DateTime.now().hour < 12
                                                    ? "Good Morning"
                                                    : DateTime.now().hour < 18
                                                        ? "Good Afternoon"
                                                        : "Good Evening",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                userData['full_name']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Fontspring",
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Colors.white
                                                    .withOpacity(0.2)),
                                            child: Icon(
                                              Icons
                                                  .notifications_active_outlined,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 30,
                                    decoration: BoxDecoration(
                                      //color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontWeight:
                                                      FontWeight.normal),
                                              labelText: "Search service here",
                                              labelStyle: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black
                                                      .withOpacity(0.5)),
                                              enabled: false,

                                              // Add an underline
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: bookDark2),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: bookPrimary),
                                              ),
                                            ),
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  225),
                                              PasteTextInputFormatter(),
                                            ],
                                            textInputAction:
                                                TextInputAction.next,
                                            autofocus: false,
                                            onSaved: (value) {
                                              setState(() {
                                                //email = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.search, size: 15),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              margin:
                                  EdgeInsets.only(left: 5, right: 5, top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Service Categories",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: bookPrimary,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "See All",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: bookBlack,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 120,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      services_cat!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Stack(
                                                      alignment: Alignment
                                                          .center, // Center the content in the stack
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      3),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                height: 75,
                                                                width: 75,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      bookPrimary,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 5),
                                                              Container(
                                                                width: 60,
                                                                child: Text(
                                                                  services_cat![
                                                                          index]
                                                                      .serviceType!
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Center the image within the stack
                                                        Align(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          child: Container(
                                                            height: 70,
                                                            width: 70,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  bookPrimary,
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/images/shop_g.png'),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Your Promotions",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: bookPrimary,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "See All",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: bookBlack,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 100,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: promotions!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            Container(
                                                              height: 100,
                                                              width: 260,
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(hostNameMedia +
                                                                          promotions[index]
                                                                              .packagePhoto!
                                                                              .toString()),
                                                                      fit: BoxFit
                                                                          .cover),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                            ),
                                                            Container(
                                                              height: 100,
                                                              width: 260,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  colors: [
                                                                    Colors
                                                                        .transparent,
                                                                    Colors.black
                                                                  ],
                                                                ),
                                                              ),
                                                              child: Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.all(5),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.transparent,
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              Text(
                                                                            "",
                                                                            style:
                                                                                TextStyle(fontSize: 16, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Container(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      promotions[index].packageName!,
                                                                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: "Fontspring"),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    promotions[index].packagePrice!,
                                                                                    style: TextStyle(fontSize: 10, color: Colors.white, decoration: TextDecoration.lineThrough, decorationColor: Colors.white),
                                                                                  ),
                                                                                  Text(
                                                                                    promotions[index].discountPrice!.toString(),
                                                                                    style: TextStyle(fontSize: 15, color: Colors.white),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Expanded(
                                                                                child: Container(
                                                                                    padding: EdgeInsets.all(2),
                                                                                    width: 70,
                                                                                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                                                                                    child: Center(
                                                                                        child: Text(
                                                                                      "Available",
                                                                                      style: TextStyle(
                                                                                        color: Colors.white,
                                                                                        fontSize: 7,
                                                                                      ),
                                                                                    ))),
                                                                              ),
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
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Your Bookings",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: bookPrimary,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  UserBookings()));
                                                    },
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            color: bookPrimary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          color: Colors.white,
                                                          size: 15,
                                                        )),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 0,
                                              ),
                                              Container(
                                                //padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    //      color: bookPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    if (bookings!.length !=
                                                        0) ...[
                                                      Container(
                                                        height: 100,
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              bookings.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return InkWell(
                                                              onTap: () {
                                                                Navigator.of(context).push(
                                                                    MaterialPageRoute(
                                                                        builder: (BuildContext
                                                                                context) =>
                                                                            CancelBookings(
                                                                              booking_data: bookings[index],
                                                                            )));
                                                              },
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    margin: EdgeInsets.only(
                                                                        right:
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        color: bookPrimary.withOpacity(
                                                                            0.1),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              bookings[index].bookingTime!.toString(),
                                                                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            CircleAvatar(
                                                                              backgroundImage: NetworkImage(hostNameMedia + bookings[index].bookedStaff!.photo!.toString()),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  bookings[index].bookedStaff!.staffName!.toString(),
                                                                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                                                                ),
                                                                                Text(
                                                                                  bookings[index].service!.serviceType.toString(),
                                                                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ] else ...[
                                                      Container(
                                                        height: 133,
                                                        child: Center(
                                                          child: Text(
                                                            "No Bookings Available.",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
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
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()));
              });
            }
          }

          return LoadingDialogBox(
            text: 'Please Wait.!!!.',
          );
        });
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
                          print('Home tapped');
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/home.png",
                              height: 20,
                              color:
                                  bookPrimary, // Change color to contrast with blue
                            ),
                            Text('Home',
                                style:
                                    TextStyle(fontSize: 9, color: bookPrimary))
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

  void dispose() {
    super.dispose();
  }

  Widget buildIconButton(BuildContext context, String assetPath, double height,
      VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            assetPath,
            height: height,
            color: Colors
                .white, // Optional: change icon color to white for better contrast
          ),
        ],
      ),
    );
  }
}
