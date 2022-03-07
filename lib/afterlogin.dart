import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prototype/temperature.dart';
import 'package:http/http.dart' as http;
import 'editprofile.dart';
import 'hnspO2table.dart';
import 'fulltemptable.dart';
import 'dart:async';

class MyLogin extends StatefulWidget {
 String username; // an variable to hold username obtained from login screen and shows dashboard accordingly
 MyLogin ({Key key , this.username}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  var data;
  bool dataloaded = false;
  int _currentindex = 0;

  @override
  void initState() {
    loadimmediatedata();
    test();
    //calling loading of data
    super.initState();
  }

  Future<bool> _onWillPop() async { //used to override function of back button of mobile
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the App'),
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


  void loadimmediatedata() {
    Future.delayed(Duration.zero, () async {
      String u = widget.username;
      String dataurl = 'https://arjunpoudel122.com.np/sendjsondata.php?username=' +
          u;
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

      backgroundColor: Color.fromARGB(0xFF, 0x5D, 0x6D, 0x7E), // #AF7AC5
      appBar: AppBar(
        leading: IconButton(icon: Icon(FontAwesomeIcons.bars),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Edit(us : widget.username),),);
          },
        ),
        centerTitle: true,
        title: Text('DashBoard'),
        backgroundColor: Color.fromARGB(0xFF, 0x2E, 0x40, 0x53),
      ),

      body: RefreshIndicator(
        onRefresh: test,
        child: Container(

          padding: EdgeInsets.all(20),
          //check if data is loaded, if loaded then show datalist on child
          child: dataloaded ? card() :

          Center( //if data is not loaded then show progress
              child: CircularProgressIndicator()
          ),


        ),

      ),
//bottom navigation bars
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        type: BottomNavigationBarType.fixed,

        backgroundColor: Color.fromARGB(0xFF, 0x2E, 0x40, 0x53),
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,

            icon: TextButton(child: Icon(

                FontAwesomeIcons.home, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    MyLogin(username: widget.username),),);
              },
            ),

            label: 'Home',

          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,

            icon: TextButton(child: Icon(
                FontAwesomeIcons.thermometerEmpty, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    Temperature(usname: widget.username),),);
              },
            ),

            label: 'Temp',

          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: TextButton(child: Icon(Icons.bloodtype, color: Colors.white,),

              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HRN(usename: widget.username),),);
              },
            ),
            label: 'HRNSPO2',


          ),

          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: TextButton(child: Icon(FontAwesomeIcons.table, color: Colors.white,),

              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => FullTemp(ut : widget.username),),);
              },
            ),
            label: 'Records',


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

    ), onWillPop: _onWillPop);

  }
//returns card
  Widget card() {
    var a = data['totalpatientdata']['healthdata']['temperature'];
    var b = data['totalpatientdata']['healthdata']['hrnspo3'];
    print(a.length);
    return RefreshIndicator(
      onRefresh: test,
      child: SingleChildScrollView(
          child: Column(
          children: [
            Card(
              elevation: 20,
              color: Colors.white,
              margin: EdgeInsets.all(20.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.heartbeat,
                  ),
                  title: Text(b[0]['heartrate']), // it holds the most recent data and display it
                ),
              ),
            ),
            Card(
              elevation: 20,
              color: Colors.white,
              margin: EdgeInsets.all(20.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ListTile(
                  leading: Icon(
                    Icons.bloodtype,
                  ),
                  title: Text(b[0]['spo3']),
                ),
              ),
            ),
            Card(

              elevation: 20,
              color: Colors.white,
              margin: EdgeInsets.all(20.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.thermometer,
                  ),
                  title: Text(a[0]['valuee']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
Future<String> test () async {
    return Future.delayed(
      Duration(microseconds: 10),
      cde,
    );
}

Future <String> cde() async {
  String ua = widget.username;
  String dataurl = 'https://arjunpoudel122.com.np/sendjsondata.php?username=' +
      ua;
  var res = await http.post(Uri.parse(dataurl));
  if (res.statusCode == 200) {
    setState(() {
      data = json.decode(res.body);
      dataloaded = true;
      print(res.body);
      print('printing from the table');
      card();

    });
  }
  else {
    return 'Error';
  }
}
}
