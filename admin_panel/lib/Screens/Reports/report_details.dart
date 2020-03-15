import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportDetails extends StatelessWidget {
  final DocumentSnapshot element;
  ReportDetails(this.element);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _generateUsersWhoReportedLIst(),
                ],
              )
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            onPressed: () {  },
            child: Text("Buttttton"),
          )
        ],
      ),
    );
  }

  Widget _generateUsersWhoReportedLIst() {
    return StreamBuilder(
      stream: Firestore.instance.collection('reports').document(element.documentID).collection('ReportedUsers').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data.documents.map((e) {
              return Row(
                children: <Widget>[
                  Text("Reported By: " + e.data["userDisplayName"] + " for " + (e.data["reasons"] as List).join(" & ")),
                ]
              );
            }).toList(),
          );
        }
        else {
          return Text("Loading users who reported this post...");
        }
      }
    );
  }
}
