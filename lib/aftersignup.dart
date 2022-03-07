import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';

import 'package:http/http.dart' as http;

class MyRegister extends StatefulWidget {
  @override
  _AfterSignupState createState() => _AfterSignupState();
}

class _AfterSignupState extends State<MyRegister> {
  bool hiddenpassword = true;
  bool visible = false ;
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  bool checktheusername = false;
  String _username;
  final TextEditingController nameController =TextEditingController();
  final TextEditingController addressController =TextEditingController();
  final TextEditingController ageController =TextEditingController();
  final TextEditingController mobileController =TextEditingController();
  final TextEditingController emailController =TextEditingController();
  final TextEditingController usernameController =TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  String gender;
  String selectgender;
  String _password;
  String mobilenumber;


Future registration () async {
  String name=nameController.text;
  String address=addressController.text;
  String age=ageController.text;
  String mobile=mobileController.text;
  String email=emailController.text;
  String username=usernameController.text;
  String password=_pass.text;



setState(() {
  visible=false;
});
@override
void initstate() {
  super.initState();
}

  var data = {'name': name,'address': address, 'age':age, 'gender':gender,'mobile': mobile,'email':email, 'username':username, 'password':password };
//used to send data to the server
  var url = Uri.parse('https://arjunpoudel122.com.np/register.php');

  http.Response response = await http.post(url, body: json.encode(data));

  if(response.statusCode==200)
    {
      String message = response.body;
      print(jsonDecode(message));
  }
  else
    {
      print(response.statusCode);
    }

}


