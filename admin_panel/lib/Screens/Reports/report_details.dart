import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                  _generateUserDisplayName(element),
                  SizedBox(height: 8),
                  _generateReportedPostTitle(element),
                  SizedBox(height: 24),
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

    Widget _generateUserDisplayName(DocumentSnapshot element) {
    return FutureBuilder(
      future: Firestore.instance.collection('users').document(element["postCreatedBy"]).get(), 
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {  
        if (snapshot.hasData) {
          return Text(
            "Posted By: " + snapshot.data.data["displayName"],
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 16,
              color: Colors.black45
            ),
          );
        }
        else {
          return Text(
            "Loading post creator's name...",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 18,
              color: Colors.grey
            ),
          );
        }      
      }, 
    );
  }

  Widget _generateReportedPostTitle(DocumentSnapshot element) {
    return Text(
      element["postTitle"],
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 25,
      ),
    );
  }

  Widget _generateUsersWhoReportedLIst() {
    return StreamBuilder(
      stream: Firestore.instance.collection('reports').document(element.documentID).collection('ReportedUsers').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<Widget> children = [
            Text(
              "Report By:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 4,)
          ];
          
          snapshot.data.documents.forEach((e) {
            String name = e.data["userDisplayName"];
            String reasons = (e.data["reasons"] as List).join(" & ");
            String date = DateFormat('MMMM d, yyyy').format(new DateTime.fromMillisecondsSinceEpoch((e.data["dateReported"] as Timestamp).toDate().toLocal().millisecondsSinceEpoch));

            children.add(
              Row(
                children: <Widget>[
                  Text("$name for $reasons on $date"),
                ]
              )
            );
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
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
