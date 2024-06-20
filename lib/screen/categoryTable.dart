import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellness_app/controller/CategoryController.dart';
import 'package:wellness_app/controller/CategoryTableController.dart';
import 'package:wellness_app/route/route.dart';
import 'package:wellness_app/screen/commonfunction.dart';
import 'package:wellness_app/screen/updateCategoryScreen.dart';

import '../modal/CategoryModal.dart';

class CategoryTable extends StatelessWidget {
  CategoryTable({super.key});
  final CategoryTableController controller = Get.put(CategoryTableController());

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;
    return FutureBuilder(
      future: controller.fetchCategoryData(),
      builder:
          (BuildContext context, AsyncSnapshot<List<VideoCategory>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            backgroundColor: Color(0xFF0D1B2A),
            appBar: AppBar(
              backgroundColor: Color(0xFF0D1B2A),
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              elevation: 0.6,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  Image.asset(
                    'assets/images/new_logo.png',
                    width: dWidth > 900 ? dWidth * 0.1 : dWidth * 0.3,
                    height: dHeight * 0.1,
                    fit: BoxFit.cover,
                    color: Colors.white,
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
                            const Icon(Icons.category_rounded),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Category Management",
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
                                Get.toNamed(AppRoutes.addCategory);
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
                  source: UserDataTableSource(controller.videoCategory),
                  columns: [
                    DataColumn(
                      label: Center(
                        child: Text(
                          'id',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arsenal(
                            textStyle: TextStyle(
                              fontSize: controller.sWidth > 900
                                  ? controller.sWidth * 0.015
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
                              fontSize: controller.sWidth > 900
                                  ? controller.sWidth * 0.015
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
                          'Description',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arsenal(
                            textStyle: TextStyle(
                              fontSize: controller.sWidth > 900
                                  ? controller.sWidth * 0.015
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
                              fontSize: controller.sWidth > 900
                                  ? controller.sWidth * 0.015
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

class UserDataTableSource extends DataTableSource {
  final List<VideoCategory> videoCategoryList;

  UserDataTableSource(this.videoCategoryList);

  @override
  DataRow getRow(int index) {
    VideoCategory videoCategory = videoCategoryList[index];
    int iNo = index + 1;
    return DataRow(cells: [
      DataCell(
        Center(
          child: Text(
            iNo.toString(),
            style: GoogleFonts.arsenal(
              textStyle: TextStyle(
                fontSize: Get.find<CategoryTableController>().sWidth > 900
                    ? Get.find<CategoryTableController>().sWidth * 0.01
                    : Get.find<CategoryTableController>().sWidth * 0.03,
              ),
            ),
          ),
        ),
      ),
      DataCell(
        Center(
          child: Text(
            videoCategory.name,
            style: GoogleFonts.arsenal(
              textStyle: TextStyle(
                fontSize: Get.find<CategoryTableController>().sWidth > 900
                    ? Get.find<CategoryTableController>().sWidth * 0.01
                    : Get.find<CategoryTableController>().sWidth * 0.03,
              ),
            ),
          ),
        ),
      ),
      DataCell(
        Center(
          child: Text(
            limitWords(videoCategory.desc, 5),
            style: GoogleFonts.arsenal(
              textStyle: TextStyle(
                fontSize: Get.find<CategoryTableController>().sWidth > 900
                    ? Get.find<CategoryTableController>().sWidth * 0.01
                    : Get.find<CategoryTableController>().sWidth * 0.03,
              ),
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
                  Get.to(() => UpdateCategoryScreen(iRowId: videoCategory.id));
                },
                icon: Icon(
                  Icons.edit,
                  size: Get.find<CategoryTableController>().sWidth > 900
                      ? Get.find<CategoryTableController>().sWidth * 0.01
                      : Get.find<CategoryTableController>().sWidth * 0.04,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () async {
                  var oResult = await CategoryController()
                      .deleteCategory(videoCategory.id);
                  if (oResult) {
                     Get.toNamed(AppRoutes.dashBoard);
                  }
                },
                icon: Icon(
                  Icons.delete,
                  size: Get.find<CategoryTableController>().sWidth > 900
                      ? Get.find<CategoryTableController>().sWidth * 0.01
                      : Get.find<CategoryTableController>().sWidth * 0.04,
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
  int get rowCount => videoCategoryList.length;

  @override
  int get selectedRowCount => 0;
}
