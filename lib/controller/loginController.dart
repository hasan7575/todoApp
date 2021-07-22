import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:loginpage/screen/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginController extends GetxController{
  TextEditingController emailEditingController,passwordEditingController;

  @override
  void onInit() {
    // TODO: implement onInit

    emailEditingController=TextEditingController();
    passwordEditingController=TextEditingController();
    super.onInit();
  }

  login(password,email)async{
    var url ="https://api-nodejs-todolist.herokuapp.com/user/login";

    Map<String,String> header={
      "Content-Type":"application/json"
    };
    Map<String,String> body={
      "email": "$email",
      "password": "$password"
    };
    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(Uri.parse(url),body: convert.jsonEncode(body),headers: header);
    if (response.statusCode == 200) {
      var jsonResponse =
      convert.jsonDecode(response.body) ;
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.setString("user_token", jsonResponse['token']);
      Get.off(()=>HomeScreen());
      print('jsonResponse: $jsonResponse.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
      Get.snackbar("خطلا", "اطلاعات رو درست وارد کنید",backgroundColor: Color.fromARGB(1, 250, 1, 1),);
    }
 }
}