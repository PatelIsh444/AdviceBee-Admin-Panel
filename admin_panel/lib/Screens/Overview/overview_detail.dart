import 'package:flutter/material.dart';

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
        width: 150,
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
              Text(
                detail,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 38
                ),
              )
            ]
          )
        )
      )
    );
  }
}
