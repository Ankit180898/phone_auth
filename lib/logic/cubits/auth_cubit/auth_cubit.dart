import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/logic/cubits/auth_cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? _verificationId;
  AuthCubit() : super(AuthCodeInitialState());

  void sendOtp(String phoneNo) async {
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
        _verificationId=verificationId;
        emit(AuthCodeSentState());
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId=_verificationId;
      },
    );
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
