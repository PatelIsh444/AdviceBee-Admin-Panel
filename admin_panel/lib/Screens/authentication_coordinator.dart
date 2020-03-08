import 'package:admin_panel/Screens/Authentication/login.dart';
import 'package:admin_panel/Screens/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationCoordinator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    if (user == null) {
      return LogIn();
    }
    else {
      return Home();
    }
  }
}
