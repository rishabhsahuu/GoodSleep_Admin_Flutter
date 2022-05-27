import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Services extends GetxController {
  var nottesting = true;
  var postUri = Uri.parse('http://localhost:8000/');
  bool loading = true;
  List tokendatalist = [];
  List? Logindatalist;
  Future? data;
  bool uploading = false;

  senddata(
      {audiofile,
      audiofilename,
      audiotitle,
      imagefile,
      imagefilename,
      categories}) async {
    var request = http.MultipartRequest("post", postUri);
    uploading = true;
    update();

    request.fields["categories"] = categories;
    http.MultipartFile audiofiledata = await http.MultipartFile.fromPath(
        "audiofilepath", audiofile,
        filename: audiofilename);

    http.MultipartFile imagefiledata = await http.MultipartFile.fromPath(
        "imagefilepath", imagefile,
        filename: imagefilename);

    request.fields["audioname"] = audiotitle;

    request.fields["where"] = "uploads";

    request.files.add(imagefiledata);
    request.files.add(audiofiledata);

    request.send().then((value) {
      print(value);
      uploading = false;
      fetchdata();
      update();
    });

    print(imagefile);
  }

  List userslist = [];
  List emptylist = [];
  fetchdata() {
    // data = emptylist;
    data = getalldata();
  }

  updatecategories(
      {required imagepath,
      required categoryname,
      required key,
      required imagename}) async {
    var request = http.MultipartRequest("post", postUri);
    uploading = true;
    update();
    request.fields["categories"] = categoryname;
    http.MultipartFile imagepathfile = await http.MultipartFile.fromPath(
        "thumbnail", imagepath,
        filename: imagename);

    request.fields["where"] = "categories";
    request.files.add(imagepathfile);
    request.send().then((value) {
      uploading = false;
      update();
    });
  }

  Future<List> getalldata() async {
    try {
      var response = await http.get(
        postUri,
      );
      var data = await jsonDecode(response.body.toString());

      userslist = emptylist;
      print(userslist);
      for (var i = 0; i < data.length; i++) {
        userslist += data[i]["data"];
      }
      return userslist;
    } catch (e) {
      print(e);
      return userslist;
    }
  }

  List getcategorieslist = [];
  getcategories() async {
    var response = await http.get(postUri);

    var data = jsonDecode(response.body);
    // print(data);
    getcategorieslist = data;

    return getcategorieslist;
  }

  List deletedatalist = [];
  delete({rawaudioname, rawimagename, categories}) async {
    await http.delete(postUri, body: {
      "rawaudioname": rawaudioname,
      "rawimagename": rawimagename,
      "categories": categories
    });
    fetchdata();
    update();
    print("remove");
  }

  deletecategories({required name}) async {
    print(name);
    http.Response response = await http.delete(
        Uri.parse("http://localhost:8000/deletecategories"),
        body: {"categories": name});
    update();
  }

  var uri = Uri.parse("http://localhost:8000/admin");
  login({email, password}) async {
    try {
      http.Response response =
          await http.post(uri, body: {"email": email, "password": password});
      var fromjson = await jsonDecode(response.body);
      // print(fromjson);
      Logindatalist = await fromjson;

      if (!Logindatalist![0]["authentication"]) {
        loading = true;
      } else if (Logindatalist![0]["authentication"]) {
        loading = true;
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        var login =
            await preferences.setString("token", Logindatalist![0]["token"]);
        Get.offNamed("/home");
      }
      update();
    } catch (e) {
      loading = true;
      update();
      return Logindatalist;
    }
  }

  Future<List> token() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString("token");

    if (token != null) {
      try {
        http.Response response = await http.post(
            Uri.parse("http://localhost:8000/users/login"),
            body: {"token": token});
        var data = await jsonDecode(response.body);
        tokendatalist = data;

        return tokendatalist;
      } catch (e) {
        print(e);
        return tokendatalist;
      }
    } else {
      return Future.error("error");
    }
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("token");
    Get.offNamed("/login");
  }
}
