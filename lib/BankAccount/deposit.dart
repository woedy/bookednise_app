import 'dart:convert';

import 'package:bookednise_app/BankAccount/models/transactions_model.dart';
import 'package:bookednise_app/Bookings/user_bookings.dart';
import 'package:bookednise_app/Components/generic_loading_dialogbox.dart';
import 'package:bookednise_app/Components/sho_dialog.dart';
import 'package:bookednise_app/ShopView/shops_screen.dart';
import 'package:bookednise_app/HomeScreen/home_screen.dart';
import 'package:bookednise_app/Message/chat_screen.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../Components/generic_error_dialog_box.dart';
import '../Components/generic_success_dialog_box.dart';
import '../Components/keyboard_utils.dart';
import 'bank_account.dart';

Future<TransactionsModel> deposit_money(String amount) async {
  var token = await getApiPref();
  var userId = await getUserIDPref();

  final response = await http.post(
    Uri.parse(
        hostName + "bank_account/" + userId.toString() + "/client-deposit/"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Token ' + token.toString()
    },
    body: jsonEncode({
      "amount": amount,
      "description": "Deposit",
    }),
  );

  try {
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(jsonDecode(response.body));
      final result = json.decode(response.body);

      print("############");
      print("WE ARE INNNNNNNN");
      print(result);

      return TransactionsModel.fromJson(result);
    } else if (response.statusCode == 422 ||
        response.statusCode == 403 ||
        response.statusCode == 400 ||
        response.statusCode == 404) {
      print(jsonDecode(response.body));
      final result = json.decode(response.body);

      print("############");
      print("ERRORRRRRR");
      print(result);

      return TransactionsModel.fromJson(result);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to load data');
  }
}

class Deposit extends StatefulWidget {
  final amount;
  final account_id;

  const Deposit({super.key, required this.amount, required this.account_id});

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  Map<String, dynamic> userData = {};

  Future<TransactionsModel>? _futureDeposit;
  final _formKey = GlobalKey<FormState>();
  String? amount;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (_futureDeposit == null) ? buildColumn() : buildFutureBuilder();
  }

  buildColumn() {
    return Scaffold(
      body: Container(
        child: SafeArea(
          bottom: false,
          top: false,
          child: Column(
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
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: bookPrimary,
                              )),
                          Text(
                            "Deposit",
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
                  child: SingleChildScrollView(
                child: Container(
                  //margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150.0,
                          decoration: BoxDecoration(
                              //shape: BoxShape.circle,
                              //color: Colors.grey.withOpacity(0.3),
                              border: Border.all(
                                color: bookPrimary, // First stroke color
                                width: 5.0, // First stroke width
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Balance",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      Text(
                                        "\$  " + widget.amount.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 34,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image(
                                        height: 17,
                                        image: AssetImage(
                                            "assets/images/BookedNiseNew.png"),
                                      ),
                                      Text(
                                        widget.account_id.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Deposit",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 250,
                          child: ListView(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Amount",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.1))),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    maxLines: 3,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      //hintText: 'Enter Username/Email',

                                                      hintStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                      //labelText: "Amount",
                                                      labelStyle: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.5)),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                      border: InputBorder.none,
                                                    ),
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          225),
                                                      PasteTextInputFormatter(),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Amount is required';
                                                      }
                                                    },
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    autofocus: false,
                                                    onSaved: (value) {
                                                      setState(() {
                                                        amount = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),

                                            /*      Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Description", style: TextStyle(fontSize: 12, ),),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  border: Border.all(
                                                                      color: Colors.black.withOpacity(0.1))),
                                                              child: TextFormField(
                                                                style: TextStyle(color: Colors.black),
                                                                decoration: InputDecoration(
                                                                  //hintText: 'Enter Username/Email',

                                                                  hintStyle: TextStyle(
                                                                      color: Colors.grey,
                                                                      fontWeight: FontWeight.normal),
                                                                  //labelText: "Amount",
                                                                  labelStyle: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black.withOpacity(0.5)),
                                                                  enabledBorder: UnderlineInputBorder(
                                                                      borderSide:
                                                                      BorderSide(color: Colors.white)),
                                                                  focusedBorder: UnderlineInputBorder(
                                                                      borderSide:
                                                                      BorderSide(color: Colors.white)),
                                                                  border: InputBorder.none,
                                                                ),
                                                                maxLines: 4,
                                                                inputFormatters: [
                                                                  LengthLimitingTextInputFormatter(225),
                                                                  PasteTextInputFormatter(),
                                                                ],
                                                                validator: (value) {

                                                                },
                                                                textInputAction: TextInputAction.next,
                                                                autofocus: false,
                                                                onSaved: (value) {
                                                                  setState(() {
                                                                    //full_name = value;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
*/
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            KeyboardUtil.hideKeyboard(context);

                            _futureDeposit = deposit_money(amount!);
                          }

                          //Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPhotoReg()));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: bookPrimary,
                              borderRadius: BorderRadius.circular(7)),
                          child: Center(
                            child: Text(
                              "Deposit",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<TransactionsModel> buildFutureBuilder() {
    return FutureBuilder<TransactionsModel>(
        future: _futureDeposit,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingDialogBox(
              text: 'Please Wait..',
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data!;

            print("#########################");
            //print(data.data!.token!);

            if (data.message == "Deposit successful") {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BankAccount()),
                );

                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      // Show the dialog
                      return SuccessDialogBox(text: "Deposit Successful");
                    });
              });
            } else if (data.message == "Deposit failed") {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                /* Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ServiceDetails(
                    service_id: widget.service_id,
                    service_name: widget.service_name,
                    service_rating: widget.service_rating,
                    shop_location: widget.shop_location,
                    shop_id: widget.shop_id,
                    package_id: widget.package_id,
                    open: widget.open,
                    service_price: widget.service_price,
                    service_photo: widget.service_photo,
                    staffs: widget.staffs,
                  ),),
                      (route) => false,
                );

*/

                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialogBox(text: "Deposit failed");
                  },
                );
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
