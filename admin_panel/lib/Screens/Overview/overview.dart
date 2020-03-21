import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'overview_detail.dart';

class Overview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _generateOverview();
  }

  Widget _generateOverview() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Overview",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 35,
            )
          ),
          SizedBox(height: 12),
          _generateOverviewDetails(),
        ],
      )
    );
  }

  Widget _generateOverviewDetails() {
    return Wrap(
      spacing: 18,
      runSpacing: 18,
      alignment: WrapAlignment.start,
      children: <Widget>[
        StreamBuilder(
          stream: Firestore.instance.collection("reports").snapshots(), 
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            final String title = 'Reports';
            if (snapshot.hasData) {
              return OverviewDetail(title: title, detail: snapshot.data.documents.length.toString());
            }
            else if (snapshot.hasError) {
              return OverviewDetail(title: title, detail: 'Error getting number of reports.');
            }
            else {
              return OverviewDetail(title: title, detail: 'Loading...');
            }
          },
        ),
        StreamBuilder(
          stream: Firestore.instance.collection("users").snapshots(), 
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            final String title = 'Users';
            if (snapshot.hasData) {
              return OverviewDetail(title: title, detail: snapshot.data.documents.length.toString());
            }
            else if (snapshot.hasError) {
              return OverviewDetail(title: title, detail: 'Error getting number of users.');
            }
            else {
              return OverviewDetail(title: title, detail: 'Loading...');
            }
          },
        ),
        StreamBuilder(
          stream: Firestore.instance.collection("groups").snapshots(), 
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            final String title = 'Groups';
            if (snapshot.hasData) {
              return OverviewDetail(title: title, detail: snapshot.data.documents.length.toString());
            }
            else if (snapshot.hasError) {
              return OverviewDetail(title: title, detail: 'Error getting number of groups.');
            }
            else {
              return OverviewDetail(title: title, detail: 'Loading...');
            }
          },
        ),
        FutureBuilder(
          future: _calculateNumberOfPosts(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            final String title = 'Total Posts';
            if (snapshot.hasData) {
              return OverviewDetail(title: title, detail: snapshot.data.toString());
            }
            else if (snapshot.hasError) {
              return OverviewDetail(title: title, detail: 'Error getting number of groups.');
            }
            else {
              return OverviewDetail(title: title, detail: 'Loading...');
            }
          },
        ),
        StreamBuilder(
          stream: Firestore.instance.collectionGroup("topicQuestions").snapshots(), 
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            final String title = 'Topic Posts';
            if (snapshot.hasData) {
              return OverviewDetail(title: title, detail: snapshot.data.documents.length.toString());
            }
            else if (snapshot.hasError) {
              return OverviewDetail(title: title, detail: 'Error getting number of groups.');
            }
            else {
              return OverviewDetail(title: title, detail: 'Loading...');
            }
          },
        ),
        StreamBuilder(
          stream: Firestore.instance.collectionGroup("groupQuestions").snapshots(), 
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            final String title = 'Group Posts';
            if (snapshot.hasData) {
              return OverviewDetail(title: title, detail: snapshot.data.documents.length.toString());
            }
            else if (snapshot.hasError) {
              return OverviewDetail(title: title, detail: 'Error getting number of groups.');
            }
            else {
              return OverviewDetail(title: title, detail: 'Loading...');
            }
          },
        ),
      ],
    );
  }

  Future<int> _calculateNumberOfPosts() async {
    int topicPosts;
    int groupPosts; 
    await Firestore.instance.collectionGroup("topicQuestions").getDocuments().then((value) => topicPosts = value.documents.length);
    await Firestore.instance.collectionGroup("groupQuestions").getDocuments().then((value) => groupPosts = value.documents.length);

    return topicPosts + groupPosts;
  }
}
