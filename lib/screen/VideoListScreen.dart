import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:wellness_app/controller/VideoController.dart';
import 'package:wellness_app/screen/commonfunction.dart';
import 'package:wellness_app/screen/videoPlayerScreen.dart';

class VideoListScreen extends StatelessWidget {
  final int categoryId;
  final VideoController _videoController = Get.put(VideoController());
  final TextEditingController _searchController = TextEditingController();

  VideoListScreen({required this.categoryId}) {
    _videoController.fetchVideosByCategoryId(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;

    return Scaffold(
      backgroundColor: Color(0xFF0D1B2A),
      appBar: AppBar(
        elevation: 0.6,
        shadowColor: Colors.black,
        backgroundColor: Color(0xFF0D1B2A),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Colors.white,
              controller: _searchController,
              onSubmitted: (text) {
                _videoController.searchVideos(text, categoryId);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search Videos',
                hintStyle: TextStyle(
                  fontFamily: 'Playwrite NL',
                  fontSize: dWidth > 900 ? dWidth * 0.015 : dWidth * 0.04,
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    _videoController.searchVideos(
                        _searchController.text, categoryId);
                  },
                ),
                filled: true,
                fillColor: const Color(0xFF2E2E3A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (_videoController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (_videoController.videos.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/website_maintenance.gif'),
                  Text(
                    'No videos found for this category',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: dWidth > 900 ? dWidth * 0.02 : dWidth * 0.06,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: _videoController.videos.length,
              itemBuilder: (context, index) {
                var video = _videoController.videos[index];
                return GestureDetector(
                  onTap: () async {
                    Get.to(() => VideoPlayerScreen(videoId: video.id));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GlassmorphicContainer(
                      width: double.infinity,
                      height: dHeight * 0.5,
                      borderRadius: 15,
                      blur: 20,
                      alignment: Alignment.bottomCenter,
                      border: 2,
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Color.fromARGB(255, 4, 1, 47).withOpacity(0.9),
                        ],
                        stops: [0.1, 1],
                      ),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          const Color.fromARGB(255, 98, 172, 210)
                              .withOpacity(0.5),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                video.thumbnail,
                                width: dWidth * 0.9,
                                height: dHeight * 0.3,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Playwrite NL',
                                      fontSize: dWidth > 900
                                          ? dWidth * 0.015
                                          : dWidth * 0.06,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    limitWords(video.description, 10),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Playwrite NL',
                                      fontSize: dWidth > 900
                                          ? dWidth * 0.015
                                          : dWidth * 0.04,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Uploaded on: ${DateFormat.yMMMd().format(video.addedOn)}',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontFamily: 'Playwrite NL',
                                      fontSize: dWidth > 900
                                          ? dWidth * 0.015
                                          : dWidth * 0.025,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      }),
    );
  }
}
