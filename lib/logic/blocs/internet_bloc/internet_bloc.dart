import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/logic/blocs/internet_bloc/internet_event.dart';
import 'package:phone_auth/logic/blocs/internet_bloc/internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetBloc() : super(InternetInitialState()) {
    on<InternetConnectedEvent>((event, emit) => emit(InternetConnectedState()));
    on<InternetDisconnectedEvent>(
            (event, emit) => emit(InternetDisconnectedState()));
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
          if (result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi) {
            add(InternetConnectedEvent());
          } else if (result == ConnectivityResult.none) {
            add(InternetDisconnectedEvent());
          }
        });
  }
  @override
  Future<void> close() {
    // TODO: implement close
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
