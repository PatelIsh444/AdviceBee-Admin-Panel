import 'package:admin_panel/Services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigation_rail/navigation_rail.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final accountName = (user != null) ? user.displayName ?? "Unknown Name" : "Unknown Name";
    final accountEmail = (user != null) ? user.email ??  "Unknown Email" : "Unknown Email";

    return NavigationRail(
      drawerHeaderBuilder: (context) {
        return Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(accountName),
              accountEmail: Text(accountEmail)
            ),
          ],
        );
      },
      drawerFooterBuilder: (context) {
        return Column(
          children: [
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text("Sign Out"),
              onTap: () async {
                AuthenticationService.signOut();
              },
            ),
          ],
        );
      },
      currentIndex: _currentIndex,
      onTap: (val) {
        if (mounted) setState(() => _currentIndex = val);
      },
      title: Text("Admin Panel"),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Container(color: Colors.blue[300]),
          Container(color: Colors.red[300]),
        ],
      ),
      tabs: [
        BottomNavigationBarItem(
          title: Text("Overview"),
          icon: Icon(Icons.dashboard),
        ),
        BottomNavigationBarItem(
          title: Text("Reports"),
          icon: Icon(Icons.report),
        )
      ],
    );
  }
}