import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("reports").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {  
        if (snapshot.hasData) {
          return Wrap(
            children: snapshot.data.documents.map((element) {
              return MouseRegion(
                onEnter: (event) {
                  print("Enter");
                },
                onExit: (event) {
                  print("Exit");
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: Container(
                    color: Colors.white,
                    width: 250,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            element["postTitle"] ?? "N/A",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
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
                          )
                        ]
                      )
                    )
                  ),
                ),
              );
            }).toList()
          );
        }
        else {
          return Text("Loading...");
        }
      }, 
    );
  }
}
