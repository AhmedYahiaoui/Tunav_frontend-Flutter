import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tunav/Services/DatabaseHelper.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:tunav/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _key= GlobalKey<FormState>();

  bool t3ada = false;
  bool faregh = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
// **********************************   the half
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/login/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/login/light-1.png'))),
                        ),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/login/light-2.png'))),
                        )
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/login/clock.png'))),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(30.0),

                  child: Column(

                    children: <Widget>[


                      textSection(),

                      SizedBox(height: 30,),

                      buttonSection(),

                      SizedBox(height: 70,),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'If you don"t have an account you can ',
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: ' Sign up',
                                style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                                recognizer: TapGestureRecognizer()
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));

  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();


  DatabaseHelper databaseHelper2 = new DatabaseHelper();

  void _doSomething() async {
    Timer(Duration(seconds: 1), () {

      _btnController.stop();

      if(_key.currentState.validate())
      {
        signIn(emailController.text, passwordController.text);
//            databaseHelper2.loginData(emailController.text, passwordController.text);
        _btnController.stop();
      }
    });
  }




  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass};
    var jsonResponse = null;
    var response = await http.post(
        databaseHelper2.serverUrl+"/user/login",
        body: data
    );
    log(response.statusCode);
    print('statusCode  :' + response.statusCode.toString());

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          t3ada = true;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        print(jsonResponse['User'].toString());


        await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => MyApp()),
                (Route<dynamic> route) => false);
      }
    }
    else {
      var data = json.decode(response.body);

      if (data['message']=="Email Does not Exists"){
        await Fluttertoast.showToast(
            msg: "Email Does not Exists . ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0
        );
      }else if (data['message']=="Wrong Password") {
        await Fluttertoast.showToast(
            msg: "Wrong Password . ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0
        );
      }

      print(response.body);
    }
  }
  buttonSection() {
    return Container(
      height: 50,
      child: AspectRatio(
        child: RoundedLoadingButton(
          color: HexColor('#54D3C2'),
          child: Text("Login", style: TextStyle(color: Colors.white)),
          controller: _btnController,
          onPressed: _doSomething,
        ),
        aspectRatio: 8,
      ),
    );
  }

  textSection() {
    return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(143, 148, 251, .2),
                  blurRadius: 20.0,
                  offset: Offset(0, 10))
            ]),
        child : Form(
          key: _key,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border:
                    Border(bottom: BorderSide(color: Colors.grey[100]))),
                child: TextFormField(
                  validator: (value){
                    if (value.isEmpty){
                      return " Mail can not be empty";
                    }else if (value.length <= 5)
                    {
                      return"User name should be greater then 5";
                    }else
                      return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.email, color: Colors.grey[400]),
                      border: InputBorder.none,
                      hintText: "Email or Phone number",
                      hintStyle: TextStyle(color: Colors.grey[400])),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) =>
                  value.isEmpty ? 'Password cannot be blank' : null,
                  controller: passwordController,
//                    obscureText: true,
                  obscureText: !_passwordVisible,//This will obscure text dynamically
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.lock, color: Colors.grey[400]),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),

                  ),
                ),
              )
            ],
          ),
        )
    );
  }

}


class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

