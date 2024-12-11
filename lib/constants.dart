import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

const bookPrimary = Color(0xff772DA8);
const bookDark = Color(0xffffffff);
const bookDark2 = Color(0xff8E8E8E);
const bookBlack = Color(0xff000000);
const bookWhite = Color(0xffF8F7FC);

const bodyText1 = Color(0xffffffff);
const bodyText2 = Color(0xffffffff);
const clay = Color(0xffa499b3);

const hostName = "https://api.bookednise.com/api/";
const hostNameMedia = "https://api.bookednise.com";

//const hostName = "http://192.168.43.121:8000/api/";
//const hostNameMedia = "http://192.168.43.121:8000";

const PUSHER_API = "88ff191e00149bfda666";
const PUSHER_CLUSTER = "mt1";

const PAYSTACK_API = "pk_test_6a1da2dbb5c967f84a986c772230552865d8642d";

Future<String?> getApiPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("API_Key");
}

Future<String?> getUserIDPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("USER_ID");
}

Future<String?> getEmailPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("EMAIL");
}

class PasteTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow pasting of text by returning the new value unchanged
    return newValue;
  }
}
