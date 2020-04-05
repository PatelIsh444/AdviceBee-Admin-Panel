import 'package:admin_panel/Screens/Reports/report_cell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  Sort sort = Sort.lastReported;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("reports").orderBy(sort.key, descending: sort.isDecending).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {  
        if (snapshot.hasData) {
          return _generateReportsView(snapshot);
        }
        else {
          return _generateLoadingIndicator();
        }
      }, 
    );
  }

  Widget _generateLoadingIndicator() {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 48),
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text("Loading Reports..."),
        ],
      )
    );
  } 

  Widget _generateReportsView(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "Report",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 38
              ),
            ),
            SizedBox(width: 50,),
            Text("Sort: "),
            DropdownButton<Sort>(
              value: sort,
              items: <DropdownMenuItem<Sort>>[
                DropdownMenuItem(
                  child: Text("Recently Reported"),
                  value: Sort.lastReported,
                ),
                DropdownMenuItem(
                  child: Text("Most Reports"),
                  value: Sort.numberOfReports,
                )
              ], 
              onChanged: (value) {  
                setState(() => this.sort = value);
              },
            )
          ],
        ),
        SizedBox(height: 18),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              children: snapshot.data.documents.map((element) {
                return ReportCell(element);
              }).toList()
            ),
          ),
        ),
      ],
    );
  }
}

class Sort {
  static Sort numberOfReports = Sort('numberOfReports', true);
  static Sort lastReported = Sort('lastReported', true);
  
  String key;
  bool isDecending;

  Sort(this.key, this.isDecending);
}
