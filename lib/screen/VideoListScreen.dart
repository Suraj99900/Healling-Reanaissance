import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_renaissance/screen/commonfunction.dart';
import 'package:intl/intl.dart';
import 'package:healing_renaissance/SharedPreferencesHelper.dart';
import 'package:healing_renaissance/controller/VideoController.dart';
import 'package:healing_renaissance/controller/configController.dart';
import 'package:healing_renaissance/screen/videoPlayerScreen.dart';

class VideoListScreen extends StatefulWidget {
  final int? categoryId;
  
  const VideoListScreen({super.key, this.categoryId});

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final VideoController _videoController = Get.put(VideoController());
  final TextEditingController _searchController = TextEditingController();
  String? userType;

  @override
  void initState() {
    super.initState();
    loadStoredPreference();
    if (widget.categoryId != null) {
      _videoController.fetchVideosByCategoryId(widget.categoryId!);
    }
  }

  Future<void> loadStoredPreference() async {
    String? storedUserType = await SharedPreferencesHelper.getUserType("sUserType");
    setState(() {
      userType = storedUserType;
    });
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF89CFF0), Color(0xFFB19CD9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Videos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        bottom: userType == "1"
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (text) {
                        _videoController.searchVideos(text);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Videos',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.black54),
                          onPressed: () {
                            _videoController.searchVideos(_searchController.text);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFE1BEE7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Obx(() {
          if (_videoController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (_videoController.videos.isEmpty) {
            return const Center(child: Text('No videos found', style: TextStyle(fontSize: 16)));
          } else {
            return ListView.builder(
              itemCount: _videoController.videos.length,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemBuilder: (context, index) {
                var video = _videoController.videos[index];
                return GestureDetector(
                  onTap: () => Get.to(() => VideoPlayerScreen(videoId: video.id)),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black26,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: dWidth * 0.40,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    kIsWeb
                                        ? (ConfigController()).getCorssURL() + video.thumbnailUrl
                                        : video.thumbnailUrl,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.6)],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    video.description,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    formatDuration(double.tryParse(video.duration) ?? 0.0),
                                    style: const TextStyle(
                                        color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Uploaded on: ${DateFormat.yMMMd().format(video.addedOn)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54, fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }
}
