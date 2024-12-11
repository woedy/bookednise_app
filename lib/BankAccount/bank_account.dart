import 'dart:convert';

import 'package:bookednise_app/BankAccount/deposit.dart';
import 'package:bookednise_app/BankAccount/withdraw.dart';
import 'package:bookednise_app/Bookings/user_bookings.dart';
import 'package:bookednise_app/Components/generic_loading_dialogbox.dart';
import 'package:bookednise_app/Components/sho_dialog.dart';
import 'package:bookednise_app/ShopView/shops_screen.dart';
import 'package:bookednise_app/HomeScreen/home_screen.dart';
import 'package:bookednise_app/Message/chat_screen.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'models/bank_account_models.dart';

Future<BankAccountModel> get_user_profile() async {
  var token = await getApiPref();
  var user_id = await getUserIDPref();

  final response = await http.get(
    Uri.parse(hostName +
        "bank_account/" +
        user_id.toString() +
        "/client-transactions/"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Token ' + token.toString()
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print(jsonDecode(response.body));
    final result = json.decode(response.body);

    return BankAccountModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return BankAccountModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 403) {
    print(jsonDecode(response.body));
    return BankAccountModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 400) {
    print(jsonDecode(response.body));
    return BankAccountModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

class BankAccount extends StatefulWidget {
  const BankAccount({super.key});

  @override
  State<BankAccount> createState() => _BankAccountState();
}

class _BankAccountState extends State<BankAccount> {
  Map<String, dynamic> userData = {};

  Future<BankAccountModel>? _futureUserDetails;

  @override
  void initState() {
    super.initState();
    // Retrieve data from SharedPreferences
    _futureUserDetails = get_user_profile();
  }

  @override
  Widget build(BuildContext context) {
    return (_futureUserDetails == null) ? buildColumn() : buildFutureBuilder();
  }

  buildColumn() {
    return Scaffold(
      body: Container(),
    );
  }

  FutureBuilder<BankAccountModel> buildFutureBuilder() {
    return FutureBuilder<BankAccountModel>(
        future: _futureUserDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingDialogBox(
              text: 'Please Wait..',
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data!;

            var transactions = data.data!.transactions;
            var balance = data.data!.balance;

            print("####################3333");
            print(transactions);

            if (data.message == "Successful") {
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      "Transactions",
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
                            margin: EdgeInsets.only(left: 0, right: 0, top: 0),
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
                                          color:
                                              bookPrimary, // First stroke color
                                          width: 5.0, // First stroke width
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  "\$  " + balance.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 34,
                                                      fontWeight:
                                                          FontWeight.w700),
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
                                                  data.data!.accountId
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Deposit(
                                                          amount: balance
                                                              .toString(),
                                                          account_id: data
                                                              .data!.accountId,
                                                        )));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            //margin: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color: bookPrimary,
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            child: Center(
                                              child: Text(
                                                "Deposit",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Withdraw(
                                                          amount: balance
                                                              .toString(),
                                                          account_id: data
                                                              .data!.accountId,
                                                        )));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            //margin: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color: bookPrimary,
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            child: Center(
                                              child: Text(
                                                "Withdraw",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Transactions",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  height: 350,
                                  child: ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      itemCount: transactions!.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                  transactions[index]
                                                      .description!
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 15)),
                                              subtitle: Text(
                                                formatDate(transactions[index]
                                                    .timestamp!
                                                    .toString()),
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              trailing: Column(
                                                children: [
                                                  if (transactions[index]
                                                          .transactionType ==
                                                      "Withdrawal") ...[
                                                    Text(
                                                      "\$ " +
                                                          transactions[index]
                                                              .amount!
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 17,
                                                          color: Colors.red),
                                                    ),
                                                  ] else if (transactions[index]
                                                          .transactionType ==
                                                      "Deposit") ...[
                                                    Text(
                                                      "\$ " +
                                                          transactions[index]
                                                              .amount!
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 17,
                                                          color: Colors.green),
                                                    ),
                                                  ]
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      }),
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
          }

          return LoadingDialogBox(
            text: 'Please Wait..',
          );
        });
  }

  void dispose() {
    super.dispose();
  }

  String formatDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('MMMM d').format(dateTime);
  }
}
