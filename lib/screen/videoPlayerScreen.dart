import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wellness_app/controller/VideoCustomPlayerController.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:wellness_app/http/JwtToken.dart';

class VideoPlayerScreen extends StatefulWidget {
  final int videoId;

  VideoPlayerScreen({required this.videoId});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final VideoCustomPlayerController _videoCustomPlayerController =
      Get.put(VideoCustomPlayerController());
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  late ChewieController _chewieController;
  var aVideoAttachmentData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  fetchData() async {
    _videoCustomPlayerController.fetchVideoDataById(widget.videoId);
    aVideoAttachmentData = await _videoCustomPlayerController
        .fetchVideoAttachmentByVideoId(widget.videoId);
    await _videoCustomPlayerController.fetchCommentsByVideoId(widget.videoId);
    setState(() {});
  }

  void _initializeVideo(String videoUrl) {
    _videoController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          looping: false,
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;

    return Scaffold(
      backgroundColor: Color(0xFF0D1B2A), // Dark blue background color
      appBar: AppBar(
        elevation: 0.6,
        shadowColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            ),
            Image.asset(
              'assets/images/new_logo.png',
              width: dWidth > 900 ? dWidth * 0.1 : dWidth * 0.3,
              height: dHeight * 0.1,
              fit: BoxFit.cover,
              color: Colors.white,
            ),
          ],
        ),
        backgroundColor: Color(0xFF0D1B2A),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (_videoCustomPlayerController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          var video = _videoCustomPlayerController.videosPlayerData.isNotEmpty
              ? _videoCustomPlayerController.videosPlayerData[0]
              : null;

          if (video == null) {
            return const Center(child: Text('No video data available'));
          }
          if (!_isVideoInitialized) {
            _initializeVideo(video.video_url);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    // shadowColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    color: Color(0xFF1B263B), // Darker card color
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isVideoInitialized)
                          AspectRatio(
                            aspectRatio: _videoController.value.aspectRatio,
                            child: Chewie(controller: _chewieController),
                          )
                        else
                          Container(
                            height: 200,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                style: TextStyle(
                                  fontFamily: 'Playwrite NL',
                                  fontSize: dWidth > 900
                                      ? dWidth * 0.015
                                      : dWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                video.description,
                                style: TextStyle(
                                  fontFamily: 'Playwrite NL',
                                  fontSize: dWidth > 900
                                      ? dWidth * 0.015
                                      : dWidth * 0.025,
                                  color: Colors.grey[300],
                                ),
                              ),
                              SizedBox(height: dWidth * 0.09),
                              Obx(
                                () => _videoCustomPlayerController
                                        .isVideoAttachment.value
                                    ? SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: aVideoAttachmentData
                                              .map<Widget>((attachment) =>
                                                  buildAttachment(attachment))
                                              .toList(),
                                        ),
                                      )
                                    : SizedBox(height: 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.grey),
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontFamily: 'Playwrite NL',
                      fontSize: dWidth > 900 ? dWidth * 0.015 : dWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _videoCustomPlayerController.commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      filled: true,
                      fillColor: Color(0xFF1B263B),
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Playwrite NL',
                      fontSize: dWidth > 900 ? dWidth * 0.015 : dWidth * 0.03,
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E86AB), // Button color
                      ),
                      onPressed: () async {
                        final comment =
                            _videoCustomPlayerController.commentController.text;
                        if (comment.isNotEmpty) {
                          var oResult = await _videoCustomPlayerController
                              .addComment(comment, widget.videoId);
                          if (oResult) {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: "Comment Added.",
                                autoCloseDuration: Duration(seconds: 2),
                                showConfirmBtn: false);
                            Future.delayed(Duration(seconds: 2), () {
                              _videoCustomPlayerController
                                  .fetchCommentsByVideoId(widget.videoId);
                            });
                          } else {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                text: "Error while Posting.",
                                title: 'Oops...',
                                backgroundColor: Colors.black,
                                titleColor: Colors.white,
                                textColor: Colors.white);
                          }
                        }
                      },
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Playwrite NL',
                          fontSize:
                              dWidth > 900 ? dWidth * 0.015 : dWidth * 0.03,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200, // Adjust height as needed
                    child: Obx(() {
                      return ListView.builder(
                        itemCount:
                            _videoCustomPlayerController.comments.value.length,
                        itemBuilder: (context, index) {
                          var comment = _videoCustomPlayerController
                              .comments.value[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFF1B263B), // Darker card color
                              borderRadius: BorderRadius.circular(10),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.5),
                              //     spreadRadius: 1,
                              //     blurRadius: 5,
                              //     offset: Offset(0, 3), // changes position of shadow
                              //   ),
                              // ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment['user_name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Playwrite NL',
                                    fontSize: dWidth > 900
                                        ? dWidth * 0.015
                                        : dWidth * 0.03,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  comment['comment'],
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontFamily: 'Playwrite NL',
                                    fontSize: dWidth > 900
                                        ? dWidth * 0.015
                                        : dWidth * 0.026,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  comment['user_type'] == 1
                                      ? 'Super-Admin'
                                      : 'User',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontFamily: 'Playwrite NL',
                                    fontSize: dWidth > 900
                                        ? dWidth * 0.015
                                        : dWidth * 0.02,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  Widget buildAttachment(Map<String, dynamic> attachment) {
    return GestureDetector(
      onTap: () async {},
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E86AB), // Button color
              ),
              onPressed: () async {
                final url = attachment['attachment_url'];
                print(Uri.parse(url));
                FileDownloader.downloadFile(
                  url: url,
                  headers: {'Authorization': (JwtToken().generateJWT())},
                  name: attachment['attachment_name'],
                  notificationType: NotificationType.all,
                );
              },
              icon: Icon(
                Icons.download,
                color: Colors.white,
                size: Get.width > 900 ? Get.width * 0.015 : Get.width * 0.035,
              ),
              label: Text(
                attachment['attachment_name'],
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Playwrite NL',
                  fontSize:
                      Get.width > 900 ? Get.width * 0.015 : Get.width * 0.025,
                ),
              ),
            ),
          ),
          SizedBox(width: 8), // Add space between each attachment button
        ],
      ),
    );
  }
}
