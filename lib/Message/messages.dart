import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatMessagesScreen extends StatefulWidget {
  const ChatMessagesScreen({super.key});

  @override
  State<ChatMessagesScreen> createState() => _ChatMessagesScreenState();
}

class _ChatMessagesScreenState extends State<ChatMessagesScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          bottom: false,
          child: Column(

            children: [
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left:15, right: 15, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.arrow_back, size: 35, )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Beauty Oasis", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, fontFamily: "Fontspring"),),


                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.location_on_outlined, size: 20,),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(child: Text("8/101 Nicholson St, Camp Hill EC1A 1AE", style: TextStyle(fontSize: 14,),)),

                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        padding: EdgeInsets.all(2),
                                        width: 70,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Center(child: Text("Open", style: TextStyle(color: Colors.white,fontSize: 10,),))),

                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Icon(Icons.star_rounded, color: Colors.yellow, size: 40,),
                                Text("4.5", style: TextStyle(fontSize: 20,),),

                              ],
                            )
                          ],
                        ),

                        SizedBox(
                          height: 5,
                        ),
                        Expanded(child: ListView(
                          reverse: true,
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(radius: 25, backgroundImage: AssetImage("assets/images/booking1.png"),),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: bookPrimary.withOpacity(0.4),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        )
                                    ),
                                    child: Text("HI, How can we help you?", style: TextStyle(fontSize: 12, ),)),



                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: bookPrimary.withOpacity(0.4),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    )
                                  ),
                                    child: Text("Hello, I am Bessie ", style: TextStyle(fontSize: 12, ),)),

                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(radius: 25,backgroundImage: AssetImage("assets/images/shop_g.png"),),
                              ],
                            ),


                          ],
                        ))
                      ],
                    ),
                  )
              ),
            
            
            
              Container(
                margin: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(

                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: bookPrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            //border: Border.all(color: Colors.black.withOpacity(0.1))
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  //hintText: 'Enter Username/Email',

                                  hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontWeight: FontWeight.normal),
                                  labelText: "Search here",

                                  labelStyle: TextStyle(fontSize: 13,
                                      color: Colors.black.withOpacity(0.5)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white)),
                                  border: InputBorder.none,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(225),
                                  PasteTextInputFormatter(),
                                ],

                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                onSaved: (value) {
                                  setState(() {
                                    //email = value;
                                  });
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(19),
                      decoration: BoxDecoration(
                        color: bookPrimary,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Icon(Icons.send, color: Colors.white,),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
