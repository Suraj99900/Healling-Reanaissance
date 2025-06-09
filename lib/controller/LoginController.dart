// ignore_for_file: file_names
import 'dart:io';

import 'package:kavita_healling_reanaissance/http/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../SharedPreferencesHelper.dart'; // Import your SharedPreferencesHelper if needed
import '../route/route.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final email = ''.obs;
  final password = ''.obs;
  RxString oResultData = ''.obs;
  RxBool isLogin = false.obs;

  setLoginProgressBar(bool res) {
    isLogin.value = res;
  }

  Future<bool> userLogin() async {
    if (!loginFormKey.currentState!.validate()) {
      oResultData.value = "Fileds are empty.";
      return false;
    }
    loginFormKey.currentState!.save();
    String sEmail = email.value;
    String sPassword = password.value;
    print('Email: $sEmail');
    print('Password: $sPassword');

    HttpService httpService = HttpService();
    final oResult = await httpService
        .getRequest("/login?email=$sEmail&password=$sPassword");

    if (oResult['iTrue'] == true) {
      var aData = oResult['data']['body'];
      oResultData.value = oResult['data']['message'];
      setLoginProgressBar(false);

      // Set user shared preferences for login and email
      SharedPreferencesHelper.saveLogin(
          'isLogin', true); // Save as String 'true'

      int? userId = aData['id'];
      // Convert userId to String before saving
      SharedPreferencesHelper.saveUserId(
          'sUserId', userId?.toString() ?? 'default_value');

      // Ensure all other values are also saved as Strings
      SharedPreferencesHelper.saveEmail('sEmail', aData['email'].toString());
      SharedPreferencesHelper.saveUserName(
          'sUserName', aData['user_name'].toString());
      SharedPreferencesHelper.saveType('sType', aData['type'].toString());
      SharedPreferencesHelper.saveUserType(
          'sUserType', aData['user_type'].toString());

      return true;
    } else {
      oResultData.value = oResult['data']['message'];
      setLoginProgressBar(false);
      return false;
    }
  }
}
