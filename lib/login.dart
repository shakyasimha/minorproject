import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype/afterlogin.dart';
import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:core';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hiddenpassword = true;
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

   bool dataloaded=false;
   bool showspinner = false;
   bool checktheusername = false;
  final TextEditingController usernameController =TextEditingController();
  final TextEditingController _pass = TextEditingController();
  @override
  void dispose()
  {
    super.dispose();
  }

  Future Loginme() async
  {
    String _username = usernameController.text;
     String _password = _pass.text;

    var url = Uri.parse('https://arjunpoudel122.com.np/login.php?username='+_username+'&password='+_password);
//used to send the username and password to the server and check if it is valid
    http.Response response = await http.get(url);

    if(response.statusCode==200)
    {
      String message = response.body;
      Map <String,dynamic> abc = jsonDecode(message);

      if(abc['valid']==true) //true when username exist in server else it is false
      {
        print('User is valid');
        dataloaded=true;
        setState(() {
          showspinner=false;
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => MyLogin(username : usernameController.text),),);
          //push to dashboard page and send the obtained username

        });
      }
      else
      {
       showspinner=false;

        return Alert(context: context,title: 'Either Your Username or Password is incorrect',
          style: AlertStyle(
            isCloseButton: false,
          ),
          buttons: [
            DialogButton(child: Text('Retry'), onPressed: () {
              Navigator.pushNamed(context, 'initial');
            })
          ]
        ).show();
// When password or username is wrong alert is shown and redirected to the same page with all fields cleared



      }
      }

  }

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/login.png'), fit: BoxFit.fill,),

      ),

      child: WillPopScope( //used to override functionality of back button present in the phone
        child: Scaffold(

          backgroundColor: Colors.transparent,
          body: ModalProgressHUD(
            inAsyncCall: showspinner,
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.4),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:50,right:50),
                    child: TextFormField(
                      validator: validateusername,
                      controller: usernameController,
                      keyboardType: TextInputType.name,
                      autofocus: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(FontAwesomeIcons.user,color: Colors.grey,),
                          ),
                          filled: true,
                          hintText: "username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50,right: 50),
                    child: TextFormField(
                      controller: _pass,
                      validator: validatepassword,
                      keyboardType: TextInputType.name,
                      obscureText: hiddenpassword,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          suffixIcon: InkWell(
                            onTap: () {
                              password();
                            },
                            child: Icon(
                              hiddenpassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.blue,
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(FontAwesomeIcons.lock,color: Colors.grey,),
                          ),
                          filled: true,

                          hintText: "PassWord",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showspinner = true;
                                Loginme();

                              });


                            },
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                    ],

                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'register');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Text(
                            'Sign Up',
                            textAlign: TextAlign.left,
                            style: TextStyle(

                                color: Color(0xff4c505b),
                                fontSize: 18),
                          ),
                        ),
                        style: ButtonStyle(),
                      ),

                    ],

                  )
                ],
            ),
              ),
            ),
          ),
    ),
        onWillPop: () {
          _move(); //asks if you want to exit the app
        },
      ),
    );

  }
  void password() {
    setState(() {
      hiddenpassword=!hiddenpassword;
    });
  } //eye button functinality

  String validateusername(String value){
    if(value.isEmpty)
    {
      return 'Please Fill Your Username';
    }

  }//validates username i.e it cannot be empty
  String validatepassword(String value){
    if(value.isEmpty)
    {
      return 'Please Fill Your Password';
    }

  }//validates password i.e. it cannot be empty

  void _move() => Navigator.pushNamed(context, 'initial'); //pushes to initial page
}