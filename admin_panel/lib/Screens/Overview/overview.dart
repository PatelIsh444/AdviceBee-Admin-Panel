import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: Container(
              color: Colors.white,
              width: 150,
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Reports",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 20,
                        color: Colors.grey
                      ),
                    ),
                    SizedBox(height: 8),
                    StreamBuilder(
                      stream: Firestore.instance.collectionGroup("ReportedUsers").snapshots(), 
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        final style = TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 38
                        );

                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data.documents.length.toString(),
                            style: style,
                          );
                        }
                        else {
                          return Text(
                            "--",
                            style: style,
                          );
                        }
                      },
                    )
                  ],
                )
              ) 
            ),
          )
        ],
      )
    );
  }
}
