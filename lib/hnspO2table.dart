import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HRN extends StatefulWidget {
  String usename;
  HRN({@required this.usename});

  @override
  _HRNState createState() => _HRNState();
}

class _HRNState extends State<HRN> {
  bool error = false, dataloaded = false;

  var data;

  @override
  void initState() {
    loaddata();
    //calling loading of data
    super.initState();
  }

  void loaddata() {
    String u = widget.usename;
    String dataurl =
        'https://arjunpoudel122.com.np/sendjsondata.php?username=' + u+ '&r10=true';
    Future.delayed(Duration.zero, () async {
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
      backgroundColor: Color.fromARGB(0xFF, 0x5D, 0x6D, 0x7E), // #AF7AC5,
      appBar: AppBar(
        title: Text("Heart Rate/Spo2 Level"), //title of app
        backgroundColor: Color.fromARGB(0xFF, 0x2E, 0x40, 0x53),
      ),
      body: RefreshIndicator(
        onRefresh: showfulladata,
        color: Colors.blue,
        child: Container(
          padding: EdgeInsets.all(15),
          //check if data is loaded, if loaded then show datalist on child
          child: dataloaded
              ? datalist()
              :
          Center(
                  //if data is not loaded then show progress
                  child: CircularProgressIndicator()),
        ),
      ),


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
          for (int i = 0; i < a.length; i++)
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

  Future <String> showfulladata() async {
    return Future.delayed(

      Duration(milliseconds: 10),
      abc,

    );
  }

  Future <String> abc() async {
    String ua = widget.usename;
    String dataurl = 'https://arjunpoudel122.com.np/sendjsondata.php?username=' +
        ua+'&r10=true';
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
}
