import 'package:get/get.dart';
import 'package:loginpage/screen/LoginScreen.dart';
import 'package:loginpage/screen/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;


class SplashController extends GetxController{



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _handleScreen();
  }

  void _handleScreen() async{
    print('--------');
    await Future.delayed(Duration(seconds: 2));
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String userToken=prefs.getString("user_token");
    if(userToken==null){
      Get.off(()=>LoginScreen(),transition: Transition.zoom,duration: Duration(milliseconds: 800));
    }else{
      ///check
      print('user token : ${prefs.getString("user_token")}');
      checkUserToken(userToken);
//      Get.off(()=>HomeScreen(),transition: Transition.zoom,duration: Duration(milliseconds: 800));
    }
  }

  void checkUserToken(String userToken) async{
    var url ="https://api-nodejs-todolist.herokuapp.com/user/me";

    Map<String,String> header={
      "Content-Type":"application/json",
      "Authorization":"Bearer $userToken"
    };

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.parse(url),headers: header);
    if (response.statusCode == 200) {
      var jsonResponse =
      convert.jsonDecode(response.body) ;
      print(jsonResponse);
      Get.off(()=>HomeScreen());
    } else {
      Get.off(()=>LoginScreen(),transition: Transition.zoom,duration: Duration(milliseconds: 800));

    }
  }
}