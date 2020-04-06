import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as Charts;

class RankData {
  final String rank;
  final int number;
  final Charts.Color color;

  RankData(this.rank, this.number, Color color) : this.color = new Charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
