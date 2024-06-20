import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellness_app/screen/AdminDashboardScreen.dart';
import 'package:wellness_app/screen/CategoryTable.dart';
import 'package:wellness_app/screen/VideoTableScreen.dart';
import 'package:wellness_app/screen/commonfunction.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  var sWidth = Get.width;
  var sHeight = Get.height;
  RxInt _selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    fetchCategoryData();
    return Scaffold(
      backgroundColor: Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0D1B2A),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        elevation: 0.6,
        shadowColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/new_logo.png',
              width: sWidth > 900 ? sWidth * 0.1 : sWidth * 0.3,
              height: sHeight * 0.1,
              fit: BoxFit.cover,
              color: Color.fromARGB(255, 255, 250, 250),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
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
            color: Color(0xFF0D1B2A),
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
                backgroundColor: Color(0xFF1B263B),
                selectedIconTheme: IconThemeData(color: Colors.white),
                unselectedIconTheme: IconThemeData(color: Colors.grey),
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
      child: AdminDashboardScreen(),
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
