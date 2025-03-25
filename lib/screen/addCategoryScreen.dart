import 'package:healing_renaissance/controller/CategoryController.dart';
import 'package:healing_renaissance/route/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final CategoryController _categoryController = Get.put(CategoryController());

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
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(41, 255, 255, 255)
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
                              "Add Category",
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
                            const SizedBox(
                              height: 20.0,
                            ),
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
                                  borderSide: const BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the category name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _categoryController.categoryName.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
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
                                  borderSide: const BorderSide(color: Colors.white70),
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
                                _categoryController.description.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Obx(() {
                              return _categoryController.isAddingCategory.value
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton.icon(
                                      onPressed: () async {
                                        _categoryController
                                            .setAddingCategoryProgress(true);
                                        var oResult = await _categoryController
                                            .addCategory();
                                        _categoryController
                                            .setAddingCategoryProgress(false);

                                        if (oResult == true) {
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.success,
                                            text: _categoryController
                                                .oResultData.value,
                                            autoCloseDuration:
                                                const Duration(seconds: 2),
                                            showConfirmBtn: false,
                                          );

                                          Future.delayed(
                                              const Duration(seconds: 2), () {
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
                                        Icons.add,
                                        size: dWidth > 900
                                            ? dWidth * 0.015
                                            : dWidth * 0.03,
                                      ),
                                      label: Text(
                                        "Add",
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
                            const SizedBox(
                              height: 30.0,
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Get.offNamed(AppRoutes.categoryManage);
                              },
                              icon: const Icon(Icons.list, color: Colors.blue),
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
      ),
    );
  }
}
