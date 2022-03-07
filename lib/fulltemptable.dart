import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prototype/afterlogin.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'FullTable.dart';
import 'afterlogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FullTemp extends StatefulWidget {
  String ut;
   FullTemp({Key mykey ,this.ut});

  @override
  _FullTempState createState() => _FullTempState();
}

class _FullTempState extends State<FullTemp> {
  bool error = false,
      dataloaded = false;
  var data;
  int _currentindex = 0;
  void initState() {
    loaddata();
    //calling loading of data
    super.initState();
  }

  void loaddata() {
    Future.delayed(Duration.zero, () async {
      String u = widget.ut;
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
          title: Text("Temperature Table"), //title of app
          backgroundColor: Color.fromARGB(0xFF, 0x2E, 0x40, 0x53),
        ),
        body: RefreshIndicator(
          onRefresh: showfulldata,
          color: Colors.blue,

          child: Container(

            padding: EdgeInsets.all(15),
            //check if data is loaded, if loaded then show datalist on child
            child: dataloaded ? datalist() :

            Center( //if data is not loaded then show progress
                child: CircularProgressIndicator()
            ),


          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentindex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(0xFF, 0x2E, 0x40, 0x53),
          items: [
            BottomNavigationBarItem(
              icon: TextButton(child: Icon(FontAwesomeIcons.table, color: Colors.white,),

                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FullTemp(ut : widget.ut),),);
                },
              ),
              label: 'Temp Records',


            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: TextButton(child: Icon(FontAwesomeIcons.table, color: Colors.white,),

                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Htable(usname : widget.ut),),

                  );
                },
              ),
              label: 'HRNSPO2 Records',


            ),
          ],
          selectedLabelStyle: TextStyle(fontSize: 15),
          selectedItemColor: Colors.white,
          unselectedLabelStyle: TextStyle(fontSize: 12),
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentindex = index;
            });
          },
        ),


      ),
      onWillPop: () {
        _move();
      }
    );
  }
  Widget datalist() {
    var a = data['totalpatientdata']['healthdata']['temperature'];
    print(a.length);

    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(
            label: Text(
                'Temperature(°F)',
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
                      a[i]['valuee'],
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
    String ua = widget.ut;
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
    builder: (context) => MyLogin(username: widget.ut),),);
}
