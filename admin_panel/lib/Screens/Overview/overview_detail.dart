import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OverviewDetail extends StatelessWidget {
  const OverviewDetail({
    Key key, this.title, this.detail,
  }) : super(key: key);

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: Container(
        color: Colors.white,
        width: 160,
        height: 100,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                  color: Colors.grey
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: AutoSizeText(
                  detail,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 38
                  ),
                ),
              )
            ]
          )
        )
      )
    );
  }
}
