import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:healing_renaissance/controller/configController.dart';
import 'package:healing_renaissance/http/http_service.dart';
import 'package:healing_renaissance/modal/videoModal.dart';
import 'package:dio/dio.dart' as dio; // Import dio with prefix
import 'package:http/http.dart' as http; // Import http for HTTP requests
import 'package:tus_client_dart/tus_client_dart.dart';
import 'package:path_provider/path_provider.dart'; // Import for getting temporary directory

class VideoController extends GetxController {
  dio.Dio dioInstance = dio.Dio();

  var isUpdatingVideo = false.obs;
  var isAddingVideo = false.obs;
  final videoFormKey = GlobalKey<FormState>();

  var title = ''.obs;
  var description = ''.obs;
  var categoryId = 0.obs;
  var oResultData = ''.obs;
  var categories = [].obs;

  RxDouble uploadProgress = 0.0.obs;
  var isLoading = true.obs;

  var videos = <Video>[].obs;
  var videosPlayerData = <Video>[].obs;
  var iAddedId;

  List<String> sAttachmentName = [];
  List<XFile?> aAttachmentFiles = [];

  // ===============================
  // ==========  FETCHERS  =========
  // ===============================

  Future<List<dynamic>> fetchVideoById(int videoId) async {
    HttpService httpService = HttpService();
    var oResult = await httpService.getRequest("/video/$videoId");

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

  // ==========================================
  // ==========  ADD / UPDATE VIDEO  =========
  // ==========================================

  Future<bool> addVideo(XFile? videoFile, XFile? thumbnailFile) async {
    if (videoFile == null || thumbnailFile == null) {
      print("Please select both video and thumbnail.");
      return false;
    }

    final int chunkSize = 5 * 1024 * 1024; // 5MB
    final int totalChunks = (await videoFile.length()) ~/ chunkSize + 1;
    int chunkIndex = 0;

    while (chunkIndex < totalChunks) {
      final start = chunkIndex * chunkSize;
      final end = start + chunkSize;
      final bytes = await videoFile.readAsBytes();
      final chunk = bytes.sublist(start, end.clamp(0, bytes.length));

      final dio.FormData formData = dio.FormData.fromMap({
        'video': dio.MultipartFile.fromBytes(chunk, filename: videoFile.name),
        'chunk_index': chunkIndex,
        'total_chunks': totalChunks,
        'filename': videoFile.name,
        'title': title.value,
        'description': description.value,
        'category_id': categoryId.value.toString(),
        'thumbnail': await dio.MultipartFile.fromFile(thumbnailFile.path,
            filename: thumbnailFile.name),
      });

      try {
        var sBaseUrl = ConfigController().getBaseURL().value;
        dioInstance.options.baseUrl = sBaseUrl;
        final response = await dioInstance.post(
          "/uploadChunk",
          data: formData,
          options:
              dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
          onSendProgress: (sent, total) {
            uploadProgress.value = (chunkIndex + 1) / totalChunks;
            print(
                "Chunk ${chunkIndex + 1}/$totalChunks uploaded (${uploadProgress.value * 100}%)");
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          chunkIndex++;
          if (chunkIndex == totalChunks) {
             iAddedId = response.data['video']['id'];
            print("✅ All chunks uploaded successfully!");
           var bAttachment = await addAttachment(iAddedId);
            if (bAttachment) {
              // Optionally update progress to complete
              uploadProgress.value = 1.0;
              return true;
            } else {
              oResultData.value = 'Error uploading attachments';
              return false;
            }
          }
        } else {
          uploadProgress.value = 0.0;
          print("Error uploading chunk: ${response.statusCode}");
          return false;
        }
      } catch (e) {
        uploadProgress.value = 0.0;
        print("Error: $e");
        return false;
      }
    }
    return false;
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
        oResultData.value = 'An error occurred while updating the video: $e';
        return false;
      }
    } else {
      oResultData.value = 'Please fill all fields';
      return false;
    }
  }

  // ======================================
  // ==========  ATTACHMENTS  ============
  // ======================================

  Future<bool> addAttachment(int iVideoId) async {
    HttpService httpService = HttpService();
    var iii = 0;
    for (var xFileData in aAttachmentFiles) {
      try {
        final response = await httpService.postMultipartRequest(
          "/app-attachment",
          {
            'attachment_name': sAttachmentName[iii],
            'video_id': iVideoId,
          },
          {
            "attachment": xFileData!,
          },
        );
        print(response);
      } catch (e) {
        print("Error uploading attachment $iii: $e");
      }
      iii++;
    }
    return true;
  }

  // ========================================
  // ==========  FETCH / SEARCH  ============
  // ========================================

  void fetchVideosByCategoryId(int categoryId) async {
    try {
      isLoading(true);
      HttpService httpService = HttpService();
      var oResult =
          await httpService.getRequest("/videos-category/$categoryId");
      if (oResult['iTrue']) {
        List<dynamic> body = oResult['data']['body'];
        List<Video> videoList =
            body.map((video) => Video.fromJson(video)).toList();
        videos.assignAll(videoList);
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
      print("\nError fetching video data: $e");
    } finally {
      isLoading(false);
    }
  }

  void searchVideos(String query) async {
    if (query.isNotEmpty) {
      try {
        isLoading(true);
        HttpService httpService = HttpService();
        var oResult =
            await httpService.getRequest("/videos/search?title=$query");
        if (oResult['iTrue']) {
          List<dynamic> body = oResult['data']['body'];
          List<Video> videoList =
              body.map((video) => Video.fromJson(video)).toList();
          videos.assignAll(videoList);
        }
      } finally {
        isLoading(false);
      }
    }
  }

  // =========================
  // ==========  MISC  =======
  // =========================

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

  // Helper for building a thumbnail form field
  Future<dio.MultipartFile> _getThumbnailMultipartFile(
      XFile thumbnailFile) async {
    if (kIsWeb) {
      // For Flutter web, read file as bytes
      List<int> thumbnailBytes = await thumbnailFile.readAsBytes();
      return dio.MultipartFile.fromBytes(
        thumbnailBytes,
        filename: 'thumbnail.jpg',
      );
    } else {
      // For mobile platforms, use fromFile
      return await dio.MultipartFile.fromFile(
        thumbnailFile.path,
        filename: 'thumbnail.jpg',
      );
    }
  }

  Future<List<dynamic>> fetchAttachmentData(iVideoId) async {
    HttpService httpService = HttpService();
    var oResult =
        await httpService.getRequest("/video/app-attachment/$iVideoId");
    print(oResult);
    if (oResult['iTrue']) {
      return oResult['data']['body'];
    } else {
      throw Exception('Failed to fetch attachment data');
    }
  }
}
