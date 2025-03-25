import 'dart:convert';
import 'dart:math';

import 'package:healing_renaissance/AppColors%20.dart';
import 'package:healing_renaissance/SharedPreferencesHelper.dart';
import 'package:healing_renaissance/controller/homeScreenController.dart';
import 'package:healing_renaissance/route/route.dart';
import 'package:healing_renaissance/screen/VideoListScreen.dart';
import 'package:healing_renaissance/screen/commonfunction.dart';
import 'package:healing_renaissance/screen/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenController homeController = Get.put(HomeScreenController());
  bool isDrawerOpen = false;
  final double drawerWidth = 200.0; // Width of the drawer when open
  List<List<Color>> gradients = AppColors().gradients;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    // Fetch categories when the screen loads
    homeController.fetchCategoryByUserId();
  }

  void _checkLoginStatus() async {
    String? id = await SharedPreferencesHelper.getUserId("sUserId");
    if (id == null || id == '0') {
      // Assuming '0' is a string since SharedPreferences stores IDs as strings
      await SharedPreferencesHelper.clearSharedPreferences();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 240, 241),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.6,
        shadowColor: Colors.black,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF89CFF0), Color(0xFFB19CD9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo Section
            Image.asset(
              'assets/images/new_logo.png',
              width: dWidth > 900 ? dWidth * 0.1 : dWidth * 0.3,
              height: dHeight * 0.1,
              fit: BoxFit.cover,
              color: Colors.black,
            ),
            // Profile Icon Button
            GestureDetector(
              onTap: () {
                ZoomMenuController().loadStoredPreference();
                ZoomDrawer.of(context)?.toggle();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
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
            colors: [Color(0xFFB3E5FC), Color(0xFFE1BEE7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Label for Category Videos
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: Text(
                "Category Videos",
                style: TextStyle(
                  fontSize: dWidth > 900 ? 28 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Playwrite NL',
                ),
              ),
            ),
            // Categories Grid
            Expanded(
              child: Obx(() {
                if (homeController.userCategory.value.isEmpty) {
                  return const Center(child: Text('No categories found'));
                }
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
                    childAspectRatio: 1,
                  ),
                  itemCount: homeController.userCategory.value.length,
                  itemBuilder: (context, index) {
                    return buildVideoCategory(
                      homeController.userCategory.value[index],
                      dWidth,
                    );
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

    // Select a random gradient from your list
    List<Color> selectedGradient = gradients[Random().nextInt(gradients.length)];

    return GestureDetector(
      onTap: () {
        // Navigate to VideoListScreen for the tapped category
        Get.to(() => VideoListScreen(categoryId: aCategory['id']));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: selectedGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0.7,
              blurRadius: 5,
              offset: const Offset(1, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: Icon(
                Icons.slow_motion_video_rounded,
                key: ValueKey<int>(Random().nextInt(1000)),
                size: dWidth > 900 ? dWidth * 0.04 : dWidth * 0.085,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              sName,
              style: TextStyle(
                color: Colors.black,
                fontSize: dWidth > 900 ? dWidth * 0.015 : dWidth * 0.03,
                fontWeight: FontWeight.bold,
                fontFamily: 'Playwrite NL',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              limitWords(sDescription, 15),
              style: TextStyle(
                color: Colors.black87,
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
