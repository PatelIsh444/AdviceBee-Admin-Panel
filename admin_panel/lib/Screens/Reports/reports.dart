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
              return Container(
                color: Colors.white,
                width: 150,
                height: 100,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(element["postTitle"] ?? "N/A"),
                      SizedBox(height: 8),
                      FutureBuilder(
                        future: Firestore.instance.collection('users').document(element["postCreatedBy"]).get(), 
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {  
                          if (snapshot.hasData) {
                            return Text(snapshot.data.data["displayName"]);
                          }
                          else {
                            return Text("Loading post creator's name");
                          }
                        }, 
                      )    
                    ]              
                  )
                )
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
