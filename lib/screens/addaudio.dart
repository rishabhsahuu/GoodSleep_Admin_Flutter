import 'dart:developer';
import 'dart:io';
import 'package:bettersleep/controllers/api.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import "package:file_picker/file_picker.dart";

import 'package:path/path.dart';

class Addaudio extends StatefulWidget {
  Addaudio({Key? key}) : super(key: key);

  @override
  _AddaudioState createState() => _AddaudioState();
}

class _AddaudioState extends State<Addaudio> {
  var audiofiles;
  var imagefile;
  var imagefiledata;

  TextEditingController audiotitle = TextEditingController();
  TextEditingController dropdownvalue = TextEditingController();

  Services service = Get.put(Services());
  bool uploadaudio = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.black,
          title: Text(
            "Better Sleep Admin",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(50),
          child: SingleChildScrollView(
            child: uploadaudio
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  uploadaudio = true;
                                });
                              },
                              icon: Icon(Icons.upload_file),
                              label: Text("Upload")),
                          TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  uploadaudio = false;
                                });
                              },
                              icon: Icon(Icons.category),
                              label: Text("Update Categories"))
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      InkWell(
                        onTap: () async {
                          var file = await FilePicker.platform.pickFiles();
                          if (file!.files.first != null) {
                            audiofiles = file.files.first;
                          }
                          setState(() {
                            try {
                              imagefile = File(file.files.first.path!);
                              imagefiledata = file.files.first;
                            } catch (e) {
                              print("null");
                            }
                          });
                        },
                        child: Container(
                          child: imagefile != null
                              ? Center(child: Image.file(imagefile))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Image.asset(
                                            "lib/assets/images/addphoto.png")),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.001,
                                    ),
                                    Text("Click Here to add images")
                                  ],
                                ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () {
                            showDialog(
                                context: (context),
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Select Category",
                                        style: TextStyle(fontSize: 20)),
                                    content: Container(
                                      child: GetBuilder<Services>(
                                        builder: (service) => FutureBuilder(
                                            future: service.getcategories(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return ListView.builder(
                                                    itemCount: service
                                                        .getcategorieslist
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ListTile(
                                                        title: Text(service
                                                                .getcategorieslist[
                                                            index]["categories"]),
                                                        onTap: () {
                                                          dropdownvalue
                                                              .text = service
                                                                  .getcategorieslist[
                                                              index]["categories"];
                                                          Get.back();
                                                        },
                                                        trailing: IconButton(
                                                          onPressed: () {
                                                            service.deletecategories(
                                                                name: service
                                                                            .getcategorieslist[
                                                                        index][
                                                                    "categories"]);
                                                          },
                                                          icon: Icon(
                                                              Icons.delete),
                                                        ),
                                                      );
                                                    });
                                              } else {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                            }),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                    ),
                                  );
                                });
                          },
                          child: Text("Select Category")),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "Enter Audio Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                        controller: audiotitle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () async {
                            var file = await FilePicker.platform.pickFiles();
                            if (file!.files.first != null) {
                              audiofiles = file.files.first;
                            }
                          },
                          child: Text("Pick Audio File")),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () {
                            if (audiotitle.text != null) {
                              service.senddata(
                                  audiofile: audiofiles.path,
                                  audiofilename: audiofiles.name,
                                  audiotitle: audiotitle.text,
                                  imagefile: imagefiledata.path,
                                  imagefilename: imagefiledata.name,
                                  categories: dropdownvalue.text);
                              Get.back();
                            }
                          },
                          child: Text("Submit"))
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  uploadaudio = true;
                                });
                              },
                              icon: Icon(Icons.upload_file),
                              label: Text("Upload")),
                          TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  uploadaudio = false;
                                });
                              },
                              icon: Icon(Icons.category),
                              label: Text("Update Categories"))
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      InkWell(
                        onTap: () async {
                          var file = await FilePicker.platform.pickFiles();
                          if (file!.files.first != null) {
                            audiofiles = file.files.first;
                          }
                          setState(() {
                            try {
                              imagefile = File(file.files.first.path!);
                              imagefiledata = file.files.first;
                            } catch (e) {
                              print("null");
                            }
                          });
                        },
                        child: Container(
                          child: imagefile != null
                              ? Center(child: Image.file(imagefile))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Image.asset(
                                            "lib/assets/images/addphoto.png")),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.001,
                                    ),
                                    Text("Click Here to add images")
                                  ],
                                ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "Enter Category Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                        controller: audiotitle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () {
                            service.updatecategories(
                                imagepath: imagefiledata.path,
                                categoryname: audiotitle.text,
                                key: _scaffoldKey.currentState,
                                imagename: imagefiledata.name);
                            Get.back();
                          },
                          child: Text("Submit"))
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
