import 'package:bettersleep/controllers/api.dart';
import 'package:bettersleep/screens/homepage.dart';
import 'package:bettersleep/screens/login.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  Services services = Get.put(Services());

  Future? data;

  @override
  void initState() {
    data = services.token();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: data,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Login();
          } else if (snapshot.hasData) {
            return HomePage();
          } else {
            return Center(
                child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "Good",
                    style: TextStyle(color: Colors.blue[800], fontSize: 35)),
                TextSpan(
                    text: "Sleep",
                    style: TextStyle(color: Colors.white, fontSize: 32)),
                TextSpan(
                    text: " Admin",
                    style: TextStyle(color: Colors.white, fontSize: 36)),
              ]),
            ));
          }
        },
      ),
    );
  }
}
