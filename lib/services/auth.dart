import 'package:brew_coffee/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  //create user obj from firebase obj
  BrewUser? _userFromFirebaseUser (User? user) {
    return user != null ? BrewUser(uid: user.uid) : null;
  }

  //auth stream
  Stream<BrewUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }catch(err){
      print(err.toString());
      return null;
    }
  }

  //sign in email/password

  //register in email/password

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch (err){
      print(err.toString());
      return null;
    }
  }
}