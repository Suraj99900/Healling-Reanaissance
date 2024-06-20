import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wellness_app/http/http_service.dart';

class CategoryController extends GetxController {
  final categoryFormKey = GlobalKey<FormState>();
  var categoryName = ''.obs;
  var description = ''.obs;
  var isAddingCategory = false.obs;
  var oResultData = ''.obs;

  void setAddingCategoryProgress(bool value) {
    isAddingCategory.value = value;
  }

  Future<bool> addCategory() async {
    final isValid = categoryFormKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    categoryFormKey.currentState!.save();

    var aBody = {
      "name": categoryName.value,
      "desc": description.value,
    };

    HttpService httpService = HttpService();
    var oResult = await httpService.postRequest("/video-category", aBody);
    setAddingCategoryProgress(false);
    if (oResult['iTrue']) {
      oResultData.value = oResult['data']['message'];
      return true;
    } else {
      oResultData.value = oResult['data']['message'];
      return false;
    }
  }

  Future<bool> deleteCategory(iRowId) async {
    HttpService httpService = HttpService();
    var oResult = await httpService.deleteRequest("/video-category/${iRowId}");
    setAddingCategoryProgress(false);
    if (oResult['iTrue']) {
      oResultData.value = oResult['data']['message'];
      return true;
    } else {
      oResultData.value = oResult['data']['message'];
      return false;
    }
  }

  // fetch the record by id

  Future<Map<String, dynamic>> fetchCategoryById(int? iRowId) async {
    HttpService httpService = HttpService();
    var oResult = await httpService.getRequest("/video-category/${iRowId}");
    setAddingCategoryProgress(false);
    if (oResult['iTrue']) {
      oResultData.value = oResult['data']['message'];
      var aData = oResult['data']['body'];
      return aData;
    } else {
      oResultData.value = oResult['data']['message'];
      return {};
    }
  }

  // function for update category
  Future<bool> updateCategory(int? iRowId) async {
    final isValid = categoryFormKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    categoryFormKey.currentState!.save();

    var aBody = {
      "name": categoryName.value,
      "description": description.value,
    };

    HttpService httpService = HttpService();
    var oResult = await httpService.putRequest("/video-category/${iRowId}", aBody);
    setAddingCategoryProgress(false);
    if (oResult['iTrue']) {
      oResultData.value = oResult['data']['message'];
      return true;
    } else {
      oResultData.value = oResult['data']['message'];
      return false;
    }
  }
}
