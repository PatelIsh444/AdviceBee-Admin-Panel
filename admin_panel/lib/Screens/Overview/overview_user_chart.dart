import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RankData {
  final String rank;
  final int number;
  final charts.Color color;

  RankData(this.rank, this.number, Color color) : this.color = new charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class OverViewUserChart extends StatelessWidget {
  final Map<String, int> userData;

  List<RankData> data() {
    List<RankData> data = [];
    userData.forEach((key, value) => data.add(RankData(key, value, _getColorForRank(key))));
    return data; 
  }

  charts.Series series() {
    return charts.Series<RankData, String>(
      id: "ranks",
      data: data(),
      domainFn: (RankData rankData, _) => rankData.rank,
      measureFn: (RankData rankData, _) => rankData.number,
      colorFn: (RankData rankData, _) => rankData.color
    );
  }

  const OverViewUserChart({Key key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: Container(
        color: Colors.white,
        width: 318,
        height: 330,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: charts.PieChart(
            [series()],
            animate: true,
            behaviors: [
              charts.DatumLegend(
                desiredMaxColumns: 2,
                desiredMaxRows: 3
              )
            ]
          ),
        ),
      ),
    );
  }

  Color _getColorForRank(String rank) {
    switch(rank) {
      case "Queen Bee": return Colors.red;
      case "Worker Bee": return Colors.blue;
      case "Larvae": return Colors.green;
      default: return Colors.grey;
    }
  }
}
