import 'dart:convert';
import 'package:bookednise_app/Message/models/chat_model.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  final booking_id;
  final shop_name;

  const ChatPage(
      {super.key, required this.booking_id, required this.shop_name});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final pusher = PusherChannelsFlutter.getInstance();
  bool isSending = false;

  String userID = '';

  @override
  void initState() {
    super.initState();
    initPusher();
    fetchAllMessages(); // Fetch all messages on init
  }

  void initPusher() async {
    var user_id = await getUserIDPref();

    await pusher.init(apiKey: PUSHER_API, cluster: PUSHER_CLUSTER);
    await pusher.connect();

    final myChannel = await pusher.subscribe(
      channelName: widget.booking_id,
      onEvent: (event) {
        print("Received event: ${event.data}");
        handleEvent(event.data);
      },
    );

    userID = user_id.toString();
  }

  void fetchAllMessages() async {
    var token = await getApiPref();
    var user_id = await getUserIDPref();

    final response = await http.post(
      Uri.parse(hostName + 'bookings/get-booking-chats/'),
      headers: <String, String>{
        'Authorization': 'Token ' + token.toString(),
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'booking_id': widget.booking_id,
        'user_id': user_id,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['messages'];
      setState(() {
        messages = jsonData
            .map((msg) => Message.fromJson(msg))
            .toList()
            .reversed
            .toList();
      });
    } else {
      print("Failed to fetch messages");
    }
  }

  void handleEvent(String eventData) {
    final Map<String, dynamic> jsonData = json.decode(eventData);
    final List<Message> newMessages = (jsonData['messages'] as List)
        .map((messageJson) => Message.fromJson(messageJson))
        .toList()
        .reversed
        .toList();

    setState(() {
      messages.clear();
      messages.addAll(newMessages);
    });
  }

  void sendMessage() async {
    var token = await getApiPref();
    var user_id = await getUserIDPref();

    String message = _messageController.text.trim();
    if (message.isNotEmpty && !isSending) {
      setState(() {
        isSending = true;
      });

      final response = await http.post(
        Uri.parse(hostName + 'bookings/send-booking-chat/'),
        headers: <String, String>{
          'Authorization': 'Token ' + token.toString(),
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'booking_id': widget.booking_id,
          'user_id': user_id,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        _messageController.clear();
      } else {
        print("Failed to send message");
      }

      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              //color: bookPrimary.withOpacity(0.1),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back,
                          size: 25,
                        ),
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.shop_name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Fontspring"),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    padding: EdgeInsets.all(2),
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                        child: Text(
                                      "Open",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 5,
                                      ),
                                    ))),
                                SizedBox(
                                  height: 5,
                                ),
                                Divider()
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
            Expanded(
              child: ListView.builder(
                reverse: false,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];

                  print(userID);

                  //return ListTile(
                  //  title: Text(message.message),
                  //  subtitle: Text(
                  //      '${message.room.client.fullName} - ${message.timestamp}'),
                  //  leading: CircleAvatar(
                  //    backgroundImage: NetworkImage(hostNameMedia +
                  //        message.room.client.personalInfo.photo),
                  //  ),
                  //);

                  return Column(
                    children: [
                      userID == message.sender
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                        color: bookPrimary,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        )),
                                    child: Text(
                                      message.message.toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(hostNameMedia +
                                      message.room.client.personalInfo.photo),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(hostNameMedia +
                                      message.room.shop.shopUser.photo),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                        color: bookPrimary,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        )),
                                    child: Text(
                                      message.message.toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    )),
                              ],
                            )
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: bookPrimary,
                    borderRadius: BorderRadius.circular(13)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(fontSize: 13, color: Colors.white),
                        decoration: InputDecoration(
                            labelText: 'Send a message',
                            labelStyle:
                                TextStyle(fontSize: 13, color: Colors.white)),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: isSending ? null : sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pusher.disconnect();
    super.dispose();
  }
}
