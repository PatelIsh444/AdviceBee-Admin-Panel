import 'package:admin_panel/Screens/Overview/overview_user_groups_chart.dart';
import 'package:admin_panel/Screens/Overview/overview_user_posts_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'overview_detail.dart';
import 'overview_user_chart.dart';

class Overview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _generateOverview();
  }

  Widget _generateOverview() {
    return Container(
      child: ListView(
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
          SizedBox(height: 14),
          StreamBuilder(
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    OverViewUserChart(userData: _getRankData(snapshot)),
                    SizedBox(width: 18),
                    OverViewUserPostChart(usersPostedData: _getHasPostedData(snapshot)),
                    SizedBox(width: 18),
                    OverViewUserGroupChart(usersGroupData: _getUserGroupData(snapshot))
                  ]
                );
              }
              else if (snapshot.hasError) {
                return Text('Error getting number of reports.');
              }
              else {
                return Text('Loading...');
              }
            }
          )
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

  Map<String, int> _getRankData(AsyncSnapshot<QuerySnapshot> snapshot) {
    Map<String, int> data = {};

    snapshot.data.documents.forEach((element) {
      String rank = element.data["rank"];
      data.putIfAbsent(rank, () => 0);
      data[rank] = data[rank] + 1;
    });

    return data;
  }

  Map<String, int> _getHasPostedData(AsyncSnapshot<QuerySnapshot> snapshot) {
    Map<String, int> data = {};
    
    snapshot.data.documents.forEach((element) {
      List<dynamic> posts = element.data["myPosts"];
      String key = posts.isEmpty ? "Users who haven't posted" : "Users who have posted";
      data.putIfAbsent(key, () => 0);
      data[key] = data[key] + 1;
    });

    return data;
  }

  Map<String, int> _getUserGroupData(AsyncSnapshot<QuerySnapshot> snapshot) {
    Map<String, int> data = {};
    
    snapshot.data.documents.forEach((element) {
      List<dynamic> groups = element.data["joinedGroups"];
      String key = groups.isEmpty ? "Users who aren't in a group" : "Users who are in a group";
      data.putIfAbsent(key, () => 0);
      data[key] = data[key] + 1;
    });

    return data;
  }

}
