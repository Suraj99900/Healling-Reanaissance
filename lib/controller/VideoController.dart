import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wellness_app/http/http_service.dart';
import 'package:wellness_app/modal/videoModal.dart';
import 'package:dio/dio.dart' as dio; // Import dio with prefix
import 'package:http/http.dart' as http; // Import http for HTTP requests

class VideoController extends GetxController {
  dio.Dio dioInstance = dio.Dio();
  var isUpdatingVideo = false.obs;
  var isAddingVideo = false.obs;
  final videoFormKey = GlobalKey<FormState>();
  var title = ''.obs;
  List<String> sAttachmentName = [];
  var description = ''.obs;
  var categoryId = 0.obs;
  var oResultData = ''.obs;
  var categories = [].obs;
  RxDouble uploadProgress = 0.0.obs;

  var isLoading = true.obs;
  var videos = <Video>[].obs;
  var videosPlayerData = <Video>[].obs;
  var iAddedId;
  List<XFile?> aAttachmentFiles = [];

  Future<List<dynamic>> fetchVideoById(int videoId) async {
    HttpService httpService = HttpService();
    var oResult = await httpService.getRequest("/video/$videoId");
    print(oResult);
    if (oResult['iTrue']) {
      return oResult['data']['body'];
    } else {
      throw Exception('Failed to fetch video data');
    }
  }

  Future<List<dynamic>> fetchCategories() async {
    try {
      HttpService httpService = HttpService();
      var oResult = await httpService.getRequest("/video-categories");
      if (oResult['iTrue']) {
        categories.value = oResult['data']['body'];
        return categories;
      } else {
        throw Exception('Failed to fetch categories: ${oResult['message']}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching categories: $e');
    }
  }

  Future<bool> addVideo(XFile? videoFile, XFile? thumbnailFile) async {
    if (videoFormKey.currentState!.validate() &&
        videoFile != null &&
        thumbnailFile != null) {
      videoFormKey.currentState!.save();

      try {
        dio.FormData formData = dio.FormData.fromMap({
          'title': title.value,
          'description': description.value,
          'category_id': categoryId.value,
          'video': await dio.MultipartFile.fromFile(
            videoFile.path,
            filename: 'video.mp4',
          ),
          'thumbnail': await dio.MultipartFile.fromFile(
            thumbnailFile.path,
            filename: 'thumbnail.jpg',
          ),
        });
        HttpService httpService = HttpService();
        dio.Response response = await dioInstance.post(
          '${httpService.sBaseUrl}/video',
          data: formData,
          options: dio.Options(
            headers: {
              'Authorization': 'Bearer ${httpService.sToken}',
            },
          ),
          onSendProgress: (int sent, int total) {
            double progress = sent / total;
            uploadProgress.value = progress;
            print('Sent: $sent, Total: $total');
          },
        );

        if (response.data['status'] == 200 || response.data['status'] == 201) {
          oResultData.value = 'Video uploaded successfully!';
          iAddedId = response.data['body']['id'];
          var bAttachment = await addAttachment(iAddedId);
          if (bAttachment) {
            return true;
          } else {
            oResultData.value = 'Error uploading attachments';
            return false;
          }
        } else {
          oResultData.value = 'Error uploading video';
          return false;
        }
      } catch (e) {
        print('Error uploading video: $e');
        oResultData.value = 'Error uploading video';
        return false;
      }
    } else {
      oResultData.value =
          'Please fill all fields and select a video and thumbnail';
      return false;
    }
  }

  Future<bool> addAttachment(int iVideoId) async {
    HttpService httpService = HttpService();
    var iii = 0;
    for (var xFileData in aAttachmentFiles) {
      try {
        final response =
            await httpService.postMultipartRequest("/app-attachment", {
          'attachment_name': sAttachmentName[iii],
          'video_id': iVideoId,
        }, {
          "attachment": xFileData!,
        });
        print(response);
      } catch (e) {
        print(e);
      }
      iii++;
    }
    return true;
  }

  Future<List<dynamic>> fetchAttachmentData(iVideoId) async {
    HttpService httpService = HttpService();
    var oResult =
        await httpService.getRequest("/video/app-attachment/${iVideoId}");
    print(oResult);
    if (oResult['iTrue']) {
      return oResult['data']['body'];
    } else {
      throw Exception('Failed to fetch attachment data');
    }
  }

  Future<bool> updateVideo(int id, String sTitle, String sDescription) async {
    if (videoFormKey.currentState!.validate()) {
      videoFormKey.currentState!.save();

      try {
        HttpService httpService = HttpService();
        Map<String, dynamic> data = {
          'title': sTitle,
          'description': sDescription,
          'category_id': categoryId.value,
        };

        final response = await httpService.putRequest("/video/$id", data);

        if (response['iTrue']) {
          oResultData.value = 'Video updated successfully!';
          var bAttachment = await addAttachment(id);
          if (bAttachment) {
            return true;
          } else {
            oResultData.value = 'Error uploading attachments';
            return false;
          }
        } else {
          oResultData.value = response['data']['message'];
          return false;
        }
      } catch (e) {
        oResultData.value = 'An error occurred while updating the video';
        return false;
      }
    } else {
      oResultData.value = 'Please fill all fields';
      return false;
    }
  }

  void fetchVideosByCategoryId(int categoryId) async {
    try {
      isLoading(true);
      HttpService httpService = HttpService();
      var oResult =
          await httpService.getRequest("/videos-category/${categoryId}");

      if (oResult['iTrue']) {
        List<dynamic> body = oResult['data']['body'];
        List<Video> videoList =
            body.map((video) => Video.fromJson(video)).toList();
        this.videos.assignAll(videoList);
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchVideoDataById(int videoId) async {
    isLoading(true);
    try {
      HttpService httpService = HttpService();
      var oResult = await httpService.getRequest("/video/$videoId");

      if (oResult['iTrue']) {
        List<dynamic> body = oResult['data']['body'];
        List<Video> videoList =
            body.map((video) => Video.fromJson(video)).toList();
        videosPlayerData.assignAll(videoList);
      }
    } catch (e) {
      // Handle the error properly
      print("\nError fetching video data: $e");
    } finally {
      isLoading(false);
    }
  }

  void searchVideos(String query, int categoryId) async {
    try {
      isLoading(true);
      HttpService httpService = HttpService();
      var oResult =
          await httpService.getRequest("/videos/search?title=${query}");

      if (oResult['iTrue']) {
        List<dynamic> body = oResult['data']['body'];
        List<Video> videoList =
            body.map((video) => Video.fromJson(video)).toList();
        this.videos.assignAll(videoList);
      }
    } finally {
      isLoading(false);
    }
  }

  void setAddingVideoProgress(bool value) {
    isAddingVideo.value = value;
  }

  void setUpdatingVideoProgress(bool value) {
    isUpdatingVideo.value = value;
  }

  void deleteAttachment(int id) async {
    try {
      isLoading(true);
      HttpService httpService = HttpService();
      var oResult = await httpService.deleteRequest("/app-attachment/$id");
      print(oResult);
    } finally {
      isLoading(false);
    }
  }
}
