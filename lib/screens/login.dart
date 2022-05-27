import 'dart:async';

import 'package:bettersleep/controllers/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  Services services = Get.put(Services());
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade700,
        body: GetBuilder<Services>(
          builder: (services) => SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Center(
                    child: RichText(
                        text: TextSpan(
                            text: "Log",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                            children: [
                          TextSpan(
                            text: "IN",
                          )
                        ])),
                  ),
                  decoration: BoxDecoration(color: Colors.white),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 1,
                ),
                SizedBox(
                  height: 120,
                ),
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(20),
                    child: Form(
                        child: Column(
                      children: [
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                              hintText: "Enter your Email",
                              fillColor: Colors.black,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _password,
                          decoration: InputDecoration(
                              hintText: "Enter your Password",
                              fillColor: Colors.black,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        services.loading
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  services.login(
                                      email: _email.text.trim().toLowerCase(),
                                      password: _password.text);
                                  // logindone(context);
                                  setState(() {
                                    services.loading = false;
                                  });
                                },
                                icon: Icon(Icons.add),
                                label: Text("Login"))
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    services.loading = true;
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )),
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
