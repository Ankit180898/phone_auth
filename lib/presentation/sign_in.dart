import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/logic/blocs/internet_bloc/internet_bloc.dart';
import 'package:phone_auth/logic/blocs/internet_bloc/internet_state.dart';
import 'package:phone_auth/logic/cubits/auth_cubit/auth_cubit.dart';
import 'package:phone_auth/logic/cubits/auth_cubit/auth_state.dart';
import 'package:phone_auth/presentation/verify_phone.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneNumberController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Auth"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text("Phone number"),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: phoneNumberController,
              maxLength: 10,
              keyboardType: TextInputType.number,
              onChanged: (val) {},
              decoration: InputDecoration(
                hintText: "Phone number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthCodeSentState) {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => VerifyPhoneScreen()));
                    }
                  }, builder: (context, state) {
                if (state is AuthLoadingState) {
                  return CircularProgressIndicator();
                }
                return Container(
                  height: 50,
                  width: 200,
                  child: RawMaterialButton(
                    onPressed: () {
                      String phoneNumber = "+91${phoneNumberController.text}";
                      BlocProvider.of<AuthCubit>(context).sendOtp(phoneNumber);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    fillColor: Colors.blue,
                    child: Text("Log in"),
                  ),
                );
              }),
            ),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<InternetBloc, InternetState>(
              builder: (context, state) {
                return Text("Phone number");
              },
            ),

          ],
        ),
      ),
    );
  }
}
