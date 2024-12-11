import 'dart:convert';

import 'package:bookednise_app/Bookings/cancel_booking.dart';
import 'package:bookednise_app/Bookings/user_bookings.dart';
import 'package:bookednise_app/Components/sho_dialog.dart';
import 'package:bookednise_app/HomeScreen/models/home_data_model.dart';
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
    getUserData();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Show loading dialog after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoadingDialog();
    });

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) _dismissLoadingDialog();
      _showLocationServiceDialog();
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) _dismissLoadingDialog();
        if (mounted) {
          setState(() {
            _locationMessage = 'Location permissions are denied.';
          });
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) _dismissLoadingDialog();
      if (mounted) {
        setState(() {
          _locationMessage =
              'Location permissions are permanently denied, we cannot request permissions.';
        });
      }
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (mounted) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        _locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";

        // Fetch home data after getting the location
        _futureHomeData =
            get_home_data(latitude.toString(), longitude.toString());
        print('#############################');
        print(latitude);
        print(longitude);
      });
    }

    if (mounted)
      _dismissLoadingDialog(); // Dismiss the loading dialog if still mounted
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return LoadingDialogBox(
          text: 'Please Wait..',
        );
      },
    );
  }

  void _dismissLoadingDialog() {
    Navigator.of(context).pop(); // Dismiss the loading dialog
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
                // Close the dialog
                Navigator.of(context).pop();
                // Optionally, you can navigate to device settings
                Geolocator.openLocationSettings();
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

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userDataString = prefs.getString('user_data') ?? '';

    // Check if the string is not empty before decoding
    if (userDataString.isNotEmpty) {
      try {
        // Attempt to decode the JSON string
        setState(() {
          userData = json.decode(userDataString);
         
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

              return Scaffold(
                body: Container(
                  child: SafeArea(
                    bottom: false,
                    top: false,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: bookPrimary,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
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
                                        // Dynamic greeting based on time of day
                                        DateTime.now().hour < 12
                                            ? "Good Morning"
                                            : DateTime.now().hour < 18
                                                ? "Good Afternoon"
                                                : "Good Evening",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        userData['full_name'].toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Fontspring",
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.notifications_active_outlined,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        UserProfile()),
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 35,
                                          backgroundImage: NetworkImage(
                                              hostNameMedia +
                                                  userData['photo'].toString()),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                      
                            ],
                          ),
                        ),
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
            text: 'Please Wait..',
          );
        });
  }

  void dispose() {
    super.dispose();
  }
}
