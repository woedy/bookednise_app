import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StaffDetails extends StatefulWidget {
  const StaffDetails({super.key});

  @override
  State<StaffDetails> createState() => _StaffDetailsState();
}

class _StaffDetailsState extends State<StaffDetails> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(Icons.arrow_back, size: 35, color: Colors.black,)),
                                Image.asset("assets/icons/message.png", height: 25,)

                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Marvin McKinney", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: "Fontspring"),),
                                    Text("Hair stylist", style: TextStyle(fontSize: 15,),),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                            Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                            Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                            Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                            Icon(Icons.star_rounded, size: 15, color: Colors.yellow,)
                                          ],
                                        ),
                                        Text("( 5.0 )", style: TextStyle(fontSize: 10,),),
                                      ],
                                    )
                                  ],
                                ),
                                CircleAvatar(
                                  radius: 40,
                                )
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),

                                child: Text(
                                  "Skillset",
                                  style: TextStyle(fontSize: 10, ),
                                ),
                              ),
                              SizedBox(height: 15,),
                              Container(
                                height: 140,
                                //color: Colors.red,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 89,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/icons/message.png", height: 25,),

                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Haircut",
                                            style: TextStyle(fontSize: 10,),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 89,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/icons/message.png", height: 25,),

                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Styling",
                                            style: TextStyle(fontSize: 10,),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 89,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/icons/message.png", height: 25,),

                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Hair Dryer",
                                            style: TextStyle(fontSize: 10,),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 89,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/icons/message.png", height: 25,),

                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Massage",
                                            style: TextStyle(fontSize: 10,),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 89,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/icons/message.png", height: 25,),

                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Haircut",
                                            style: TextStyle(fontSize: 10,),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 89,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/icons/message.png", height: 25,),

                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Haircut",
                                            style: TextStyle(fontSize: 10,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),

                                child: Text(
                                  "Shop",
                                  style: TextStyle(fontSize: 10, ),
                                ),
                              ),
                              SizedBox(height: 15,),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 177,
                                      width: 140,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40.0), // Adjust the radius as needed
                                            topRight: Radius.circular(40.0), // Adjust the radius as needed
                                          ),
                                          image: DecorationImage(
                                              image: AssetImage("assets/images/booking1.png"),fit: BoxFit.cover
                                          )
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Beauty Oasis", style: TextStyle(fontSize: 20,fontFamily: "Fontspring", fontWeight: FontWeight.w800 ),),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.location_on_outlined, size: 20,),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(child: Text("8/101 Nicholson St, Camp Hill EC1A 1AE", style: TextStyle(fontSize: 10,),)),

                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 35,
                                            //color: Colors.blue,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 5,
                                              itemBuilder: (context, index){
                                                return  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                    margin: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: bookPrimary.withOpacity(0.3),
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child: Text("Hairstyle", style: TextStyle(fontSize: 10, ),));

                                              },
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              /*

                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (context) => VerifyEmail())
                                                );
                                 */

                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                                              height: 45,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: bookPrimary,
                                                  borderRadius: BorderRadius.circular(7)),
                                              child: Center(
                                                child: Text(
                                                  "Book",
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),


                                        ],
                                      ),
                                    )

                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),

                                child: Text(
                                  "Gallery",
                                  style: TextStyle(fontSize: 10, ),
                                ),
                              ),
                              SizedBox(height: 15,),
                              Container(
                                height: 200,
                                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 30.0,
                                    mainAxisSpacing: 15.0,
                                  ),
                                  itemCount: 10, // Replace with the actual number of items you want to display
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      padding: EdgeInsets.all(10),
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
                                          Text("Marvin McKinney", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
                                          Text("Hair stylist", style: TextStyle(fontSize: 10,),),
                                          Row(
                                            children: [
                                              Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                              Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                              Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                              Icon(Icons.star_rounded, size: 15, color: Colors.yellow,),
                                              Icon(Icons.star_rounded, size: 15, color: Colors.yellow,)
                                            ],
                                          )

                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          /*      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DashboardScreen()));
                        */  },
                        child: Column(
                          children: [
                            Image.asset("assets/icons/home.png", height: 25,)
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EarningsScreen()));
                        },
                        child: Column(
                          children: [
                            Image.asset("assets/icons/card.png", height: 25,)
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){


                        },
                        child: Column(
                          children: [
                            Image.asset("assets/icons/add.png", height: 40,)

                          ],
                        ),
                      ),

                      InkWell(
                        onTap: (){

                          //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MeetYourClients()));

                        },
                        child: Column(
                          children: [
                            Image.asset("assets/icons/message.png", height: 25,)

                          ],
                        ),
                      ),

                      InkWell(
                        onTap: (){

                          //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SettingsScreen()));

                        },
                        child: Column(
                          children: [
                            Image.asset("assets/icons/person.png", height: 25,)
                          ],
                        ),
                      ),


                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
