import 'package:flutter/material.dart';

class OverviewDetail extends StatelessWidget {
  const OverviewDetail({
    Key key,
  }) : super(key: key);

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
                "Reports",
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                  color: Colors.grey
                ),
              ),
              SizedBox(height: 8),
            ]
          )
        )
      )
    );
  }
}
