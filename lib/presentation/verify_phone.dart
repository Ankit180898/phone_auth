import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/logic/cubits/auth_cubit/auth_cubit.dart';
import 'package:phone_auth/logic/cubits/auth_cubit/auth_state.dart';
import 'package:phone_auth/presentation/home_screen.dart';

class VerifyPhoneScreen extends StatelessWidget {
  const VerifyPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final verifyOtpController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Auth"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text("Verify number"),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: verifyOtpController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              onChanged: (val) {},
              decoration: InputDecoration(
                hintText: "6-Digit-OTP",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoggedState) {
                    Navigator.popUntil(context,(route)=>route.isFirst);
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>HomeScreen()));


                  }
                  else if(state is AuthErrorState){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 1),backgroundColor: Colors.red,content: Text(state.message.toString())));
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return CircularProgressIndicator();
                  }
                  return Container(
                    height: 50,
                    width: 200,
                    child: RawMaterialButton(
                      onPressed: () {
                        BlocProvider.of<AuthCubit>(context)
                            .verifyOtp(verifyOtpController.text);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      fillColor: Colors.blue,
                      child: Text("Log in"),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
