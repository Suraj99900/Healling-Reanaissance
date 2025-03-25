import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:healing_renaissance/controller/VideoCustomPlayerController.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:healing_renaissance/controller/configController.dart';
import 'package:healing_renaissance/http/JwtToken.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:healing_renaissance/screen/commonfunction.dart';

class VideoPlayerScreen extends StatefulWidget {
  final int videoId;
  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final VideoCustomPlayerController _videoController =
      Get.put(VideoCustomPlayerController());
  late VideoPlayerController _playerController;
  bool _isVideoInitialized = false;
  late ChewieController _chewieController;
  var videoData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    if (_isVideoInitialized) {
      _playerController.pause();
      _chewieController.dispose();
      _playerController.dispose();
    }
    super.dispose();
  }

  fetchData() async {
    _videoController.fetchVideoDataById(widget.videoId);
    videoData = await _videoController.fetchVideoAttachmentByVideoId(widget.videoId);
    await _videoController.fetchCommentsByVideoId(widget.videoId);
    setState(() {});
  }

  void _initializeVideo(String videoUrl) {
    print(videoUrl);
    _playerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _chewieController = ChewieController(
          aspectRatio: _playerController.value.aspectRatio,
          autoInitialize: true,
          allowedScreenSleep: true,
          draggableProgressBar: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: Colors.red,
            handleColor: Colors.red,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.grey,
          ),
          bufferingBuilder: (context) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          showControls: true,
          allowMuting: true,
          allowFullScreen: true,
          allowPlaybackSpeedChanging: true,
          videoPlayerController: _playerController,
          autoPlay: true,
          looping: true,
        );
      }).catchError((error) {
        print("Error initializing video: $error");
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Error loading video. Please try again later.",
          title: 'Oops...',
          backgroundColor: Colors.black,
          titleColor: Colors.white,
          textColor: Colors.white,
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Video Player', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (_videoController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        var video = _videoController.videosPlayerData.isNotEmpty
            ? _videoController.videosPlayerData[0]
            : null;

        if (video == null) {
          return const Center(child: Text('No video available', style: TextStyle(color: Colors.white)));
        }
        print(video);
        print(video.hlsUrl);
        var videoUrl = kIsWeb
            ? (ConfigController()).getCorssURL() + video.hlsUrl
            : video.hlsUrl;
        if (!_isVideoInitialized) _initializeVideo(videoUrl);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Player Section with black background
              _isVideoInitialized
                  ? Container(
                      color: Colors.black,
                      child: AspectRatio(
                        aspectRatio: _playerController.value.aspectRatio,
                        child: Chewie(controller: _chewieController),
                      ),
                    )
                  : SizedBox(
                      height: 200,
                      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                    ),
              // Details & Comments Section with gradient background and rounded top corners
              Container(
                width: dWidth,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF89CFF0), Color(0xFFB19CD9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Title
                    Text(
                      video.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 8),
                    // Video Description
                    Text(
                      video.description,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    // Attachments Section
                    _buildAttachments(),
                    const SizedBox(height: 40),
                    // Comments Section Header
                    const Text(
                      'Comments',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    // Comment Input Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _videoController.commentController,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              hintStyle: TextStyle(color: Colors.grey[700]),
                              filled: true,
                              fillColor: const Color.fromARGB(255, 250, 249, 249),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 226, 228, 229),
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          ),
                          onPressed: () async {
                            final comment = _videoController.commentController.text;
                            if (comment.isNotEmpty) {
                              var success = await _videoController.addComment(comment, widget.videoId);
                              if (success) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  text: "Comment Added.",
                                  autoCloseDuration: const Duration(seconds: 2),
                                  showConfirmBtn: false,
                                );
                                Future.delayed(const Duration(seconds: 2), () {
                                  _videoController.fetchCommentsByVideoId(widget.videoId);
                                });
                              } else {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  text: "Error while Posting.",
                                  title: 'Oops...',
                                  backgroundColor: Colors.black,
                                  titleColor: Colors.white,
                                  textColor: Colors.white,
                                );
                              }
                            }
                          },
                          child: const Text('Post', style: TextStyle(color: Colors.black87)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    // Comments List
                    _buildCommentsSection(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAttachments() {
    return videoData == null
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Attachments:',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: videoData
                    .map<Widget>(
                      (attachment) => ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 251, 246, 246),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          downloadFile(attachment['attachment_url']);
                        },
                        icon: const Icon(Icons.download, color: Colors.black87),
                        label: Text(
                          attachment['attachment_name'],
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
  }

  Future<void> downloadFile(String url) async {
    try {
      Dio dio = Dio();
      // Extract filename from URL
      Uri uri = Uri.parse(url);
      String filename = uri.pathSegments.last;

      if (kIsWeb) {
        await LaunchURL(url);
      } else {
        // Request storage permission for Android
        if (Platform.isAndroid) {
          var status = await Permission.storage.request();
          if (!status.isGranted) {
            print("Storage permission denied");
            return;
          }
        }

        Directory? dir;
        if (Platform.isAndroid) {
          dir = Directory("/storage/emulated/0/Download");
        } else if (Platform.isIOS) {
          dir = await getApplicationDocumentsDirectory();
        }

        if (dir == null) throw Exception("Could not find storage directory");

        String filePath = "${dir.path}/$filename";
        print("Saving to: $filePath");

        await dio.download(
          url,
          filePath,
          options: Options(
            headers: {'Authorization': JwtToken().generateJWT()},
          ),
        );

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "File Downloaded Successfully!\nSaved to: $filePath",
          autoCloseDuration: const Duration(seconds: 2),
          showConfirmBtn: false,
        );
      }
    } catch (e) {
      print("Download error: $e");
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: "Error while downloading.",
        title: 'Oops...',
        backgroundColor: Colors.black,
        titleColor: Colors.white,
        textColor: Colors.white,
      );
    }
  }

  Widget _buildCommentsSection() {
    return Obx(() {
      return _videoController.comments.isEmpty
          ? Center(
              child: Text(
                "No comments yet. Be the first!",
                style: TextStyle(color: Colors.black87),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _videoController.comments.length,
              itemBuilder: (context, index) {
                var comment = _videoController.comments[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              comment['user_name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              comment['user_type'] == 1 ? 'Super-Admin' : 'User',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          comment['comment'],
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
    });
  }
}
