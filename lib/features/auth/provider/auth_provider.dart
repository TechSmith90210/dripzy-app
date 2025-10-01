import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;

  void setUserData(User user) {
    _user = user;
    notifyListeners();
  }

  User? get user => _user;

  // Force a rebuild
  void refresh() {
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
