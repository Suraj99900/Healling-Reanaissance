
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:wellness_app/SharedPreferencesHelper.dart';
import 'package:wellness_app/http/http_service.dart';
import 'package:wellness_app/modal/videoModal.dart';

class VideoCustomPlayerController extends GetxController {
  var title = ''.obs;
  var description = ''.obs;
  var categoryId = 0.obs;
  var video_url = ''.obs;
  var oResultData = ''.obs;
  var categories = [].obs;
  RxBool isVideoAttachment = false.obs;
  var commentController = TextEditingController();
  RxList comments = [].obs;

  var isLoading = true.obs;

  var videosPlayerData = <Video>[].obs;

  Future fetchVideoDataById(int videoId) async {
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
    } finally {
      isLoading(false);
    }
  }

  Future fetchVideoAttachmentByVideoId(int iVideoId) async {
    isLoading(true);
    try {
      HttpService httpService = HttpService();
      var oResult =
          await httpService.getRequest("/video/app-attachment/$iVideoId");

      if (oResult['iTrue']) {
        isVideoAttachment.value = true;
        return oResult['data']['body'];
      }
    } finally {
      isLoading(false);
    }
  }

  Future fetchCommentsByVideoId(int videoId) async {
    isLoading(true);
    try {
      HttpService httpService = HttpService();
      var oResult = await httpService.getRequest("/video/comment/$videoId");
 
      if (oResult['iTrue']) {
        print( oResult['data']['body']);
        comments.value = oResult['data']['body'];
      }
    } finally {
      isLoading(false);
    }
  }

  Future<bool> addComment(String comment, int videoId) async {
    isLoading(true);
    try {
      var iUserId = await SharedPreferencesHelper.getUserId('sUserId');
      HttpService httpService = HttpService();
      var oResult = await httpService.postRequest(
        "/video/comment",
        {
          'video_id': videoId,
          'user_id': iUserId,
          'comment': comment,
        },
      );

      if (oResult['iTrue']) {
        fetchCommentsByVideoId(videoId);
        commentController.clear();
      }
    } finally {
      isLoading(false);
      return true;
    }
  }
}
