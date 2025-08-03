import 'package:firebase_auth/firebase_auth.dart';

Future SignIn(String email, String password) {
  return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
}

Future SignUp(String email, String password) {
  return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
}

void SignWithPhoneNumber() {
  
}