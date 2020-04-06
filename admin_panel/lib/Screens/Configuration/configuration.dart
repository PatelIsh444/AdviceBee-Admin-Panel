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
          SizedBox(height: 25),
          _generateConfigurationDetails(),
          Text(
              "Payment Configuration",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 35,
              )
          ),
          SizedBox(height: 25),
          _generatePayConfigurationDetails(),
        ],
      )
    );
  }

  Widget _generateConfigurationDetails() {
    return StreamBuilder(
      stream: Firestore.instance.collection("configuration").document("config").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _generateDailyPostLimitRow(context, snapshot);
        }
        else {
          return Text("Loading...");
        }
      },
    );
  }

  Widget _generatePayConfigurationDetails() {
    return StreamBuilder(
      stream: Firestore.instance.collection("configuration").document("payConfig").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _generateDailyPostLimitRow(context, snapshot);
        }
        else {
          return Text("Loading...");
        }
      },
    );
  }

  Widget _generateDailyPostLimitRow(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    Map<String, dynamic> dailyQuestionsLimitMap = snapshot.data["dailyQuestionsLimit"];

    List<Widget> children = [];
    
    dailyQuestionsLimitMap.forEach((key, value) => children.add(OverviewDetail(title: key, detail: value.toString())));

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
                    child: ConfigurationDetails(initialDailyQuestionsLimitMap: dailyQuestionsLimitMap)
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
          "Number of daily posts per rank:",
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
