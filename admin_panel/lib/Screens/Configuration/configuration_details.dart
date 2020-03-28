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
    return Container(
      
    );
  }
}
