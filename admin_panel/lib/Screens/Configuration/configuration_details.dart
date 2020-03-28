import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConfigurationDetails extends StatefulWidget {
  final Map<String, dynamic> initialDailyQuestionsLimitMap;

  ConfigurationDetails({this.initialDailyQuestionsLimitMap});

  @override
  _ConfigurationDetailsState createState() => _ConfigurationDetailsState();
}

class _ConfigurationDetailsState extends State<ConfigurationDetails> {
  Map<String, dynamic> dailyQuestionsLimitMap;

  @override
  void initState() {
    super.initState();
    this.dailyQuestionsLimitMap = widget.initialDailyQuestionsLimitMap;
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Text(
      "Set daily number of posts per rank:",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 28,
        )
      ),
      SizedBox(height: 32,)
    ];

    dailyQuestionsLimitMap.forEach((key, value) {
      children.add(_generateTextFormField(key, value));
      children.add(SizedBox(height: 32,));
    });
    
    children.add(
      RaisedButton(
        child: Text("confirm"), 
        onPressed: () async {
          await _updateConfigWithUpdatedDailyNumberOfPostsPerRank(dailyQuestionsLimitMap);
          Navigator.of(context).pop(true);
        } 
      )
    );

    return Padding(
      padding: const EdgeInsets.all(18),
      child: SingleChildScrollView(
        child: Form(
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _generateTextFormField(String key, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          key,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          )
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Enter daily number of posts limit"
          ),
          initialValue: value.toString(),
          onChanged: (value) async {
            setState(() => dailyQuestionsLimitMap[key] = value);
          },
        ),
      ],
    );
  }

  Future<void> _updateConfigWithUpdatedDailyNumberOfPostsPerRank(Map<String, dynamic> dailyQuestionsLimitMap) async {
    Firestore.instance.collection("configuration").document("config").updateData({
      "dailyQuestionsLimit": dailyQuestionsLimitMap
    });
  }
}
