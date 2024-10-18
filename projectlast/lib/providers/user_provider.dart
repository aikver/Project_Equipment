import 'package:flutter/material.dart';
import 'package:projectlast/model/user_model.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  String? _accessToken;
  String? _refreshToken;

  // Getter methods
  User get user => _user!;
  String get accessToken => _accessToken!;
  String get refreshToken => _refreshToken!;

  // Called when user logs in
  void onLogin(Usermodel userModel) {
    _user = userModel.user;
    _accessToken = userModel.accessToken;
    _refreshToken = userModel.refreshToken;
    notifyListeners(); // Notify listeners about the changes
  }

  // Called when user logs out
  void onLogout() {
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners(); // Notify listeners to update UI
  }

  // Update the access token (perhaps for refreshing token)
  void updateAccessToken(String newToken) {
    _accessToken = newToken;
    notifyListeners(); // Notify listeners about the token change
  }
}
