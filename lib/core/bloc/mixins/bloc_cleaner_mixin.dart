import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocCleaner<E, S> on Bloc<E, S> {
  StreamSubscription? _authSubscription;

  /// Call this inside bloc constructor
  void attachAuthCleaner(Stream authStream, S resetState) {
    _authSubscription = authStream.listen((state) {
      if (_shouldClean(state)) {
        onClean();
        emit(resetState);
      }
    });
  }

  /// override if needed
  bool _shouldClean(dynamic state) {
    return state.runtimeType.toString() == 'AuthUnauthenticated';
  }

  /// clear memory maps, caches etc
  void onClean();

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
