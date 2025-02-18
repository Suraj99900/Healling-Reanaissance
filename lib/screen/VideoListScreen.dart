import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:wellness_app/controller/VideoController.dart';
import 'package:wellness_app/controller/configController.dart';
import 'package:wellness_app/screen/commonfunction.dart';
import 'package:wellness_app/screen/videoPlayerScreen.dart';

class VideoListScreen extends StatelessWidget {
  final int categoryId;
  final VideoController _videoController = Get.put(VideoController());
  final TextEditingController _searchController = TextEditingController();

  VideoListScreen({super.key, required this.categoryId}) {
    _videoController.fetchVideosByCategoryId(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 240, 241),
      appBar: AppBar(
        elevation: 0.6,
        shadowColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 254, 254, 255),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: const Color.fromARGB(255, 255, 250, 250),
              controller: _searchController,
              onSubmitted: (text) {
                _videoController.searchVideos(text, categoryId);
              },
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              decoration: InputDecoration(
                hintText: 'Search Videos',
                hintStyle: TextStyle(
                  fontFamily: 'Playwrite NL',
                  fontSize: dWidth > 900 ? dWidth * 0.015 : dWidth * 0.04,
                  color: const Color.fromARGB(255, 255, 250, 250),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    _videoController.searchVideos(
                        _searchController.text, categoryId);
                  },
                ),
                filled: true,
                fillColor: const Color.fromARGB(240, 50, 50, 51),
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
          return const Center(child: CircularProgressIndicator());
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
                      color: const Color.fromARGB(255, 0, 0, 0),
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
                      linearGradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                              Color.fromARGB(6, 243, 239, 244),
                              Color.fromARGB(8, 0, 0, 0),
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
                                (kIsWeb) ? (new ConfigController()).getCorssURL() +video.thumbnail :video.thumbnail,
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
                                      color: const Color.fromARGB(255, 0, 0, 0),
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
                                      color: const Color.fromARGB(255, 0, 0, 0),
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
                                      color: const Color.fromARGB(179, 0, 0, 0),
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
