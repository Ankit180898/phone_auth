import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/logic/blocs/internet_bloc/internet_bloc.dart';
import 'package:phone_auth/logic/cubits/auth_cubit/auth_cubit.dart';
import 'package:phone_auth/presentation/home_screen.dart';
import 'package:phone_auth/presentation/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final internetBloc = InternetBloc();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(internetBloc: internetBloc)),
        BlocProvider(create: (context) => internetBloc),
      ],
      child:  MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  final internetBloc = InternetBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(internetBloc: internetBloc),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: SignInScreen(),
      ),
    );
  }
}

