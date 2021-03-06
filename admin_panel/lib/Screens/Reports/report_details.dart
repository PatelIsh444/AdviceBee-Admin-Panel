import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportDetails extends StatelessWidget {
  final DocumentSnapshot element;
  ReportDetails(this.element);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _generateUserDisplayName(element),
                  SizedBox(height: 8),
                  _generateReportedPostTitle(element),
                  SizedBox(height: 24),
                  _generateUsersWhoReportedLIst(),
                ],
              )
            ),
          ),
          SizedBox(height: 8),
          _generateActionRow(context, element)
        ],
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
              fontSize: 16,
              color: Colors.black45
            ),
          );
        }
        else {
          return Text(
            "Loading post creator's name...",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 18,
              color: Colors.grey
            ),
          );
        }      
      }, 
    );
  }

  Widget _generateReportedPostTitle(DocumentSnapshot element) {
    return Text(
      element["postTitle"],
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 25,
      ),
    );
  }

  Widget _generateUsersWhoReportedLIst() {
    return StreamBuilder(
      stream: Firestore.instance.collection('reports').document(element.documentID).collection('ReportedUsers').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<Widget> children = [
            Text(
              "Report By:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 4,)
          ];
          
          snapshot.data.documents.forEach((e) {
            String name = e.data["userDisplayName"];
            String reasons = (e.data["reasons"] as List).join(" & ");
            String date = DateFormat('MMMM d, yyyy').format(new DateTime.fromMillisecondsSinceEpoch((e.data["dateReported"] as Timestamp).toDate().toLocal().millisecondsSinceEpoch));

            children.add(
              Row(
                children: <Widget>[
                  Expanded(
                    child: AutoSizeText("$name for $reasons on $date")
                  ),
                ]
              )
            );
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
          );
        }
        else {
          return Text("Loading users who reported this post...");
        }
      }
    );
  }

  Widget _generateActionRow(BuildContext context, DocumentSnapshot element) {
    Future<void> deleteReportAndDismissPopup() async{
        element.reference.delete();
        // Dismiss the AlertDialog and the ReportDetails widget as well.
        Navigator.of(context).pop(true);
        Navigator.of(context).pop(true);
    }

    return Wrap(
      children: <Widget>[
       _createActionButton(
         context,
         "Hide Post",
         "Are you sure you wish to hide this post?",
          () async {
            await _hidePost(element);
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          },
          () {
            Navigator.of(context).pop(false);
          }
        ),
       _createActionButton(
         context,
         "Ignore Report",
         "Are you sure you wish to ignore this report?",
          () async {
            await _ignorePost(element);
            await _removeReporterUserIdFromReportedPostData(element);
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          },
          () {
            Navigator.of(context).pop(false);
          }
        ),
        _createActionButton(
         context,
         "Delete Post",
         "Are you sure you wish to delete this post?",
          () async {
            await _deletePost(element);
            await deleteReportAndDismissPopup();
          },
          () {
            Navigator.of(context).pop(false);
          }
        ),
       _createActionButton(
         context,
         "Delete User",
         "Are you sure you wish to delete this user?",
          () async {
            await Firestore.instance.collection("users").document(element.data["postCreatedBy"]).delete();
            await deleteReportAndDismissPopup();
          },
          () {
            Navigator.of(context).pop(false);
          }
        ),
      ],
    );
  }

  Padding _createActionButton(BuildContext context, String buttonText, String confirmationDescription, void Function() onConfirmPressed, void Function() onCancelPressed) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: RaisedButton(
          child: Text(buttonText),
          onPressed: () {
            showDialog(
              context: context,
              child: AlertDialog(
                title: Text("Confirm"),
                content: Text(confirmationDescription),
                actions: <Widget>[
                  FlatButton(
                    child: Text(buttonText),
                    onPressed: onConfirmPressed
                  ),
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: onCancelPressed
                  ),
                ],
              )
            );
          }
        ),
      );
  }

  Future<void> _hidePost(DocumentSnapshot reportedPost) async {
    reportedPost.reference.updateData({
      'postInReview': true
    });

    String postLocation = reportedPost.data["postLocation"];
    String collection = postLocation == "topics" ? "topics" : "groups";
    String subCollection = postLocation == "topics" ? "topicQuestions" : "groupQuestions";

    Firestore.instance
      .collection(collection)
      .document(reportedPost.data["postLocationId"])
      .collection(subCollection)
      .document(reportedPost.documentID).updateData({
        'postInReview': true
      });
  }

  Future<void> _deletePost(DocumentSnapshot reportedPost) async {
    String postLocation = reportedPost.data["postLocation"];

    if (postLocation == "topics") {
      _deletePostInTopicsCollection(reportedPost);
    }
    else {
      _deletePostInGroupsCollection(reportedPost);
    }
  }

  Future<void> _ignorePost(DocumentSnapshot reportedPost) async {
    reportedPost.reference.updateData({
      "previouslyReviewed": true
    });
  }

  Future<void> _removeReporterUserIdFromReportedPostData(DocumentSnapshot reportedPost) async {
    String collection = reportedPost.data["postLocation"] == "topics" ? "topics" : "groups";
    String subCollection = reportedPost.data["postLocation"] == "topics" ? "topicQuestions" : "groupQuestions";
    List<String> usersWhoReported = [];

    await reportedPost.reference.collection("ReportedUsers").getDocuments().then((value) => usersWhoReported = value.documents.map((e) => e.documentID).toList());

    Map<String, bool> reportsMap = Map.fromIterable(usersWhoReported, key: (userUid) => userUid, value: (item) => false);

    Firestore.instance
      .collection(collection)
      .document(reportedPost.data["postLocationId"])
      .collection(subCollection)
      .document(reportedPost.documentID).updateData({
        "reports" : reportsMap
      });
  }

  void _deletePostInTopicsCollection(DocumentSnapshot reportedPost) async {
    Firestore.instance
      .collection("topics")
      .document(reportedPost.data["postLocationId"])
      .collection("topicQuestions")
      .document(reportedPost.documentID)
      .delete();
  }

  void _deletePostInGroupsCollection(DocumentSnapshot reportedPost) async {
    Firestore.instance
      .collection("groups")
      .document(reportedPost.data["postLocationId"])
      .collection("groupQuestions")
      .document(reportedPost.documentID)
      .delete();
  }
}
