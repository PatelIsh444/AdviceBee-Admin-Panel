import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {

  static final _sharedInstance = AuthenticationService();

  final _auth = FirebaseAuth.instance;

  static Stream<FirebaseUser> get userStream {
    return _sharedInstance._auth.onAuthStateChanged;
  }

  static Future signIn(String email, String password) async {
      return await _sharedInstance._auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static void signOut() async {
    _sharedInstance._auth.signOut();
  }
}
