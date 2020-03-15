import 'package:admin_panel/Screens/Reports/report_details.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportCell extends StatelessWidget {
  final DocumentSnapshot element;

  ReportCell(this.element);

  @override
  Widget build(BuildContext context) {
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
            _generateActionRow(context, element)
          ]
        )
      )
    );
  }

  Widget _generateReportedPostHeader(DocumentSnapshot element) {
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

  Widget _generateActionRow(BuildContext context, DocumentSnapshot element) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8),
          child: RaisedButton(
            child: Text("View"),
            onPressed: () {
              showDialog(
                context: context,
                child: AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: SizedBox(
                    width: 500,
                    height: 500,
                    child: ReportDetails(element)
                  ),
                )
              );
            }
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

