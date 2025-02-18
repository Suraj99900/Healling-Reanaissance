import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wellness_app/controller/VideoController.dart';
import 'package:wellness_app/route/route.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({super.key});

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final VideoController _videoController = Get.put(VideoController());
  final ImagePicker _picker = ImagePicker();
  XFile? _videoFile;
  XFile? _thumbnailFile;

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _videoFile = pickedFile;
    });
  }

  Future<void> _pickThumbnail() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _thumbnailFile = pickedFile;
    });
  }

  Future<void> _pickAttachment(int index) async {
    final pickedFile = await _picker.pickMedia();
    setState(() {
      _videoController.aAttachmentFiles[index] = pickedFile;
    });
  }

  void _addAttachmentField() {
    setState(() {
      _videoController.aAttachmentFiles.add(null);
    });
  }

    late Future<void> _categoriesFuture;
    @override
    void initState() {
      super.initState();
      _categoriesFuture = _videoController.fetchCategories();
      print(_categoriesFuture);
    }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: const Color.fromARGB(255, 254, 255, 255),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                  color: Colors.black,
                ),
              ],
            ),
          ],
        ),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
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
                      color: const Color.fromARGB(255, 253, 254, 254),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                        key: _videoController.videoFormKey,
                        child: Column(
                          children: [
                            Text(
                              "Add Video",
                              style: GoogleFonts.arsenal(
                                textStyle: TextStyle(
                                  fontSize: dWidth > 900
                                      ? dWidth * 0.02
                                      : dWidth * 0.05,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Title',
                                hintText: 'Enter Video Title',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: dWidth > 900
                                      ? dWidth * 0.015
                                      : dWidth * 0.03,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: dWidth > 900
                                      ? dWidth * 0.015
                                      : dWidth * 0.03,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the video title';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _videoController.title.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Description',
                                hintText: 'Enter Description',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: dWidth > 900
                                      ? dWidth * 0.015
                                      : dWidth * 0.03,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: dWidth > 900
                                      ? dWidth * 0.015
                                      : dWidth * 0.03,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.blue),
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
                              onSaved: (value) {
                                _videoController.description.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            FutureBuilder(
                              future: _categoriesFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      labelText: 'Category',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                                    items: _videoController.categories
                                        .map((category) {
                                      return DropdownMenuItem<int>(
                                        value: category['id'],
                                        child: Text(
                                          category['name'],
                                          style: TextStyle(
                                            color: Colors.black,
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
                            Card(
                              color: const Color.fromARGB(255, 243, 243, 243),
                              child: ListTile(
                                title: _videoFile != null
                                    ? Text(
                                        'Video: ${_videoFile!.name}',
                                        style: TextStyle(
                                          color: const Color.fromARGB(255, 0, 0, 0),
                                          fontSize: dWidth > 900
                                              ? dWidth * 0.015
                                              : dWidth * 0.03,
                                        ),
                                      )
                                    : Text(
                                        'No video selected',
                                        style: TextStyle(
                                          color: const Color.fromARGB(255, 0, 0, 0),
                                          fontSize: dWidth > 900
                                              ? dWidth * 0.015
                                              : dWidth * 0.03,
                                        ),
                                      ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.video_file,
                                    color: Colors.black,
                                    size: dWidth > 900
                                        ? dWidth * 0.015
                                        : dWidth * 0.05,
                                  ),
                                  onPressed: () => _pickVideo(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Card(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              child: ListTile(
                                title: _thumbnailFile != null
                                    ? Text(
                                        'Thumbnail: ${_thumbnailFile!.name}',
                                        style: TextStyle(
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                            fontSize: dWidth > 900
                                                ? dWidth * 0.015
                                                : dWidth * 0.03),
                                      )
                                    : Text(
                                        'No thumbnail selected',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: dWidth > 900
                                                ? dWidth * 0.015
                                                : dWidth * 0.03),
                                      ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.image,
                                    color: Colors.black,
                                    size: dWidth > 900
                                        ? dWidth * 0.015
                                        : dWidth * 0.05,
                                  ),
                                  onPressed: () => _pickThumbnail(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
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
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              labelText: 'Attachment Name',
                                              hintText: 'Enter Attachment Name',
                                              labelStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: dWidth > 900
                                                    ? dWidth * 0.015
                                                    : dWidth * 0.03,
                                              ),
                                              hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: dWidth > 900
                                                    ? dWidth * 0.015
                                                    : dWidth * 0.03,
                                              ),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(255, 227, 227, 228)),
                                                borderRadius: BorderRadius.all(
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
                                              _videoController.sAttachmentName
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
                                                        color: Colors.black,
                                                        fontSize: dWidth > 900
                                                            ? dWidth * 0.015
                                                            : dWidth * 0.03),
                                                  )
                                                : Text(
                                                    'No file selected',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: dWidth > 900
                                                            ? dWidth * 0.015
                                                            : dWidth * 0.03),
                                                  ),
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.attach_file,
                                                color: Colors.black,
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
                            TextButton.icon(
                              onPressed: _addAttachmentField,
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              label: Text(
                                'Add Attachment',
                                style: TextStyle(
                                  color: Colors.black,
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
                              return _videoController.isAddingVideo.value
                                  ? LinearProgressIndicator(
                                      value:
                                          _videoController.uploadProgress.value,
                                      backgroundColor: Colors.grey[300],
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.blue),
                                      semanticsLabel: "Please wait ...",
                                      semanticsValue: _videoController
                                          .uploadProgress.value
                                          .toString(),
                                      minHeight: dHeight * 0.02,
                                    )
                                  : ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color.fromARGB(255, 255, 255, 255),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.0,
                                            horizontal: dWidth > 900
                                                ? dWidth * 0.04
                                                : dWidth * 0.06),
                                      ),
                                      onPressed: () async {
                                        if (_videoController
                                            .videoFormKey.currentState!
                                            .validate()) {
                                          _videoController
                                              .videoFormKey.currentState!
                                              .save();
                                          _videoController
                                              .setAddingVideoProgress(true);
                                          var oResult =
                                              await _videoController.addVideo(
                                                  _videoFile, _thumbnailFile);
                                          _videoController
                                              .setAddingVideoProgress(false);

                                          if (oResult) {
                                            QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.success,
                                              text: _videoController
                                                  .oResultData.value,
                                              autoCloseDuration:
                                                  const Duration(seconds: 2),
                                              showConfirmBtn: false,
                                            );

                                            Future.delayed(
                                                const Duration(seconds: 2), () {
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
                                              titleColor: Colors.black,
                                              textColor: Colors.black,
                                            );
                                          }
                                        }
                                      },
                                      icon: const Icon(Icons.add),
                                      label: Text(
                                        "Add",
                                        style: TextStyle(
                                          fontFamily: 'Playwrite NL',
                                          fontSize: dWidth > 900
                                              ? dWidth * 0.015
                                              : dWidth * 0.03,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(255, 0, 0, 0),
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
                              icon: const Icon(
                                Icons.list,
                                color: Colors.blue,
                              ),
                              label: Text(
                                "Video List",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'Playwrite NL',
                                  fontSize: dWidth > 900
                                      ? dWidth * 0.015
                                      : dWidth * 0.03,
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
