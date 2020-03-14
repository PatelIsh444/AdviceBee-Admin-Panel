import 'package:admin_panel/Screens/Reports/report_cell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("reports").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {  
        if (snapshot.hasData) {
          return _generateGrid(snapshot);
        }
        else {
          return Text("Loading...");
        }
      }, 
    );
  }

  Widget _generateGrid(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Reports",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 35,
          )
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: snapshot.data.documents.map((element) {
              return ReportCell(element);
            }).toList()
          ),
        ),
      ],
    );
  }
}