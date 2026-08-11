import 'package:flutter/material.dart';

import '../methods/auth_methods.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  late Users _user;
  final AuthMethode _authMethode = AuthMethode();

  Users get getUser => _user;

  Future<void> refreshUser() async {
    Users user = await _authMethode.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
