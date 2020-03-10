import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collectionGroup("ReportedUsers").where("postName").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {  
        if (snapshot.hasData) {
          final docs = snapshot.data.documents.where((doc) => doc["postName"] != null).toList();
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(docs[index]["postName"] ?? "N/A");
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
