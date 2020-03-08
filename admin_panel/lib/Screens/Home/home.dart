import 'package:admin_panel/Services/authentication_service.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("Home"),
        RaisedButton(
          child: Text("Sign out"),
          onPressed: () async {
            AuthenticationService.signOut();
          },
        )
      ]
    );
  }
}
