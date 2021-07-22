import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:loginpage/constants.dart';
import 'package:loginpage/controller/splashController.dart';
import 'package:loginpage/screen/LoginScreen.dart';
import 'package:get/get.dart';
import 'package:loginpage/screen/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: mediumBlue,
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Text(
              "Todo App",
              style: TextStyle(
                  color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }





}
