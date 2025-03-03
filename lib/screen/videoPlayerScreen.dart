import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wellness_app/controller/VideoCustomPlayerController.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart'; // Import dio for downloading files
import 'package:wellness_app/controller/configController.dart';
import 'package:wellness_app/http/JwtToken.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wellness_app/screen/commonfunction.dart';

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
    _playerController.pause();
    _chewieController.dispose();
    _playerController.dispose();
    super.dispose();
  }

  fetchData() async {
    _videoController.fetchVideoDataById(widget.videoId);
    videoData =
        await _videoController.fetchVideoAttachmentByVideoId(widget.videoId);
    await _videoController.fetchCommentsByVideoId(widget.videoId);
    setState(() {});
  }

  void _initializeVideo(String videoUrl) {
    _playerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() => _isVideoInitialized = true);
        _chewieController = ChewieController(
          videoPlayerController: _playerController,
          autoPlay: true,
          looping: false,
          allowFullScreen: true,
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FBFF), Color.fromARGB(255, 234, 201, 244)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (_videoController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var video = _videoController.videosPlayerData.isNotEmpty
            ? _videoController.videosPlayerData[0]
            : null;
        if (video == null) {
          return const Center(
              child: Text('No video available',
                  style: TextStyle(color: Colors.white)));
        }
        if (!_isVideoInitialized) _initializeVideo(video.video_url);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8FBFF),
                Color.fromARGB(255, 234, 201, 244),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_isVideoInitialized)
                  AspectRatio(
                    aspectRatio: _playerController.value.aspectRatio,
                    child: Chewie(controller: _chewieController),
                  )
                else
                  SizedBox(
                    height: 200,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      const SizedBox(height: 12),
                      Divider(color: Colors.grey[800]),
                      Text(
                        video.description,
                        style: const TextStyle(
                            color: Color.fromARGB(179, 7, 7, 7)),
                      ),
                      const SizedBox(height: 20),
                      _buildAttachments(),
                      const SizedBox(height: 20),
                      _buildCommentsSection(),
                    ],
                  ),
                ),
              ],
            ),
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
              const Text('Attachments:',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                children: videoData
                    .map<Widget>(
                        (attachment) => _buildAttachmentButton(attachment))
                    .toList(),
              ),
            ],
          );
  }

  // Updated method to use dio for file download
  Future<void> downloadFile(String url) async {
    try {
      Dio dio = Dio();

      // Extract filename from URL
      Uri uri = Uri.parse(url);
      String filename =
          uri.pathSegments.last; // Keeps original filename & extension

      if (kIsWeb) {
        await LaunchURL(url);
      } else {
        // Request storage permission (Android)
        if (Platform.isAndroid) {
          var status = await Permission.storage.request();
          if (!status.isGranted) {
            print("Storage permission denied");
            return;
          }
        }

        Directory? dir;

        if (Platform.isAndroid) {
          dir = Directory(
              "/storage/emulated/0/Download"); // Android Downloads Folder
        } else if (Platform.isIOS) {
          dir =
              await getApplicationDocumentsDirectory(); // iOS Documents Folder
        }

        if (dir == null) {
          throw Exception("Could not find storage directory");
        }

        String filePath =
            "${dir.path}/$filename"; // Save with original filename & extension
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

  Widget _buildAttachmentButton(Map<String, dynamic> attachment) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 251, 246, 246)),
        onPressed: () async {
          downloadFile(kIsWeb
              ? attachment['attachment_url']
              : attachment['attachment_url']);
        },
        icon: const Icon(Icons.download, color: Color.fromARGB(255, 0, 0, 0)),
        label: Text(attachment['attachment_name'],
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comments',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _videoController.commentController,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle:
                      TextStyle(color: const Color.fromARGB(255, 23, 23, 23)),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              onPressed: () async {
                final comment = _videoController.commentController.text;
                if (comment.isNotEmpty) {
                  var success = await _videoController.addComment(
                      comment, widget.videoId);
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
              child: const Text(
                'Post',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Obx(() {
          return _videoController.comments.isEmpty
              ? Center(
                  child: Text(
                    "No comments yet. Be the first!",
                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _videoController.comments.length,
                  itemBuilder: (context, index) {
                    var comment = _videoController.comments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment['user_name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 5, 5, 5),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                comment['user_type'] == 1
                                    ? 'Super-Admin'
                                    : 'User',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment['comment'],
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        }),
      ],
    );
  }
}
