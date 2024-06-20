import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wellness_app/controller/CategoryController.dart';
import 'package:wellness_app/route/route.dart';

class UpdateCategoryScreen extends StatefulWidget {
  final int? iRowId;
  const UpdateCategoryScreen({Key? key, required this.iRowId})
      : super(key: key);

  @override
  State<UpdateCategoryScreen> createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  final CategoryController _categoryController = Get.put(CategoryController());
  Future<Map<String, dynamic>>? _futureCategoryData;

  @override
  void initState() {
    super.initState();
    if (widget.iRowId != null) {
      _futureCategoryData =
          _categoryController.fetchCategoryById(widget.iRowId);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B263B),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
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
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureCategoryData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            var aData = snapshot.data!;
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: dHeight * 0.1),
                      Center(
                        child: Container(
                          width: dWidth >= 850 ? dWidth * 0.6 : dWidth * 0.9,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(41, 255, 255, 255)
                                    .withOpacity(0.1), // Dark shadow
                                spreadRadius: 0.5,
                                blurRadius: 1,
                                offset: const Offset(1, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF1B263B),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Form(
                              key: _categoryController.categoryFormKey,
                              child: Column(
                                children: [
                                  Text(
                                    "Update Category",
                                    style: GoogleFonts.arsenal(
                                      textStyle: TextStyle(
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.04,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Category Name',
                                      hintText: 'Enter Category Name',
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Playwrite NL',
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                        fontFamily: 'Playwrite NL',
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter the category name';
                                      }
                                      return null;
                                    },
                                    initialValue: aData['name'],
                                    onSaved: (value) {
                                      _categoryController.categoryName.value =
                                          value!;
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      hintText: 'Enter Description',
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Playwrite NL',
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                        fontFamily: 'Playwrite NL',
                                        fontSize: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    initialValue: aData['description'],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter the description';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _categoryController.description.value =
                                          value!;
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  Obx(() {
                                    return _categoryController
                                            .isAddingCategory.value
                                        ? const CircularProgressIndicator()
                                        : ElevatedButton.icon(
                                            onPressed: () async {
                                              _categoryController
                                                  .setAddingCategoryProgress(
                                                      true);
                                              var oResult =
                                                  await _categoryController
                                                      .updateCategory(
                                                          widget.iRowId);
                                              _categoryController
                                                  .setAddingCategoryProgress(
                                                      false);

                                              if (oResult == true) {
                                                QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.success,
                                                  text: _categoryController
                                                      .oResultData.value,
                                                  autoCloseDuration:
                                                      const Duration(
                                                          seconds: 2),
                                                  showConfirmBtn: false,
                                                );

                                                Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                  Get.offNamed(
                                                      AppRoutes.categoryManage);
                                                });
                                              } else {
                                                QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.error,
                                                  title: 'Oops...',
                                                  text: _categoryController
                                                      .oResultData.value,
                                                  backgroundColor: Colors.black,
                                                  titleColor: Colors.white,
                                                  textColor: Colors.white,
                                                );
                                              }
                                            },
                                            icon: Icon(
                                              Icons.arrow_upward,
                                              size: dWidth > 900
                                                  ? dWidth * 0.015
                                                  : dWidth * 0.03,
                                            ),
                                            label: Text(
                                              "Update",
                                              style: TextStyle(
                                                fontFamily: 'Playwrite NL',
                                                fontSize: dWidth > 900
                                                    ? dWidth * 0.015
                                                    : dWidth * 0.035,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                  }),
                                  const SizedBox(height: 30.0),
                                  TextButton.icon(
                                    onPressed: () {
                                      Get.offNamed(AppRoutes.categoryManage);
                                    },
                                    icon: const Icon(Icons.list,
                                        color: Colors.blue),
                                    label: Text(
                                      "Category List",
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
            );
          }
        },
      ),
    );
  }
}
