import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class UserGroupData {
  final String title;
  final int value;
  final charts.Color color;

  UserGroupData(this.title, this.value, Color color) : this.color = new charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class OverViewUserGroupChart extends StatelessWidget {
  final Map<String, int> usersGroupData;

  List<UserGroupData> data() {
    List<UserGroupData> data = [];
    usersGroupData.forEach((key, value) => data.add(UserGroupData(key, value, key == "Users who are in a group" ? Colors.teal : Colors.blueAccent)));
    return data; 
  }

  charts.Series series() {
    return charts.Series<UserGroupData, String>(
      id: "apartOfGroup",
      data: data(),
      domainFn: (UserGroupData data, _) => data.title,
      measureFn: (UserGroupData data, _) => data.value,
      colorFn: (UserGroupData data, _) => data.color
    );
  }

  const OverViewUserGroupChart({Key key, this.usersGroupData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int totalNumber = usersGroupData.values.reduce((value, element) => value += element);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: Container(
        color: Colors.white,
        width: 338,
        height: 330,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: charts.PieChart(
            [series()],
            animate: true,
            behaviors: [
              charts.DatumLegend(
                position: charts.BehaviorPosition.top,
                showMeasures: true,
                legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                measureFormatter: (num value) {
                  final double percentage = ((value/totalNumber.toDouble()) * 100.0);
                  return value == null ? '-' : percentage.toStringAsFixed(1) + '%';
                },
                desiredMaxColumns: 1,
                desiredMaxRows: 3
              )
            ]
          ),
        ),
      ),
    );
  }
}
