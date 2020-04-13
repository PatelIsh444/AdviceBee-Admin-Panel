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
        _buildOverViewRow(documents),
        SizedBox(height: 18),
        Expanded(
          child: _buildList(documents)
        )
      ],
    );
  }

  Widget _buildOverViewRow(List<DocumentSnapshot> documents) {
    Map<String, int> map = {};
    documents.forEach((element) {
      String uid = element.data["userId"];
      map.putIfAbsent(uid, () => 0);
      map[uid] = map[uid] + 1;
    });

    int numberOfReviewers = map.keys.length;
    int numberOfReviews = map.values.reduce((value, element) => value += element);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Ratings",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 38
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            Text(
              'Reviews: $numberOfReviews',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20
              ),
            ),
            SizedBox(width: 15),
            Text(
              '|',
             style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20
              ),
            ),
            SizedBox(width: 15),
            Text(
              'Reviewers: $numberOfReviewers',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20
              ),
            )
          ],
        )
      ]
    );
  }

  Widget _buildList(List<DocumentSnapshot> documents) {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(
            label: Text(
              "Name",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20
              ),
            )
          ),
          DataColumn(
            label: Text(
              "Review",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20
              ),
            )
          ),
          DataColumn(
            label: Text(
              "Feedback",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20
              ),
            )
          ),
        ],
        rows: _generateRows(documents)
      )
    );
  }

  List<DataRow> _generateRows(List<DocumentSnapshot> documents) {
    List<DataRow> rows = [];
    documents.forEach((element) {
      rows.add(DataRow(
        cells: [
          DataCell(SingleChildScrollView(child: Text(element['name']))),
          DataCell(SingleChildScrollView(child: Text(element['type']))),
          DataCell(SingleChildScrollView(child: Text(element['message']))),
        ]
      ));
    });

    return rows;
  }
}
