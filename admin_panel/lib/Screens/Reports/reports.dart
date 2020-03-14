import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  bool isHovering = false;
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

  Wrap _generateGrid(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: snapshot.data.documents.map((element) {
        return _generateReportCell(element);
      }).toList()
    );
  }

  Container _generateReportCell(DocumentSnapshot element) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: isHovering ? kElevationToShadow[1] : [],
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
      width: 300,
      height: 150,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: AutoSizeText(
                element["postTitle"] ?? "N/A",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
                // maxLines: 1,
              ),
            ),
            SizedBox(height: 8),
            FutureBuilder(
              future: Firestore.instance.collection('users').document(element["postCreatedBy"]).get(), 
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {  
                if (snapshot.hasData) {
                  return Text(
                    "Posted By: " + snapshot.data.data["displayName"],
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      color: Colors.grey
                    ),
                  );
                }
                else {
                  return Text(
                    "Loading post creator's name",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      color: Colors.grey
                    ),
                  );
                }
              }, 
            ),
            _generateActionRow()
          ]
        )
      )
    );
  }

  Row _generateActionRow() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8),
          child: RaisedButton(
            child: Text("View"),
            onPressed: () => print("View Tapped"),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: RaisedButton(
            child: Text("Delete"),
            onPressed: () => print("Delete Tapped"),
          ),
        )
      ],
    );
  }
}

