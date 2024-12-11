import 'package:bookednise_app/PayStack/booking_paayment.dart';
import 'package:bookednise_app/PayStack/make_paystack_payment222.dart';
import 'package:bookednise_app/SplashScreen/spalsh_screen_first.dart';
import 'package:bookednise_app/theme.dart';
import 'package:bookednise_app/HomeScreen/home_screen.dart';
import 'package:bookednise_app/SplashScreen/spalsh_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => {runApp(MyApp())});
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide the keyboard when tapping outside the text field
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BookedNise',
        theme: theme(),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? api_key = "";

  Future? _user_api;

  @override
  void initState() {
    super.initState();
    _user_api = apiKey();
  }

  Future apiKey() async {
    api_key = await getApiPref();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _user_api,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return api_key == null ? SplashScreenFirst() : HomeScreen();
          //return VerifyEmail(email: 'BK-KOB8C2_AP',);
          //return BookingPaymentPage(amount: '200',);
        });
  }
}