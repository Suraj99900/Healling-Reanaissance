import 'package:get/get.dart';
import 'package:wellness_app/http/http_service.dart';

class HomeScreenController extends GetxController {
  RxBool isBlogLoad = false.obs;
  RxList userPosts = [].obs;
  RxString oResultData = ''.obs;
  RxList userCategory = [].obs;

  Future<void> fetchCategory() async {
    HttpService httpService = HttpService();
    final oResult = await httpService.getRequest("/video-categories");

    if (oResult['iTrue'] == true) {
      var aData = oResult['data']['body'];
      oResultData.value = oResult['data']['message'];
      // set user shred-prefrence is login and email
      userCategory.value = aData;
    } else {
      oResultData.value = oResult['data']['message'];
    }
  }
}
