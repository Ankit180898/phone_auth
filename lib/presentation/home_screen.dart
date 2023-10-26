import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/presentation/sign_in.dart';

import '../logic/cubits/auth_cubit/auth_cubit.dart';
import '../logic/cubits/auth_cubit/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Auth"),
      ),
      body: Center(
        child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedOutState) {
                Navigator.popUntil(context,(route)=>route.isFirst);
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>SignInScreen()));
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
                BlocProvider.of<AuthCubit>(context).signOut();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              fillColor: Colors.blue,
              child: Text("Log in"),
            ),
          );
        }),
      ),
    );
  }
}
