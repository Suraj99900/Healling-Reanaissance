import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:kavita_healling_reanaissance/controller/VideoTableController.dart';
import 'package:kavita_healling_reanaissance/controller/configController.dart';
import 'package:kavita_healling_reanaissance/modal/UploadedVideoModal.dart';
import 'package:kavita_healling_reanaissance/route/route.dart';
import 'package:kavita_healling_reanaissance/screen/updateVideoScreen.dart';

class VideoTable extends StatelessWidget {
  VideoTable({super.key});

  final VideoTableController controller = Get.put(VideoTableController());

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;
    return FutureBuilder(
      future: controller.fetchVideoData(),
      builder: (BuildContext context,
          AsyncSnapshot<List<UploadedVideoModal>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          controller.uploadedVideos.value = snapshot.data!;
          return Scaffold(
            backgroundColor: const Color(0xFF0D1B2A),
            appBar: AppBar(
              backgroundColor: const Color(0xFF0D1B2A),
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              elevation: 0.6,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Get.offNamed(AppRoutes.dashBoard);
                    },
                  ),
                  Image.asset(
                    'assets/images/internal_icon.png',
                    width: dWidth >= 850? dWidth * 0.4: dWidth * 0.2,
                    height: dHeight * 0.06,
                    fit: BoxFit.cover,
                    color: const Color.fromARGB(255, 255, 255, 255)
                  ),
                ],
              ),
              
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 20,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  columnSpacing: 10,
                  horizontalMargin: 10,
                  header: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                             Icon(Icons.video_camera_back_rounded,size: controller.sWidth > 900
                                      ? controller.sWidth * 0.01
                                      : controller.sWidth * 0.08,
                                  color: Colors.black),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Video Management",
                              style: GoogleFonts.arsenal(
                                textStyle: TextStyle(
                                  fontSize: controller.sWidth > 900
                                      ? controller.sWidth * 0.01
                                      : controller.sWidth * 0.04,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: controller.sWidth > 900
                                  ? controller.sWidth * 0.01
                                  : controller.sWidth * 0.03,
                            ),
                            IconButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.addVideo);
                              },
                              icon: Icon(
                                Icons.add_box_rounded,
                                size: controller.sWidth > 900
                                    ? controller.sWidth * 0.02
                                    : controller.sWidth * 0.08,
                                color: const Color.fromARGB(179, 2, 10, 122),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  source: VideoDataTableSource(controller.uploadedVideos.value),
                  columns: [
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Thumbnail',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arsenal(
                            textStyle: TextStyle(
                              fontSize:
                                  Get.find<VideoTableController>().sWidth > 900
                                      ? Get.find<VideoTableController>()
                                              .sWidth *
                                          0.015
                                      : controller.sWidth * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Name',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arsenal(
                            textStyle: TextStyle(
                              fontSize:
                                  Get.find<VideoTableController>().sWidth > 900
                                      ? Get.find<VideoTableController>()
                                              .sWidth *
                                          0.015
                                      : controller.sWidth * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Category Name',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arsenal(
                            textStyle: TextStyle(
                              fontSize:
                                  Get.find<VideoTableController>().sWidth > 900
                                      ? Get.find<VideoTableController>()
                                              .sWidth *
                                          0.015
                                      : controller.sWidth * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Upload Date',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arsenal(
                            textStyle: TextStyle(
                              fontSize:
                                  Get.find<VideoTableController>().sWidth > 900
                                      ? Get.find<VideoTableController>()
                                              .sWidth *
                                          0.015
                                      : controller.sWidth * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Action',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arsenal(
                            textStyle: TextStyle(
                              fontSize:
                                  Get.find<VideoTableController>().sWidth > 900
                                      ? Get.find<VideoTableController>()
                                              .sWidth *
                                          0.015
                                      : controller.sWidth * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  rowsPerPage: 10,
                  availableRowsPerPage: const [10, 20, 50],
                  onRowsPerPageChanged: (int? newRowsPerPage) {
                    if (newRowsPerPage != null) {
                      controller.rowCount.value = newRowsPerPage;
                    }
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class VideoDataTableSource extends DataTableSource {
  final List<UploadedVideoModal> videoList;

  VideoDataTableSource(this.videoList);

  @override
  DataRow getRow(int index) {
    UploadedVideoModal video = videoList[index];
    return DataRow(cells: [
      DataCell(
        Center(
          child: Image.network(
            kIsWeb?
            (new ConfigController()).getCorssURL()+video.thumbnail :video.thumbnail,
            width: 50,
            height: 50,
          ),
        ),
      ),
      DataCell(
        Center(
          child: Text(
            video.title,
            style: GoogleFonts.arsenal(
              textStyle: TextStyle(
                  fontSize: Get.find<VideoTableController>().sWidth > 900
                      ? Get.find<VideoTableController>().sWidth * 0.01
                      : Get.find<VideoTableController>().sWidth * 0.03),
            ),
          ),
        ),
      ),
      DataCell(
        Center(
          child: Text(
            video.categoryName,
            style: GoogleFonts.arsenal(
              textStyle: TextStyle(
                  fontSize: Get.find<VideoTableController>().sWidth > 900
                      ? Get.find<VideoTableController>().sWidth * 0.01
                      : Get.find<VideoTableController>().sWidth * 0.03),
            ),
          ),
        ),
      ),
      DataCell(
        Center(
          child: Text(
            video.uploadDate,
            style: GoogleFonts.arsenal(
              textStyle: TextStyle(
                  fontSize: Get.find<VideoTableController>().sWidth > 900
                      ? Get.find<VideoTableController>().sWidth * 0.01
                      : Get.find<VideoTableController>().sWidth * 0.03),
            ),
          ),
        ),
      ),
      DataCell(
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => UpdateVideoScreen(videoId: video.id));
                },
                icon: Icon(
                  Icons.edit,
                  size: Get.find<VideoTableController>().sWidth > 900
                      ? Get.find<VideoTableController>().sWidth * 0.01
                      : Get.find<VideoTableController>().sWidth * 0.04,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () async {
                  var oResult = await Get.find<VideoTableController>()
                      .deleteVideo(video.id);
                  if (oResult) {
                    QuickAlert.show(
                      context: Get.context!,
                      type: QuickAlertType.success,
                      text: 'Video deleted successfully!',
                      autoCloseDuration: const Duration(seconds: 2),
                      showConfirmBtn: false,
                    );
                    Get.toNamed(AppRoutes.dashBoard);
                  } else {
                    QuickAlert.show(
                      context: Get.context!,
                      type: QuickAlertType.error,
                      title: 'Oops...',
                      text: 'Failed to delete video.',
                      backgroundColor: Colors.black,
                      titleColor: Colors.white,
                      textColor: Colors.white,
                    );
                  }
                },
                icon: Icon(
                  Icons.delete,
                  size: Get.find<VideoTableController>().sWidth > 900
                      ? Get.find<VideoTableController>().sWidth * 0.01
                      : Get.find<VideoTableController>().sWidth * 0.04,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => videoList.length;

  @override
  int get selectedRowCount => 0;
}
