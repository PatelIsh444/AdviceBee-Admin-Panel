import 'package:admin_panel/Services/authentication_service.dart';
import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("Log in"),
        RaisedButton(
          child: Text("Sign in"),
          onPressed: () async {
            AuthenticationService.signIn("fx9612@wayne.edu", "ls530100");
          },
        )
      ]
    );
  }
}
