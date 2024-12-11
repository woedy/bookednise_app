import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.red,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                              height: 250,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/shop1.png"),
                                      fit: BoxFit.cover
                                  )
                              )

                          ),
                          Container(
                            height: 250,
                            decoration: BoxDecoration(

                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black],
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          onTap: (){
                                            Navigator.of(context).pop();
                                          },
                                          child: Icon(Icons.arrow_back, size: 35, color: Colors.white,)),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Text(
                                          "\$70",
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                      ),

                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Hair Re Touch", style: TextStyle(color: Colors.white,fontSize: 48, fontWeight: FontWeight.w500, fontFamily: "Fontspring"),),


                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.location_on_outlined, size: 20, color: Colors.white,),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(child: Text("8/101 Nicholson St, Camp Hill EC1A 1AE", style: TextStyle(color: Colors.white,fontSize: 14,),)),

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
                                          Text("4.5", style: TextStyle(color: Colors.white,fontSize: 20,),),

                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),




                    ],
                  ),
                ),





                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(

                        child: Column(
                          children: [
                            Container(
                              //width: 200,
                              height: 200,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),



                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      //height: 70,
                                      decoration: BoxDecoration(
                                        //color: Colors.red,
                                          borderRadius: BorderRadius.circular(15),
                                          image: DecorationImage(
                                              image: AssetImage("assets/images/shop_g.png"),
                                              fit: BoxFit.cover

                                          )

                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Marvin McKinney", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                                          Text("Hair stylist", style: TextStyle(fontSize: 12,),),
                                          Row(
                                            children: [
                                              Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                              Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                              Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                              Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                              Icon(Icons.star_rounded, size: 15, color: Colors.yellow,)
                                            ],
                                          ),
                                        ],
                                      ),

                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Text(
                                          "\$70.00",
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                      ),

                                    ],
                                  ),


                                ],
                              ),
                            ),

                          ],
                        )
                    )
                  ],
                ),

                Container(
                  margin: EdgeInsets.all(10),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/icons/star.png",),
                      Image.asset("assets/icons/star.png",),
                      Image.asset("assets/icons/star.png",),
                      Image.asset("assets/icons/star.png",),
                      Image.asset("assets/icons/star.png", color: Colors.grey,)
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text("Leave a report", style: TextStyle(fontSize: 12, ),),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.1))),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            //hintText: 'Enter Username/Email',

                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            labelText: "",
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(225),
                            PasteTextInputFormatter(),
                          ],
                          /* validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is required';
                            }
                      */
                          maxLines: 4,
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


                InkWell(
                  onTap: () {

                    /* Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => VerifyEmail())
                                          );*/

                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    height: 59,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: bookPrimary,
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                      child: Text(
                        "Leave rating",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),





                SizedBox(height: 45,)





              ],
            ),
          ),
        ),
      ),
    );
  }







}
