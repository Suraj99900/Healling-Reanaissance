import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wellness_app/controller/VideoController.dart';
import 'package:wellness_app/route/route.dart';

class UpdateVideoScreen extends StatefulWidget {
  final int videoId;

  const UpdateVideoScreen({super.key, required this.videoId});

  @override
  _UpdateVideoScreenState createState() => _UpdateVideoScreenState();
}

class _UpdateVideoScreenState extends State<UpdateVideoScreen> {
  final VideoController _videoController = Get.put(VideoController());
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  var _categoryIdController;
  XFile? _videoFile;
  XFile? _thumbnailFile;
  var videoData;
  List attachments = [];

  @override
  void initState() {
    super.initState();
    _fetchVideoData();
  }

  Future<void> _fetchVideoData() async {
    try {
      videoData = await _videoController.fetchVideoById(widget.videoId);
      videoData = videoData[0];
      _titleController = TextEditingController(text: videoData['title']);
      _descriptionController =
          TextEditingController(text: videoData['description']);
      _categoryIdController = videoData['category_id'];
      attachments = await _videoController
          .fetchAttachmentData(widget.videoId); // Fetch attachments

      setState(() {});
    } catch (e) {
      print(e);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Failed to fetch video data.',
      );
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      _videoFile = pickedFile;
    });
  }

  Future<void> _pickThumbnail() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _thumbnailFile = pickedFile;
    });
  }

  Future<void> _pickAttachment(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickMedia();
    setState(() {
      _videoController.aAttachmentFiles[index] = pickedFile;
    });
  }

  void _addAttachmentField() {
    setState(() {
      _videoController.aAttachmentFiles.add(null);
    });
  }

  Future<void> _deleteAttachment(int id, index) async {
    setState(() {
      attachments.removeAt(index);
    });
    _videoController.deleteAttachment(id); // Delete on server
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1B263B),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            ),
            Column(
              children: [
                Image.asset(
                  'assets/images/new_logo.png',
                  width: dWidth > 900 ? dWidth * 0.1 : dWidth * 0.3,
                  height: dHeight * 0.1,
                  fit: BoxFit.cover,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: videoData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: dHeight * 0.1,
                      ),
                      Center(
                        child: Container(
                          width: dWidth >= 850 ? dWidth * 0.6 : dWidth * 0.9,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(70, 0, 0, 0),
                                spreadRadius: 0,
                                blurRadius: 20,
                                offset: Offset(10, 10),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF1B263B),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Form(
                              key: _videoController.videoFormKey,
                              child: Column(
                                children: [
                                  Text(
                                    "Update Video",
                                    style: GoogleFonts.arsenal(
                                      textStyle: TextStyle(
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.02
                                            : dWidth * 0.05,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03),
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      labelText: 'Video Title',
                                      hintText: 'Enter Video Title',
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter the video title';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03),
                                    controller: _descriptionController,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      hintText: 'Enter Description',
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter the description';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  FutureBuilder(
                                    future: _videoController.fetchCategories(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else {
                                        return DropdownButtonFormField<int>(
                                          decoration: InputDecoration(
                                            labelText: 'Category',
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: dWidth > 900
                                                  ? dWidth * 0.015
                                                  : dWidth * 0.03,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.white70),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          dropdownColor:
                                              const Color(0xFF1B263B),
                                          value: _categoryIdController,
                                          items: _videoController.categories
                                              .map((category) {
                                            return DropdownMenuItem<int>(
                                              value: category['id'],
                                              child: Text(
                                                category['name'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: dWidth > 900
                                                      ? dWidth * 0.015
                                                      : dWidth * 0.03,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            _videoController.categoryId.value =
                                                value!;
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select a category';
                                            }
                                            return null;
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  // Displaying existing attachments from server
                                  Column(
                                    children: attachments
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int index = entry.key;
                                      var attachment = entry.value;
                                      return Card(
                                        color: const Color(0xFF1B263B),
                                        child: ListTile(
                                          title: Text(
                                            'Attachment: ${attachment['attachment_name']}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: dWidth > 900
                                                    ? dWidth * 0.015
                                                    : dWidth * 0.03),
                                          ),
                                          subtitle: Text(
                                            'URL: ${attachment['attachment_url']}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: dWidth > 900
                                                    ? dWidth * 0.015
                                                    : dWidth * 0.03),
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: dWidth > 900
                                                  ? dWidth * 0.015
                                                  : dWidth * 0.05,
                                            ),
                                            onPressed: () => _deleteAttachment(
                                                attachment['id'], index),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  Column(
                                    children: _videoController.aAttachmentFiles
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int index = entry.key;
                                      XFile? file = entry.value;
                                      return Column(
                                        children: [
                                          Card(
                                            color: const Color(0xFF1B263B),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Attachment Name',
                                                    hintText:
                                                        'Enter Attachment Name',
                                                    labelStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: dWidth > 900
                                                          ? dWidth * 0.015
                                                          : dWidth * 0.03,
                                                    ),
                                                    hintStyle: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: dWidth > 900
                                                          ? dWidth * 0.015
                                                          : dWidth * 0.03,
                                                    ),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.white70),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.blue),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter the Attachment Name';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _videoController
                                                        .sAttachmentName
                                                        .add(value!);
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                ListTile(
                                                  title: file != null
                                                      ? Text(
                                                          'Attachment: ${file.name}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                                  dWidth > 900
                                                                      ? dWidth *
                                                                          0.015
                                                                      : dWidth *
                                                                          0.03),
                                                        )
                                                      : Text(
                                                          'No file selected',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                                  dWidth > 900
                                                                      ? dWidth *
                                                                          0.015
                                                                      : dWidth *
                                                                          0.03),
                                                        ),
                                                  trailing: IconButton(
                                                    icon: Icon(
                                                      Icons.attach_file,
                                                      color: Colors.white,
                                                      size: dWidth > 900
                                                          ? dWidth * 0.015
                                                          : dWidth * 0.05,
                                                    ),
                                                    onPressed: () =>
                                                        _pickAttachment(index),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextButton.icon(
                                    onPressed: _addAttachmentField,
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: dWidth > 900
                                          ? dWidth * 0.015
                                          : dWidth * 0.05,
                                    ),
                                    label: Text(
                                      'Add Attachment',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Obx(() {
                                    return _videoController
                                            .isUpdatingVideo.value
                                        ? const CircularProgressIndicator()
                                        : ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF506D8B),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0,
                                                  horizontal: dWidth > 900
                                                      ? dWidth * 0.04
                                                      : dWidth * 0.06),
                                            ),
                                            onPressed: () async {
                                              _videoController
                                                  .setUpdatingVideoProgress(
                                                      true);
                                              var oResult =
                                                  await _videoController
                                                      .updateVideo(
                                                widget.videoId,
                                                _titleController.text,
                                                _descriptionController.text,
                                              );
                                              _videoController
                                                  .setUpdatingVideoProgress(
                                                      false);

                                              if (oResult) {
                                                QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.success,
                                                  text:
                                                      'Video updated successfully!',
                                                  autoCloseDuration:
                                                      const Duration(
                                                          seconds: 2),
                                                  showConfirmBtn: false,
                                                );

                                                Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                  Get.offNamed(
                                                      AppRoutes.videoManage);
                                                });
                                              } else {
                                                QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.error,
                                                  title: 'Oops...',
                                                  text: _videoController
                                                      .oResultData.value,
                                                  backgroundColor: Colors.black,
                                                  titleColor: Colors.white,
                                                  textColor: Colors.white,
                                                );
                                              }
                                            },
                                            icon:
                                                const Icon(Icons.arrow_upward),
                                            label: Text(
                                              "Update",
                                              style: TextStyle(
                                                fontFamily: 'Playwrite NL',
                                                fontSize: dWidth > 900
                                                    ? dWidth * 0.015
                                                    : dWidth * 0.03,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                  }),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Get.offNamed(AppRoutes.videoManage);
                                    },
                                    icon: const Icon(Icons.list),
                                    label: Text(
                                      "Video List",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: "Manrope",
                                        fontSize: dWidth >= 550 ? 16 : 8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
