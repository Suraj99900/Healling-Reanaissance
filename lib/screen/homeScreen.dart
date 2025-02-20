import 'dart:convert';
import 'dart:math';

import 'package:wellness_app/AppColors%20.dart';
import 'package:wellness_app/SharedPreferencesHelper.dart';
import 'package:wellness_app/controller/homeScreenController.dart';
import 'package:wellness_app/route/route.dart';
import 'package:wellness_app/screen/VideoListScreen.dart';
import 'package:wellness_app/screen/commonfunction.dart';
import 'package:wellness_app/screen/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    String? id = await SharedPreferencesHelper.getUserId("sUserId");
    if (id == null || id == '0') {
      // Assuming '0' is a string since SharedPreferences stores IDs as strings
      await SharedPreferencesHelper.clearSharedPreferences();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  HomeScreenController homeController = Get.put(HomeScreenController());
  bool isDrawerOpen = false;
  final double drawerWidth = 200.0; // Width of the drawer when open
  List<List<Color>> gradients = AppColors().gradients;
  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;
    homeController.fetchCategory();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 240, 241),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FBFF), Color.fromARGB(255, 234, 201, 244)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        elevation: 0.6,
        shadowColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/new_logo.png',
                  width: dWidth > 900 ? dWidth * 0.1 : dWidth * 0.3,
                  height: dHeight * 0.1,
                  fit: BoxFit.cover,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: GestureDetector(
                onTap: () {
                  ZoomMenuController().loadStoredPreference();
                  ZoomDrawer.of(context)?.toggle();
                },
                child: Icon(
                  Icons.person_4_rounded,
                  color: Colors.white,
                  size: dWidth > 900 ? dWidth * 0.02 : dWidth * 0.08,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FBFF), Color.fromARGB(255, 234, 201, 244)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Videos Label
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: Text(
                "Category Videos",
                style: TextStyle(
                  fontSize: dWidth > 900 ? 28 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.start,
              ),
            ),

            // Video Categories Grid
            Expanded(
              child: Obx(() {
                return GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: dWidth > 1200
                        ? 4
                        : dWidth > 800
                            ? 4
                            : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1, // Adjust as needed
                  ),
                  itemCount: homeController.userCategory.value.length,
                  itemBuilder: (context, index) {
                    return buildVideoCategory(
                        homeController.userCategory.value[index], dWidth);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVideoCategory(Map<String, dynamic> aCategory, double dWidth) {
    var sName = aCategory['name'];
    var sDescription = aCategory['description'] ?? '';

    List<Color> selectedGradient = gradients[Random().nextInt(71)];

    return GestureDetector(
      onTap: () async {
        // Navigate to a different screen or perform some action
        Get.to(VideoListScreen(categoryId: aCategory['id']));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: selectedGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // Darker card background color
          borderRadius: BorderRadius.circular(12), // Add rounded corners
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(137, 0, 0, 0)
                  .withOpacity(0.2), // Dark shadow
              spreadRadius: 0.7,
              blurRadius: 2,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 1000),
              child: Icon(
                Icons.slow_motion_video_rounded,
                size: dWidth > 900 ? dWidth * 0.04 : dWidth * 0.085,
                color: const Color.fromARGB(255, 3, 0, 7), // White icon color
              ),
            ),
            const SizedBox(height: 20), // Add space between icon and text
            Text(
              sName,
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0), // White text color
                fontSize: dWidth > 900 ? dWidth * 0.015 : dWidth * 0.03,
                fontWeight: FontWeight.bold, // Make text bold
                fontFamily: 'Playwrite NL',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5), // Add space between title and subtitle
            Text(
              limitWords(sDescription, 20), // Example subtitle text
              style: TextStyle(
                color: const Color.fromARGB(
                    255, 0, 0, 0), // Light grey subtitle text color
                fontSize: dWidth > 900 ? dWidth * 0.01 : dWidth * 0.02,
                fontFamily: 'Playwrite NL',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
