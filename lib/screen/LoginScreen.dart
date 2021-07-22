import 'package:flutter/material.dart';
import 'package:loginpage/constants.dart';
import 'package:loginpage/controller/loginController.dart';
import 'package:loginpage/screen/widget/buttonWidget.dart';
import 'package:loginpage/screen/widget/textFieldWidget.dart';
import 'package:get/get.dart';
import 'package:progress_indicator_button/progress_button.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());
  var _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Container(
              height: 200,
              alignment: Alignment.center,
              width: double.infinity,
              decoration: new BoxDecoration(
                color: mediumBlue,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: new Text('Login',
                  style: new TextStyle(
                      color: whiteColor,
                      fontSize: 35,
                      fontWeight: FontWeight.w900))),
          new Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  new Container(
                      child: TextFieldWidget(
                        validator: (String value){
                          if(value.isEmpty){
                            return "please enter email";
                          }else if(!GetUtils.isEmail(value)){
                            return "please enter email";

                          }
                        },
                          controller: loginController.emailEditingController,
                          labelText: "Email",
                          icon: Icons.email_outlined)),
                  new Container(
                      margin: EdgeInsets.only(top: 10),
                      child: TextFieldWidget(
                        validator: (String value){
                          if(value.isEmpty){
                            return "please enter password";
                          }else if(value.length<8){
                            return "password in not correct";
                          }
                        },
                        controller: loginController.passwordEditingController,
                        labelText: "password",
                        icon: Icons.lock_outline,
                        obscureText: true,
                        suffixIcon: Icons.visibility_off,
                      )),
                  new Container(
                    margin: EdgeInsets.only(top: 10),
                    child: new Text(
                      'Forget Password',
                      style: new TextStyle(color: mediumBlue),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    height: 55,
                    child: ProgressButton(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      strokeWidth: 2,
                      color: mediumBlue,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      onPressed: (AnimationController controller) async{
                       if(_formKey.currentState.validate()){
                         controller.forward();
                         await loginController.login(loginController.passwordEditingController.text, loginController.emailEditingController.text);
                         controller.reverse();
                       }
                      },
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 15, bottom: 20),
                    child: ButtonWidget(
                      title: "Sign Up",
                      hasBorder: true,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
