import 'package:url_launcher/url_launcher.dart';
import 'package:wellness_app/http/http_service.dart';
import 'package:wellness_app/modal/CategoryModal.dart';


String limitWords(String text, int wordLimit) {
  List<String> words = text.split(' ');
  if (words.length <= wordLimit) {
    return text;
  } else {
    return '${words.take(wordLimit).join(' ')}...';
  }
}

Future<List<VideoCategory>> fetchCategoryData() async {
  try {
    HttpService httpService = HttpService();
    final oResult = await httpService.getRequest("/video-categories");

    if (oResult['iTrue'] == true) {
      var aData = oResult['data']['body'];
      // Create a list of VideoCategory objects
      List<VideoCategory> categories = aData.map<VideoCategory>((item) {
        return VideoCategory(
            id: item['id'] ?? "",
            name: item['name'] ?? "",
            desc: item['description'] ?? "",
            action: '');
      }).toList();
      return categories;
    } else {
      throw Exception('Failed to fetch category data');
    }
  } catch (e) {
    print("Error fetching user data: $e");
    rethrow;
  }
}

Future<void> LaunchURL(sURL) async {
  final Uri url = Uri.parse(sURL);
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $sURL');
  }
}

