import 'package:bettersleep/screens/homepage.dart';
import 'package:bettersleep/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/addaudio.dart';
import 'screens/login.dart';

void main() {
  runApp(BetterSleepAdmin());
}

class BetterSleepAdmin extends StatefulWidget {
  BetterSleepAdmin({Key? key}) : super(key: key);

  @override
  _BetterSleepStateAdmin createState() => _BetterSleepStateAdmin();
}

class _BetterSleepStateAdmin extends State<BetterSleepAdmin> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => Splashscreen(),
        "/addaudio": (context) => Addaudio(),
        "/login": (context) => Login(),
        "/home": (context) => HomePage(),
      },
    );
  }
}
