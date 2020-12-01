import 'package:beautifulthings/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'databaseservice.dart';
import 'globalvariables.dart';

class AuthenticationService {
//create user object

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

// auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

//sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      idUser = result.user.uid;
      prefs.setString('Firebase ID', idUser);
      error = " ";
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      idUser = result.user.uid;
      error = " ";
      prefs.setString('Firebase ID', idUser);
      await DatabaseService()
          .updateUserData(userName, idUser, isFollowing, about, dP);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
