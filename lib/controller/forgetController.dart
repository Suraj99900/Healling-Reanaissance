import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_renaissance/http/http_service.dart';

class ForgetPasswordController extends GetxController {
  final forgetFormKey = GlobalKey<FormState>();
  RxString sEmail = "".obs;
  RxString sOTP = "".obs;
  RxString sNewPassword = "".obs;
  RxString oResultData = "".obs;
  RxBool bSetForget = false.obs;
  RxBool isGenrateOTP = false.obs;

  setForgetProggressBar(bool res) {
    bSetForget.value = res;
  }

  setGenrateOTP(bool res) {
    isGenrateOTP.value = res;
  }

  Future<bool> generateOTP() async {
    forgetFormKey.currentState!.save();
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

  Future<bool> forgetPassword() async {
    if (!forgetFormKey.currentState!.validate()) {
      return false;
    }
    forgetFormKey.currentState!.save();
    var aBody = {
      "email": sEmail.value,
      "password": sNewPassword.value,
      "otp": sOTP.value,
    };

    HttpService httpService = HttpService();
    var oResult = await httpService.putRequest("/password", aBody);
    setForgetProggressBar(false);
    if (oResult['iTrue']) {
      oResultData.value = oResult['data']['message'];
      return true;
    } else {
      oResultData.value = oResult['data']['message'];
      return false;
    }
  }
}
