import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthNotifier extends ChangeNotifier {
  late final StreamSubscription<User?> _sub;

  FirebaseAuthNotifier() {
    _sub = FirebaseAuth.instance.authStateChanges().listen((user) {
      notifyListeners();
    });
  }

  @override
  void dispose () {
    _sub.cancel();
    super.dispose();
  }
}
