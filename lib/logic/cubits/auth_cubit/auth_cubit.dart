import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/logic/blocs/internet_bloc/internet_state.dart';
import 'package:phone_auth/logic/cubits/auth_cubit/auth_state.dart';

import '../../blocs/internet_bloc/internet_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? _verificationId;
  final InternetBloc internetBloc;

  AuthCubit({required this.internetBloc}) : super(AuthCodeInitialState());

  void sendOtp(String phoneNo) async {
    if(internetBloc is InternetConnectedState) {
      emit(AuthLoadingState());
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          signIn(phoneAuthCredential);
        },
        verificationFailed: (FirebaseAuthException error) {
          emit(AuthErrorState(error.message.toString()));
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          _verificationId = verificationId;
          emit(AuthCodeSentState());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = _verificationId;
        },
      );
    }
    else if(internetBloc is InternetDisconnectedState){
      emit(AuthErrorState("No internet connection."));
      return;

    }
  }

  void verifyOtp(String otp) {
    emit(AuthLoadingState());
    PhoneAuthCredential credential=PhoneAuthProvider.credential(verificationId: _verificationId.toString(), smsCode: otp.toString());
    signIn(credential);
  }

  void signIn(PhoneAuthCredential phoneAuthCredential) async{
    try{
      UserCredential userCredential=await auth.signInWithCredential(phoneAuthCredential);
      if(userCredential.user!=null){
        emit(AuthLoggedState(userCredential.user));
      }

    }
    on FirebaseAuthException catch(ex){
      emit(AuthErrorState(ex.message.toString()));

    }
  }
  void signOut() async{

      await auth.signOut();
      emit(AuthLoggedOutState());


  }
}
