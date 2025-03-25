import 'package:get/get.dart';
import 'package:healing_renaissance/http/http_service.dart';
import 'package:healing_renaissance/modal/CategoryModal.dart';

class CategoryTableController extends GetxController {
  var sWidth = Get.width;
  RxInt rowCount = 0.obs;
  RxList<VideoCategory> videoCategory = <VideoCategory>[].obs;



  Future<List<VideoCategory>> fetchCategoryData() async {
    try {
      HttpService httpService = HttpService();
      final oResult = await httpService.getRequest("/video-categories");

      if (oResult['iTrue'] == true) {
        var aData = oResult['data']['body'];
        // Create a list of VideoCategory objects
        List<VideoCategory> categories = aData.map<VideoCategory>((item) {
          return VideoCategory(
            id: item['id'] ?? 0,
            name: item['name'] ?? "",
            desc: item['description'] ?? "",
            action: '',
          );
        }).toList();
        videoCategory.value = categories;
        return categories;
      } else {
        throw Exception('Failed to fetch category data');
      }
    } catch (e) {
      print("Error fetching category data: $e");
      rethrow;
    }
  }
}