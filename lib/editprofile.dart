import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Edit extends StatefulWidget {
String us;
Edit ({Key key , this.us}) : super(key: key);


  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  bool hidepassword = true;
  bool hidenpassword = true;
  final TextEditingController passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  var data;
  final TextEditingController _passnew = TextEditingController();
  bool dataloaded = false ;
   @override
      void initstate() {
     loadimmediatedata();
     super.initState();
   }
  
  void loadimmediatedata() {
    Future.delayed(Duration.zero, () async {
      String u = widget.us;
      String dataurl = 'https://arjunpoudel122.com.np/receivejsondata.php';
      var res = await http.post(Uri.parse(dataurl));
      if (res.statusCode == 200) {
        setState(() {
          data = json.decode(res.body);
          dataloaded = true;
          print(res.body);
          print('printing from the table');
          // we set dataloaded to true,
          // so that we can build a list only
          // on data load
        });
      } else {
        //there is error
        print(res.statusCode);

      }
    });
    // we use Future.delayed becuase there is
    // async function inside it.
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey,
      appBar: AppBar(

        centerTitle: true,
        title: Text('Profile'),

      ),

      body: Container(

        padding: EdgeInsets.all(20),


        child: Form(

          child: ListView(

            children: [
               Padding(
                padding: const EdgeInsets.only(top:50, left: 50,right: 50),
                child: TextFormField(
                  controller: _pass,
                  validator: validateoldpassword,
                  keyboardType: TextInputType.name,
                  obscureText: hidepassword,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      suffixIcon: InkWell(
                        onTap: () {
                          hiddenpassword();
                        },
                        child: Icon(
                          hidepassword
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
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only( left: 50,right: 50),
                child: TextFormField(
                  controller: _passnew,
                  validator: newpassword,
                  keyboardType: TextInputType.name,
                  obscureText: hidenpassword,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      suffixIcon: InkWell(
                        onTap: () {
                          hidennpassword();
                        },
                        child: Icon(
                          hidenpassword
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

                      hintText: "New PassWord",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
        SizedBox(
          height: 10,
        ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: ElevatedButton(child: Text('Change Password'),onPressed: () {
                      if(_formKey.currentState.validate()) {

                        return Alert(context: context,
                          style: AlertStyle(
                            isCloseButton: false,
                            isOverlayTapDismiss: false,
                          ),
                          title: 'You changed your password',
                          buttons: [
                            DialogButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.pushNamed(context, 'initial');
                              },
                            ),
                          ],
                        ).show();
                      }

                    },),
                  ),
                ],
              )

            ],
          ),
        ),

      ),



    );
  }



  void hiddenpassword() {
    setState(() {
      hidepassword = !hidepassword;
    });
  }

  void hidennpassword() {
    setState(() {
      hidenpassword = !hidenpassword;
    });
  }

  String validateoldpassword(String value) {
    if (value == null||value.length==0) {
      return 'Please Enter Your Old Password';
    }
    else {
      return null;
    }
  }



  String newpassword (String value) {
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
      return "Password must be at least 8 characters";
    } else {
      return null;
    }
  }



}

