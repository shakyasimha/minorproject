import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'login.dart';
import 'dart:core';



class table2 extends StatefulWidget {

  @override
  _table2State createState() => _table2State();
}

class _table2State extends State<table2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('HeartRate(in bpm)'),
            ),
            DataColumn(
              label: Text('Spo2(in %)'),
            ),
            DataColumn(
              label: Text('Time'),
            ),
          ],
          rows: [
            DataRow(cells: [
              DataCell(
                Text('2'),
              ),
              DataCell(
                Text('3'),
              ),
              DataCell(
                Text('4'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
