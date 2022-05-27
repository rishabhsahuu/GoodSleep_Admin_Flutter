import 'package:bettersleep/controllers/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    serv.fetchdata();
  }

  Services serv = Get.put(Services());
  Future? data;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Services>(
      builder: (serv) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: const Text("Better Sleep Admin"),
            actions: [
              IconButton(
                  onPressed: () {
                    serv.logout();
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: serv.data,
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: serv.userslist.length,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 0.0,
                              child: ListTile(
                                leading: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Image.network(
                                      snapshot.data[index]["imagefilepath"]),
                                ),
                                title: Text(snapshot.data[index]["audioname"]),
                                subtitle: RichText(
                                    text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        text: "Categorie: ",
                                        children: [
                                      TextSpan(
                                          text: snapshot.data[index]
                                              ["categories"])
                                    ])),
                                trailing: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            serv.delete(
                                                rawaudioname:
                                                    snapshot.data[index]
                                                        ["rawaudioname"],
                                                rawimagename:
                                                    snapshot.data[index]
                                                        ["rawimagename"],
                                                categories: snapshot.data[index]
                                                    ["categories"]);
                                            // serv.rs();
                                          },
                                          icon: Icon(Icons.delete)),
                                    ],
                                  ),
                                ),
                              ));
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            serv.uploading
                ? Container(
                    margin: EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20)),
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.035,
                        ),
                        Text(
                          "Uploading....",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )
                : Container()
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () {
            Get.toNamed("/addaudio");
          },
        ),
      ),
    );
  }
}
