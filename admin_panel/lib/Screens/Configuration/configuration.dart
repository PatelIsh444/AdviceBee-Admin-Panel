import 'package:admin_panel/Screens/Configuration/configuration_details.dart';
import 'package:admin_panel/Screens/Overview/overview_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Configuration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Daily Configuration",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 35,
            )
          ),
          SizedBox(height: 10),
          _generateConfigurationDetails(),
          SizedBox(height: 50),
          Text(
            "Payment Configuration",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 35,
            )
          ),
          SizedBox(height: 10),
          _generatePayConfigurationDetails(),
          SizedBox(height: 50),
          Text(
            "Rank Threshold Configuration",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 35,
            )
          ),
          SizedBox(height: 10),
          _generateRankThresholdConfigurationDetails()
        ],
      )
    );
  }

  Widget _generateConfigurationDetails() {
    return StreamBuilder(
      stream: Firestore.instance.collection("configuration").document("config").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _generateConfigRow(
            context,
            "Number of daily posts per rank:",
            "dailyQuestionsLimit",
             snapshot.data["dailyQuestionsLimit"]
          );
        }
        else {
          return Text("Loading...");
        }
      },
    );
  }

  Widget _generatePayConfigurationDetails() {
    return StreamBuilder(
      stream: Firestore.instance.collection("configuration").document("config").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _generateConfigRow(
            context,
            "Awarded number of questions after purchase",
            "awardedNumberOfQuestionsAfterPurchase",
            snapshot.data["awardedNumberOfQuestionsAfterPurchase"]
          );
        }
        else {
          return Text("Loading...");
        }
      },
    );
  }

    Widget _generateRankThresholdConfigurationDetails() {
    return StreamBuilder(
      stream: Firestore.instance.collection("configuration").document("config").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _generateConfigRow(
            context,
            "The number of points a user must achieve to reach that rank",
            "rankThresholds",
            snapshot.data["rankThresholds"]
          );
        }
        else {
          return Text("Loading...");
        }
      },
    );
  }

  Widget _generateConfigRow(BuildContext context, String description, String mapPropertyNameInDocument, Map<String, dynamic> map) {
    List<Widget> children = [];
    
    map.forEach((key, value) => children.add(OverviewDetail(title: key, detail: value.toString())));

    children.add(
      ClipRRect(
        borderRadius: BorderRadius.circular(14.0),
        child: ButtonTheme(
          buttonColor: Colors.grey[300],
          minWidth: 150,
          height: 100,
          child: RaisedButton(
            child: Text(
              "Edit",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                child: AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: SizedBox(
                    width: 500,
                    height: 500,
                    child: ConfigurationDetails(initialMap: map, mapPropertyNameInDocument: mapPropertyNameInDocument)
                  ),
                )
              );
            },
          ),
        ),
      )
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          description,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          )
        ),
        SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 18,
          runSpacing: 18,
          children: children
        ),
      ],
    );
  }
}
