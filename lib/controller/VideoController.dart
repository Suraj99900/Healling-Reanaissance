import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wellness_app/controller/configController.dart';
import 'package:wellness_app/http/http_service.dart';
import 'package:wellness_app/modal/videoModal.dart';
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
    // Reset progress
    uploadProgress.value = 0.0;

    // Validate form & file presence
    if (videoFormKey.currentState!.validate() &&
        videoFile != null &&
        thumbnailFile != null) {
      videoFormKey.currentState!.save();

      try {
        // Cloudflare account details
        final String accountId = 'fb7a71755b954e7437ebc8bec3d4207f';
        final String apiToken = 'iIzh4OK41VoQu0KyQOzf2tTxpzsDK_OnfYNn_IXi';

        // Prepare a local directory to use as the TUS store
        final tempDir = await getTemporaryDirectory();
        final tempDirectory =
            Directory('${tempDir.path}/${videoFile.name}_uploads');
        if (!tempDirectory.existsSync()) {
          tempDirectory.createSync(recursive: true);
        }

        // Initialize tus upload
        final tusClient = TusClient(
          videoFile,
          store: TusFileStore(tempDirectory),
          maxChunkSize: 5 * 1024 * 1024, // 5MB chunk (as in your JS code)
        );

        await tusClient.upload(
          onStart: (TusClient client, Duration? estimation) {
            // Log upload start and estimated time if available
            print("TUS upload starting. Estimated time: $estimation");
          },
          onProgress: (progress, estimate) {
            // progress is a value between 0.0 and 1.0
            print("Progress: $progress");
            uploadProgress.value = progress;
          },
          onComplete: () async {
            print("TUS upload completed!");
            // Delete the temporary upload folder
            tempDirectory.deleteSync(recursive: true);

            // Extract video ID from the upload URL
            final cloudflareVideoId = tusClient.uploadUrl!.pathSegments.last;

            // Fetch stream details from Cloudflare
            final streamResponse = await dioInstance.get(
              'https://api.cloudflare.com/client/v4/accounts/$accountId/stream/$cloudflareVideoId',
              options: dio.Options(
                headers: {
                  'Authorization': 'Bearer $apiToken',
                },
              ),
            );

            if (streamResponse.statusCode == 200) {
              final streamDetails = streamResponse.data['result'];
              final streamDetailsJson = jsonEncode(streamDetails);

              // Build FormData to send to your backend
              dio.FormData formData = dio.FormData.fromMap({
                'title': title.value,
                'description': description.value,
                'category_id': categoryId.value.toString(),
                'cloudflare_video_id': cloudflareVideoId,
                'video_json_data': streamDetailsJson,
                'thumbnail': await _getThumbnailMultipartFile(thumbnailFile),
              });

              HttpService httpService = HttpService();
              dio.Response response = await dioInstance.post(
                kIsWeb
                    ? (ConfigController().getCorssURL() +
                        '${httpService.sBaseUrl}/video')
                    : '${httpService.sBaseUrl}/video',
                data: formData,
                options: dio.Options(
                  headers: {
                    'Authorization': 'Bearer ${httpService.sToken}',
                    'Content-Type': 'multipart/form-data'
                  },
                ),
                onSendProgress: (int sent, int total) {
                  // Optionally, track upload progress of the form data
                  print('Sent: $sent, Total: $total');
                },
              );

              if (response.statusCode == 200 || response.statusCode == 201) {
                oResultData.value = 'Video uploaded successfully!';
                iAddedId = response.data['body']['id'];

                // Handle attachments if necessary
                var bAttachment = await addAttachment(iAddedId);
                if (bAttachment) {
                  // Optionally update progress to complete
                  uploadProgress.value = 1.0;
                  return true;
                } else {
                  oResultData.value = 'Error uploading attachments';
                  return false;
                }
              } else {
                oResultData.value =
                    'Error uploading video: ${response.statusCode}';
                uploadProgress.value = 0.0;
                return false;
              }
            } else {
              oResultData.value =
                  'Error fetching stream details: ${streamResponse.statusCode}';
              uploadProgress.value = 0.0;
              return false;
            }
          },
          // Use the Cloudflare endpoint without the "/tus" suffix as in your JS example
          uri: Uri.parse(
              'https://api.cloudflare.com/client/v4/accounts/$accountId/stream'),
          metadata: {
            'name': videoFile.name,
            'filetype': videoFile.mimeType ?? 'application/octet-stream',
          },
          headers: {
            'Authorization': 'Bearer $apiToken',
          },
          measureUploadSpeed: true,
        );

        // If the upload completes successfully, the onComplete callback returns
        // an answer; if execution reaches here, it means the callback did not return.
        return true;
      } catch (e) {
        print('Error uploading video: $e');
        oResultData.value = 'Error uploading video: $e';
        uploadProgress.value = 0.0;
        return false;
      }
    } else {
      // Invalid form or missing file
      uploadProgress.value = 0.0;
      oResultData.value =
          'Please fill all fields and select a video + thumbnail';
      return false;
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