  Future<bool> _onwillpop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Leave The Changes'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, 'initial'),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Center(
              child: Text('Register'),
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Form(

              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: SingleChildScrollView(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[


                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, top: 0),
                      child: TextFormField(
                        controller: nameController,
                        validator: validatefullname,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.name,
                        autofocus: true,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: TextFormField(
                        controller: addressController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.name,
                        autofocus: true,
                        validator: validateaddress,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Address',
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.locationArrow,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: TextFormField(
                        controller: ageController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 2,
                        validator: validateage,
                        autofocus: true,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Age',
                          fillColor: Colors.grey,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.calendar,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: DropdownButtonFormField(
                        items: [
                          DropdownMenuItem(
                              value: 'Male', child: Text('Male')),
                          DropdownMenuItem(
                              value: 'Female', child: Text('Female')),
                          DropdownMenuItem(
                              value: 'Others', child: Text('Others')),
                        ],
                        onChanged: (value) async {
                          setState(() {
                            gender = value;
                          });
                        },
                        value: gender,
                        validator: (value) =>
                            value == null ? 'Please fill in your gender' : null, //change value of gender when certain button is pressed
                        decoration: InputDecoration(
                          hintText: 'Gender',
                          contentPadding: EdgeInsets.only(left: 10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: TextFormField(
                        onChanged: checkusername ,
                        controller: mobileController,
                        validator: validatemobilenumber,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        autofocus: true,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.mobile,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: TextFormField(
                        controller: emailController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        validator: emailvalidate,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          fillColor: Colors.black,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: TextFormField(
                        controller: usernameController,
                        onChanged: checkusername,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.name,
                        autofocus: true,
                        validator: validateusername,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'UserName',
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),


                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: TextFormField(
                        controller: _pass,
                        obscureText: hiddenpassword,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.name,
                        validator: validatepassword,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'PassWord',
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.blue,
                            ),
                          ),
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
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: TextFormField(
                        controller: _confirmPass,
                        obscureText: hiddenpassword,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.name,
                        validator: validatepasswordnew,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Confirm PassWord',
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.blue,
                            ),
                          ),
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
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: TextButton(
                            onPressed: () {
                                if(_formKey.currentState.validate()) { //used to validate if all textformfields are correctly filled or not
                                  registration();
                                  return Alert(context: context,
                                    style: AlertStyle(
                                      isCloseButton: false,
                                      isOverlayTapDismiss: false,
                                    ),
                                    title: 'You are Sucessfully registered',
                                    buttons: [
                                      DialogButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.pushNamed(context, 'initial');
                                        },
                                      ),
                                    ],
                                  ).show();
                                }   // AboutWidget();
                                  //Navigator.pushNamed(context, 'initial');
                            },

                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ),

                        )
                      ],
                    ),
                    Row(
                      children: [
                        Visibility(
                          visible: visible,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],

                        )

                  ],


                ),

              ),

            ),

          ),

        ),
        onWillPop: _onwillpop,

      ),
    );
  }

  void password() {
    setState(() {
      hiddenpassword = !hiddenpassword;
    });
  }

  String validatefullname(String value) {
    String pattern = r'^[a-z A-Z]+$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter full name';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid full name';
    } else if (value.length > 25) {
      return 'Please enter valid full name';
    } else if (value.length < 5) {
      return 'Please enter valid full name';
    }
    return null;
  }

  String validateaddress(String value) {
    String pattern = r'^[a-z A-Z,0-9]+$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter address';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid address';
    } else if (value.length > 25) {
      return 'Please enter valid address';
    } else if (value.length < 5) {
      return 'Please enter valid full name';
    }
    return null;
  }

  String validateage(String value) {
    if (value.length == 0) {
      return 'Please enter your age';
    }
  }

  String validatgender(String value) {
    if (value.length == 0 || value == null) {
      return 'Please enter your gender';
    }
  }

  String emailvalidate(String value) {
    if (!EmailValidator.validate(value)) {
      return 'Please enter your email';
    } else {
      return null;
    }
  }

  String validatemobilenumber(String value) {

    String phonenumber = value;

      if (value.length == 10) {

      if(phonenumber[0]!='9' || phonenumber[1]!='8') //used to check whethet the phone number starts from 98 or not
        {
          return "Please provide valid number";
        }
      else{
        return null;
      }

    }
      else
        {
          return "Please provide valid number";
        }
  }

   String validateusername(String value)  { //used to validate the username and also check whether the username already exists or not

   // http.Response response = await http.post(url, body: json.encode(data));
    String pattern = r'^[a-zA-Z0-9]+$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0 || value == null) {
      return "Please provide username";
    } else if (!regExp.hasMatch(value)) {
      return "Please provide valid username";
    } else if (value.length != 5) {
      return "Username must be 5 characters";
    } else if(checktheusername==true)
      {
        return "Username Already Exists";
      }
    else {
      return null;
    }
  }

  String validatepassword(String value) { //used to define certain set of criteras for the password by pattern
    String pattern =
        (r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    RegExp regExp = RegExp(pattern);
    if (value.length == 0 || value == null) {
      return "Please fill your password";
    } else if (!regExp.hasMatch(value)) {
      return '''
      Password must be at least 8 characters,
      include an uppercase letter,number and symbol
      ''';
    } else if (value.length < 8) {
      return "Password must be atleast 8 characters";
    } else {
      return null;
    }
  }

  String validatepasswordnew(String value) {
    if (value.length == 0 || value == null) {
      return "Please fill your password";
    } else if (value != _pass.text) {
      return 'Password does not match';
    } else {
      return null;
    }
  }

  Future<String> checkusername(String value)
  async{ //used to check whether the username is already taken or not if taken dont allow it
    var url = Uri.parse('https://arjunpoudel122.com.np/validateusername.php?username='+value);
    print(url);
    var data = { 'username':value};
    http.Response response = await http.get(url);

    if(response.statusCode==200)
    {
      String message = response.body;
       Map <String,dynamic> abc = jsonDecode(message);

      if(abc['userexists']==1)
        {
          print('User Already Exists');
          checktheusername=true;
        }
      else
        {
          print('Success');
          checktheusername=false;
        }
    }
    else
    {
      print(response.statusCode);
    }
  }

}

