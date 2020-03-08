import 'package:admin_panel/Services/authentication_service.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = '';
  String password = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 220,
          color: Colors.orangeAccent,
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Email"
                      ),
                      onChanged: (value) async {
                        setState(() => email = value);
                      },
                    ),                
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Password"
                      ),
                      obscureText: true,
                      onChanged: (value) async {
                        setState(() => password = value);
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 25),
              MaterialButton(
                child: Text("Log in"),
                onPressed: () async {
                  AuthenticationService.signIn(email, password);
                },
              )
            ],
          ),
        )
      )
    );
  }
}
