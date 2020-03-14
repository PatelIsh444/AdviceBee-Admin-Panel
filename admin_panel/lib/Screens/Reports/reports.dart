import 'package:auto_size_text/auto_size_text.dart';
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

  SingleChildScrollView _generateGrid(AsyncSnapshot<QuerySnapshot> snapshot) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: snapshot.data.documents.map((element) {
          return _generateReportCell(element);
        }).toList()
      ),
    );
  }

  Container _generateReportCell(DocumentSnapshot element) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
      width: 450,
      height: 175,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _generateReportedPostHeader(element),
            SizedBox(height: 8),
            _generateUserDisplayName(element),
            _generateActionRow(element)
          ]
        )
      )
    );
  }

  Expanded _generateReportedPostHeader(DocumentSnapshot element) {
    return Expanded(
      child: AutoSizeText(
        element["postTitle"] ?? "N/A",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 25,
        ),
      ),
    );
  }

  Widget _generateUserDisplayName(DocumentSnapshot element) {
    return FutureBuilder(
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
    );
  }

  Widget _generateActionRow(DocumentSnapshot element) {
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
            onPressed: () {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text("Confirm"),
                  content: Text("Are you sure you wish to delete this item?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("DELETE"),
                      onPressed: () async {
                        await element.reference.delete();
                        Navigator.of(context).pop(true);
                      } 
                    ),
                    FlatButton(
                      child: Text("CANCEL"),
                      onPressed: () => Navigator.of(context).pop(false)
                    ),
                  ],
                )
              );
            },
          ),
        )
      ],
    );
  }
}

