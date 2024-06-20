import 'package:get/get.dart';
import 'package:wellness_app/http/http_service.dart';
import 'package:wellness_app/modal/UploadedVideoModal.dart';

class VideoTableController extends GetxController {
  var sWidth = Get.width;
  RxInt rowCount = 0.obs;
  RxList<UploadedVideoModal> uploadedVideos = <UploadedVideoModal>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideoData();
  }

  Future<List<UploadedVideoModal>> fetchVideoData() async {
    try {
      HttpService httpService = HttpService();
      final oResult = await httpService.getRequest("/videos");

      if (oResult['iTrue'] == true) {
        var aData = oResult['data']['body'];

        List<UploadedVideoModal> videos = aData.map<UploadedVideoModal>((item) {

          return UploadedVideoModal(
            id: item['id'] ?? 0,
            uploadDate: item['added_on'] ?? "",
            categoryId: item['category_id'] ?? "",
            title: item['title'] ?? "",
            description: item['description'] ?? "",
            categoryName : item['name'] ?? "",
            thumbnail:  item['thumbnail_url'] ?? "",
          );
        }).toList();
        uploadedVideos.value = videos;
        return videos;
      } else {
        throw Exception('Failed to fetch video data');
      }
    } catch (e) {
      print("Error fetching video data: $e");
      rethrow;
    }
  }

  fetchThumbnail(id) async {
    HttpService httpService = HttpService();
    final oResult = await httpService.getRequest("/thumbnail/${id}");

    if (oResult['iTrue'] == true) {
      var aData = oResult['data']['thumbnail_url'];

      return aData;
      
    } else {
        return "https://suraj99900.github.io/myprotfolio.github.io/img/gallery_1.jpg";
    }
  }

  Future<bool> deleteVideo(int id) async {
    try {
      HttpService httpService = HttpService();
      final oResult = await httpService.deleteRequest("/video/$id");

      if (oResult['iTrue'] == true) {
        await fetchVideoData();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error deleting video: $e");
      return false;
    }
  }
}
