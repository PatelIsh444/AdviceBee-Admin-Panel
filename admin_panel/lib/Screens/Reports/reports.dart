import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("reports").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {  
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            padding: const EdgeInsets.all(4.0),
            itemCount: snapshot.data.documents.length,
            
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.white,
                width: 50,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(snapshot.data.documents[index]["postTitle"] ?? "N/A"),
                      SizedBox(height: 8),
                      FutureBuilder(
                        future: Firestore.instance.collection('users').document(snapshot.data.documents[index]["postCreatedBy"]).get(), 
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {  
                          if (snapshot.hasData) {
                            return Text(snapshot.data.data["displayName"]);
                          }
                          else {
                            return Text("Loading post creator's name");
                          }
                        }, 
                      )
                    ],
                  )
                ) 
              );
            }
          );
        }
        else {
          return Text("Loading...");
        }
      }, 
    );
  }
}
