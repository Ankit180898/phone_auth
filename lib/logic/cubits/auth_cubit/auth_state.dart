import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState{}

class AuthCodeInitialState extends AuthState{}
class AuthCodeSentState extends AuthState{}

class AuthCodeVerifiedState extends AuthState{}

class AuthLoggedState extends AuthState{
  final User? firebaseUser;
  AuthLoggedState(this.firebaseUser);
}
class AuthLoggedOutState extends AuthState{}
class AuthErrorState extends AuthState{
  String message;
  AuthErrorState(this.message);
}

class AuthLoadingState extends AuthState{}