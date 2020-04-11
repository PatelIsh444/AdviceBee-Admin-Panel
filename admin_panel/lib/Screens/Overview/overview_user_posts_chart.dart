import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class UserPostedData {
  final String title;
  final int value;
  final charts.Color color;

  UserPostedData(this.title, this.value, Color color) : this.color = new charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class OverViewUserPostChart extends StatelessWidget {
  final Map<String, int> usersPostedData;

  List<UserPostedData> data() {
    List<UserPostedData> data = [];
    usersPostedData.forEach((key, value) => data.add(UserPostedData(key, value, key == "Users who have posted" ? Colors.purple : Colors.deepOrange)));
    return data; 
  }

  charts.Series series() {
    return charts.Series<UserPostedData, String>(
      id: "hasPosted",
      data: data(),
      domainFn: (UserPostedData data, _) => data.title,
      measureFn: (UserPostedData data, _) => data.value,
      colorFn: (UserPostedData data, _) => data.color
    );
  }

  const OverViewUserPostChart({Key key, this.usersPostedData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int totalNumber = usersPostedData.values.reduce((value, element) => value += element);

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
