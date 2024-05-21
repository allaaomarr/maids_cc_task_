import 'package:flutter/material.dart';
import '../../Model/login_model.dart';
import '../data/dio.dart';

class LoginProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<int?> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();


    int? statusCode = await ApiServices.PostDatalogin(username, password);

    _isLoading = false;
    notifyListeners();
    return statusCode;
  }
}