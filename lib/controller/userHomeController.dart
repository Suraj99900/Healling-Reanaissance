import 'dart:async';
import 'dart:io';

import 'package:get/state_manager.dart';
import 'package:wellness_app/http/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class UserHomeController extends GetxController {
  final userFormContact = GlobalKey<FormState>();
  RxString FirstName = ''.obs;
  final sOTP = ''.obs;
  final sUserName = ''.obs;
  final sKey = ''.obs;
  final sPassword = ''.obs;
  RxString oResultData = ''.obs;
  RxString sSelectedUserType = ''.obs;
  RxBool isLogin = false.obs;
  RxBool isGenrateOTP = false.obs;

  RxBool isAddingFormData = false.obs;

  setAddingFormData(bParam){
    isAddingFormData.value = bParam;
  }


  Future <bool> addFormData() async{


    return false;
  }


}