
import 'package:healing_renaissance/http/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  final adminLoginFormKey = GlobalKey<FormState>();
  final sEmail = ''.obs;
  final sOTP = ''.obs;
  final sUserName = ''.obs;
  final sKey = ''.obs;
  final sPassword = ''.obs;
  RxString oResultData = ''.obs;
  RxString sSelectedUserType = ''.obs;
  RxBool isLogin = false.obs;
  RxBool isGenrateOTP = false.obs;

  setLoginProgressBar(bool res) {
    isLogin.value = res;
  }

  setGenrateOTP(bool res) {
    isGenrateOTP.value = res;
  }

  Future<bool> adminLogin() async {
    if (!adminLoginFormKey.currentState!.validate()) {
      return false;
    }
    adminLoginFormKey.currentState!.save();
    var aBody = {
      "userName": sUserName.value,
      "email": sEmail.value,
      "secretkey": sKey.value,
      "password": sPassword.value,
      "userType": sSelectedUserType.value,
      "otp": sOTP.value,
    };
  
    HttpService httpService = HttpService();
    var oResult = await httpService.postRequest("/users", aBody);
    setLoginProgressBar(false);
    if (oResult['iTrue']) {
      oResultData.value = oResult['data']['message'];
      return true;
    } else {
      oResultData.value = oResult['data']['message'];
      return false;
    }
  }

  Future<bool> generateOTP() async {
    adminLoginFormKey.currentState!.save();
    if (sEmail.value.isEmpty) {
      oResultData.value = "Please enter your email address.";
      return false;
    }
    setGenrateOTP(true);
    var sEmailData = sEmail.value;
    HttpService httpService = HttpService();

    var aBody = {
      "user_email_id": sEmailData,
    };

    var oResult = await httpService.postRequest("/email", aBody);
    setGenrateOTP(false);

    if (oResult['iTrue']) {
      oResultData.value = oResult['data']['message'];
      print(oResultData.value);
      return true;
    } else {
      oResultData.value = oResult['data']['message'];
      return false;
    }
  }
}
