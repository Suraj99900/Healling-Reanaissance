import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wellness_app/controller/VideoController.dart';
import 'package:wellness_app/controller/configController.dart';
import 'package:wellness_app/screen/videoPlayerScreen.dart';

class VideoListScreen extends StatelessWidget {
  final int? categoryId;
  final VideoController _videoController = Get.put(VideoController());
  final TextEditingController _searchController = TextEditingController();

  VideoListScreen({super.key, this.categoryId}) {
    if (categoryId == null || categoryId == '') {
      _videoController.searchVideos("", 0);
    } else {
      _videoController.fetchVideosByCategoryId(categoryId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FBFF), Color.fromARGB(255, 234, 201, 244)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (text) {
                _videoController.searchVideos(text, categoryId ?? 0);
              },
              decoration: InputDecoration(
                hintText: 'Search Videos',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    _videoController.searchVideos(
                        _searchController.text, categoryId ?? 0);
                  },
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FBFF), Color.fromARGB(255, 234, 201, 244)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Obx(() {
          if (_videoController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (_videoController.videos.isEmpty) {
            return const Center(child: Text('No videos found'));
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
                    elevation: 6,
                    shadowColor: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 2), // Border color and width
                              borderRadius: BorderRadius.circular(10), // Match border radius with ClipRRect
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                (kIsWeb)
                                    ? (ConfigController()).getCorssURL() + video.thumbnail
                                    : video.thumbnail,
                                width: dWidth * 0.40,
                                height: 130,
                                fit: BoxFit.fill,
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
                                      fontSize: 18,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    video.description,
                                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Uploaded on: ${DateFormat.yMMMd().format(video.addedOn)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
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