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
    _playerController.dispose();
    _chewieController.dispose();
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
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        )
       
        
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

        return SingleChildScrollView(
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
                          color: Colors.white),
                    ),
                    
                    const SizedBox(height: 12),
                    Divider(color: Colors.grey[800]),
                    Text(
                      video.description,
                      style: const TextStyle(color: Colors.white70),
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
                      color: Colors.white,
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

  Widget _buildAttachmentButton(Map<String, dynamic> attachment) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
        onPressed: () async {
          FileDownloader.downloadFile(
            url: attachment['attachment_url'],
            headers: {'Authorization': (JwtToken().generateJWT())},
            name: attachment['attachment_name'],
          );
        },
        icon: const Icon(Icons.download, color: Colors.white),
        label: Text(attachment['attachment_name'],
            style: const TextStyle(color: Colors.white)),
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
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        // Comment Input Field with Post Button
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _videoController.commentController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[900],
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
                backgroundColor: const Color(0xFF2E86AB), // Button color
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              onPressed: () async {
                final comment =
                    _videoController.commentController.text;
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
                      _videoController
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
                      textColor: Colors.white,
                    );
                  }
                }
              },
              child: const Text(
                'Post',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Display Comments List
        Obx(() {
          return _videoController.comments.isEmpty
              ? Center(
                  child: Text(
                    "No comments yet. Be the first!",
                    style: TextStyle(color: Colors.grey[400]),
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
                        color: const Color(0xFF1B263B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment['user_name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment['comment'],
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment['user_type'] == 1 ? 'Super-Admin' : 'User',
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 12,
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
