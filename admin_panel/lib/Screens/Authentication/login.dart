import 'package:admin_panel/Services/authentication_service.dart';
import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
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
                      // TODO: setState
                      },
                    ),                
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Password"
                      ),
                      obscureText: true,
                      onChanged: (value) async {
                        // TODO: setState
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 25),
              MaterialButton(
                child: Text("Log in"),
                onPressed: () async {
                  // TODO: Sign in
                },
              )
            ],
          ),
        )
      )
    );
  }
}
