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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _generateUsersWhoReportedLIst(),
                ],
              )
            ),
          ),
          SizedBox(height: 8),
          _generateActionRow(context, element)
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

  Widget _generateActionRow(BuildContext context, DocumentSnapshot element) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8),
          child: RaisedButton(
            child: Text("Ignore Report"),
            onPressed: () {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text("Confirm"),
                  content: Text("Are you sure you wish to ignore this report?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("IGNORE"),
                      onPressed: () async {
                        await element.reference.delete();
                        // Dismiss the AlertDialog and the ReportDetails widget as well.
                        Navigator.of(context).pop(true);
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
            }
          ),
        ),
      ],
    );
  }
}
