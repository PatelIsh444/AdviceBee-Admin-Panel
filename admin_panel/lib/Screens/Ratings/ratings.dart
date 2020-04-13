import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Ratings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collectionGroup('review').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return _buildLayout(snapshot.data.documents);
        }
        else {
          return Text("Loading...");
        }
      },
    );
  }

  Widget _buildLayout(List<DocumentSnapshot> documents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildOverViewRow(),
        SizedBox(height: 18),
        Expanded(
          child: _buildList(documents)
        )
      ],
    );
  }

  Widget _buildOverViewRow() {
    return Row(
      children: <Widget>[
        Text("Ratings")
      ]
    );
  }

  Widget _buildList(List<DocumentSnapshot> documents) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (BuildContext context, int index) {
        return Text(documents[index].data['name'] + ': ' + documents[index].data['message']);
      }
    );
  }
}
