import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prototype/afterlogin.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Htable extends StatefulWidget {
  String usname;
  Htable({Key mykey,this.usname}) ;

  @override
  _HtableState createState() => _HtableState();
}

class _HtableState extends State<Htable> {
  bool dataloaded = false;
  var data;
  void initState() {
    loaddata();
    //calling loading of data
    super.initState();
  }

  void loaddata() {
    Future.delayed(Duration.zero, () async {
      String u = widget.usname;
      String dataurl = 'https://arjunpoudel122.com.np/sendjsondata.php?username=' +
          u ;
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
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Color.fromARGB(0xFF, 0x5D, 0x6D, 0x7E),
         appBar: AppBar(
             backgroundColor: Color.fromARGB(0xFF, 0x2E, 0x40, 0x53),
           title: Text('Heart Rate/Spo2 Table'),
         ),
        body: Container(


          child: Container(
            padding: EdgeInsets.all(15),
            child: dataloaded? datalist(): //to check whether the data is loaded from the server if the data is loaded then show the table else show a circular progress indicator
                Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
      onWillPop: () {
        _move();
      },
    );
  }

  Widget datalist() {
    var a = data['totalpatientdata']['healthdata']['hrnspo3'];
    print(a.length);

    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(
            label: Text(
                'HR(bpm)',
                style: TextStyle(
                  color: Colors.white,
                ),
            ),
          ),
          DataColumn(
            label: Text(
                'Spo2(%)',
                style: TextStyle(
                  color: Colors.white,
                ),
            ),
          ),
          DataColumn(
            label: Text(
              'Time(ago)',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],

        rows: [
          for(int i = 0; i < a.length; i++)
            DataRow(
              cells: [
                DataCell(
                  Text(
                      a[i]['heartrate'],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                  ),
                ),
                DataCell(
                  Text(
                      a[i]['spo3'],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                ),
                DataCell(
                  Text(
                    a[i]['timee'],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                ),

              ],

            ),

        ],

      ),


    );
  }

  Future <String> showfulldata() async {
    return Future.delayed(

      Duration(milliseconds: 10),
      abc,

    );
  }

  Future <String> abc() async {
    String ua = widget.usname;
    String dataurl = 'https://arjunpoudel122.com.np/sendjsondata.php?username=' +
        ua;
    var res = await http.post(Uri.parse(dataurl));
    if (res.statusCode == 200) {
      setState(() {
        data = json.decode(res.body);
        dataloaded = true;
        print(res.body);
        print('printing from the table');
        datalist();
      });
    }
    else {
      return 'Error';
    }
  }
  void _move()=>  Navigator.push(context, MaterialPageRoute(
    builder: (context) => MyLogin(username: widget.usname),),);
//override the back button in mobile
}
