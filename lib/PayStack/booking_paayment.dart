import 'dart:convert';

import 'package:bookednise_app/Components/generic_error_dialog_box.dart';
import 'package:bookednise_app/Components/generic_success_dialog_box.dart';
import 'package:bookednise_app/Components/keyboard_utils.dart';
import 'package:bookednise_app/HomeScreen/home_screen.dart';
import 'package:bookednise_app/PayStack/payment_success.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;

class BookingPaymentPage extends StatefulWidget {
  final amount;
  final booking_data;
  final email;
  const BookingPaymentPage(
      {super.key,
      required this.amount,
      required this.booking_data,
      required this.email});

  @override
  State<BookingPaymentPage> createState() => _BookingPaymentPageState();
}

class _BookingPaymentPageState extends State<BookingPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;

  String publicKey = PAYSTACK_API;
  final plugin = PaystackPlugin();
  String message = '';

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }

  void makePayment(String email, String amount) async {
    int price = int.parse(amount) * 100;
    Charge charge = Charge()
      ..amount = price
      ..reference = 'ref_${DateTime.now()}'
      ..email = email
      ..currency = 'GHS';

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status == true) {
      String message = 'Payment was successful. Ref: ${response.reference}';

      if (mounted) {
        await bookAppointment(
            widget.booking_data, response.reference.toString());
      }
    } else {
      print(response.message);
    }
  }

  Future<void> bookAppointment(
      Map<String, dynamic> data, String reference) async {
    try {
      var token = await getApiPref();
      var userId = await getUserIDPref();

      final response = await http.post(
        Uri.parse(hostName + "bookings/book-appointment/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Token ' + token.toString()
        },
        body: jsonEncode({
          "user_id": userId.toString(),
          "shop_id": data["shop_id"],
          "service_id": data["service_id"],
          "staff_id": data["staff_id"],
          "package_id": data["package_id"],
          "slot_id": data["slot_id"],
          "slot_time": data["slot_time"],
          "home_service": data["home_service"],
          "notes": data["notes"],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);
        print("Booking Successful: $result");
        showSuccessDialogAndNavigate();
      } else if (response.statusCode == 400 ||
          response.statusCode == 403 ||
          response.statusCode == 422) {
        // Handle specific errors by extracting the message
        final errorResult = json.decode(response.body);
        String errorMessage = errorResult['errors']?['booking_id']?[0] ??
            errorResult['message'] ??
            'An error occurred while booking.';
        showErrorDialog(errorMessage);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      showErrorDialog('An error occurred while booking. Please try again.');
    }
  }

  void showSuccessDialogAndNavigate() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return SuccessDialogBox(text: "Booking Successful");
      },
    ).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialogBox(text: message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildColumn();
  }

  buildColumn() {
    return Scaffold(
      // backgroundColor: bookPrimary,
      body: SafeArea(
        //top: false,
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              size: 25,
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              // color: bookWhite,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                        'Make Payment',
                                        style: TextStyle(fontSize: 25),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          'Click proceed to continue or edit the payment email before proceeding.',
                                          style: TextStyle(fontSize: 12),
                                        )),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            initialValue: widget.email,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              labelText: "Email",
                                              labelStyle: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black
                                                      .withOpacity(0.5)),

                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 12.0),

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
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Email is required';
                                              }
                                              String pattern =
                                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                                  r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                                  r"{0,253}[a-zA-Z0-9])?)*$";
                                              RegExp regex = RegExp(pattern);
                                              if (!regex.hasMatch(value)) {
                                                return 'Enter a valid email address';
                                              }
                                              return null;
                                            },
                                            textInputAction:
                                                TextInputAction.next,
                                            autofocus: false,
                                            onSaved: (value) {
                                              setState(() {
                                                email = value;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Ghc " + widget.amount,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            KeyboardUtil.hideKeyboard(context);

                                            makePayment(email.toString(),
                                                widget.amount);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: bookPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: const Center(
                                            child: Text(
                                              "Proceed",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
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
}
