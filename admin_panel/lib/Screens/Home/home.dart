import 'package:admin_panel/Screens/Overview/overview.dart';
import 'package:admin_panel/Services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

    return NavigationRail(
      title: Text("Admin Panel"),
      drawerHeaderBuilder: (context) {
        return Column(
          children: <Widget>[
            FutureBuilder(
              future: Firestore.instance.collection("users").document(user.uid).get(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                String accountName = "Unknown Name";
                String accountEmail = "Unknown Email";
                String thumbnailPicURL = "https://pbs.twimg.com/profile_images/893885309292732416/c7mWp3xT_400x400.jpg";

                if (snapshot.hasData) {
                  accountName = snapshot.data["displayName"];
                  accountEmail = snapshot.data["email"];
                  thumbnailPicURL = snapshot.data["thumbnailPicURL"];
                }
                
                return UserAccountsDrawerHeader(
                  accountName: Text(accountName),
                  accountEmail: Text(accountEmail),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(thumbnailPicURL)
                  )
                );
              }
            ),
          ],
        );
      },
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[200],
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Overview()
            )
          ),
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
      currentIndex: _currentIndex,
      onTap: (val) {
        if (mounted) setState(() => _currentIndex = val);
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
    );
  }
}