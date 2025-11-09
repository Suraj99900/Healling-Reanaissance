import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kavita_healling_reanaissance/screen/AdminDashboardScreen.dart';
import 'package:kavita_healling_reanaissance/screen/categoryTable.dart';
import 'package:kavita_healling_reanaissance/screen/VideoTableScreen.dart';
import 'package:kavita_healling_reanaissance/screen/commonfunction.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  var sWidth = Get.width;
  var sHeight = Get.height;
  final RxInt _selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    fetchCategoryData();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        elevation: 0.6,
        shadowColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
            'assets/images/icon.png',
              width: sWidth > 900 ? sWidth * 0.1 : sWidth * 0.3,
              height: sHeight * 0.1,
              fit: BoxFit.cover,
              color: const Color.fromARGB(255, 255, 250, 250),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: GestureDetector(
                onTap: () {
                  ZoomDrawer.of(context)?.toggle();
                },
                child: Icon(
                  Icons.person_4_rounded,
                  color: Colors.white,
                  size: sWidth > 900 ? sWidth * 0.02 : sWidth * 0.08,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Add a light shadow
                spreadRadius: 2,
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              NavigationRail(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                selectedIconTheme: const IconThemeData(color: Colors.white),
                unselectedIconTheme: const IconThemeData(color: Colors.grey),
                selectedLabelTextStyle: GoogleFonts.arsenal(
                  textStyle: TextStyle(
                      fontSize: sWidth > 900 ? sWidth * 0.01 : sWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                unselectedLabelTextStyle: GoogleFonts.arsenal(
                  textStyle: TextStyle(
                      fontSize: sWidth > 900 ? sWidth * 0.01 : sWidth * 0.04,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                ),
                onDestinationSelected: (int index) {
                  _selectedIndex.value = index;
                },
                selectedIndex: _selectedIndex.value,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.admin_panel_settings_rounded,
                        size: sWidth > 900 ? sWidth * 0.01 : sWidth * 0.04),
                    label: Text(
                      'Admin Dashobard',
                      style: TextStyle(
                          fontSize:
                              sWidth > 900 ? sWidth * 0.008 : sWidth * 0.02),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.category_rounded,
                        size: sWidth > 900 ? sWidth * 0.01 : sWidth * 0.04),
                    label: Text(
                      'Category Management',
                      style: TextStyle(
                          fontSize:
                              sWidth > 900 ? sWidth * 0.008 : sWidth * 0.02),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.video_chat_rounded,
                        size: sWidth > 900 ? sWidth * 0.01 : sWidth * 0.04),
                    label: Text(
                      'Video Management',
                      style: TextStyle(
                          fontSize:
                              sWidth > 900 ? sWidth * 0.008 : sWidth * 0.02),
                    ),
                  ),
                ],
                labelType: NavigationRailLabelType.all,
              ),
              Expanded(child: _screens[_selectedIndex.value])
            ],
          ),
        );
      }),
    );
  }

  final List<Widget> _screens = [
    Container(
      alignment: Alignment.center,
      child: const AdminDashboardScreen(),
    ),
    Container(
      alignment: Alignment.center,
      child: CategoryTable(),
    ),
    Container(
      alignment: Alignment.center,
      child: VideoTable(),
    ),
  ];
}
