import 'package:bookednise_app/Authentication/Registration/registration_1.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingSCREENState();
}

class _OnboardingSCREENState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        top: false,
        child: Container(
          //margin: EdgeInsets.all(15),
          color: bookPrimary,

          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Welcome to",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Fontspring",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            "assets/images/BookedNiseNew.png",
                            color: Colors.white,
                            height: 30,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            // width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage(
                                "assets/images/book_chick.png",
                              ),
                              fit: BoxFit.cover,
                            )),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Let's get started",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    /*               const SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      "assets/images/arrow-side-up.png",
                                      height: 40,
                                      color: Colors.black,
                                    ), */
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Registration1()));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: bookPrimary,
                                        borderRadius: BorderRadius.circular(7)),
                                    child: const Center(
                                      child: Text(
                                        "Begin Registration",
                                        style: TextStyle(color: bookDark),
                                      ),
                                    ),
                                  ),
                                ),
                                /*    InkWell(
                                    onTap: () {

                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => LoginScreen())
                                      );

                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      height: 59,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: bookDark,
                                          borderRadius: BorderRadius.circular(7)),
                                      child: Center(
                                        child: Text(
                                          "Login",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),*/
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
