import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConfigurationDetails extends StatefulWidget {
  final Map<String, dynamic> initialMap;
  final String mapPropertyNameInDocument;

  ConfigurationDetails({this.initialMap, this.mapPropertyNameInDocument});

  @override
  _ConfigurationDetailsState createState() => _ConfigurationDetailsState();
}

class _ConfigurationDetailsState extends State<ConfigurationDetails> {
  Map<String, dynamic> map;

  @override
  void initState() {
    super.initState();
    this.map = widget.initialMap;
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

    map.forEach((key, value) {
      children.add(_generateTextFormField(key, value));
      children.add(SizedBox(height: 32,));
    });
    
    children.add(
      RaisedButton(
        child: Text("Submit"), 
        onPressed: () async {
          await _updateConfigWithUpdatedDailyNumberOfPostsPerRank(map);
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
            setState(() => map[key] = int.parse(value));
          },
        ),
      ],
    );
  }

  Future<void> _updateConfigWithUpdatedDailyNumberOfPostsPerRank(Map<String, dynamic> map) async {
    Firestore.instance.collection("configuration").document("config").updateData({
      widget.mapPropertyNameInDocument: map
    });
  }
}
