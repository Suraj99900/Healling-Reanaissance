import 'package:get/get.dart';

class ConfigController extends GetxController {
  RxBool isDashBoard = false.obs;

  final RxString _sClientId = "99900".obs;
  final RxString _sClientkey = "58da58323c5fbb27fd49e5a1d478f3a4479fe0d5497c8b11cb206e954a6150c3".obs;
  final RxString _sBaseUrl = "https://release-api.lifehealerkavita.com/api".obs;

  setDashBoard(bool value) {
    isDashBoard.value = value;
  }

  RxString getClientId() {
    return _sClientId;
  }
  RxString getClientKey() {
    return _sClientkey;
  }
  RxString getBaseURL() {
    return _sBaseUrl;
  }
}
