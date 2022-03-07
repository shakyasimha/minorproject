import 'package:flutter/material.dart';
import 'aftersignup.dart';
import 'afterlogin.dart';
import 'login.dart';

import 'hnspO2table.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
    initialRoute: 'initial',
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
      'initial': (context) => Login(),

      'table2': (context) => HRN()


    },//routes for differnet pages in the app
  ));
}