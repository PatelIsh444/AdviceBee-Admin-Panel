import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {

  final _auth = FirebaseAuth.instance;

  Stream<FirebaseUser> get userStream {
    return _auth.onAuthStateChanged;
  }

  void signIn(email, password) async {
    _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
