import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talawa/model/token.dart';

class Preferences with ChangeNotifier {
  static const tokenKey = "token";
  static const userId = "userId";

  Future saveUserId(String userID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(userId, userID);
  }

  Future<String> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String uid = preferences.getString(userId);
    return uid;
  }

  Future saveToken(Token token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token.parseJwt();
    await preferences.setString(
        tokenKey,
        (token.tokenString != null && token.tokenString.length > 0)
            ? token.tokenString
            : "");
  }

  Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userToken = preferences.getString(tokenKey);
    return userToken;
  }

  static Future<int> getCurrentUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      Token token =
          new Token(tokenString: preferences.getString(tokenKey) ?? "");
      Map<String, dynamic> tokenMap = token.parseJwt();
      return tokenMap['id'];
    } catch (e) {
      print(e);
    }
    return -1;
  }

  static Future<bool> clearUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      preferences.remove(tokenKey);
      preferences.remove(userId);
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
