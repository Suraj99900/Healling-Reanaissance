import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:kavita_healling_reanaissance/AppColors%20.dart';
import 'package:kavita_healling_reanaissance/SharedPreferencesHelper.dart';
import 'package:kavita_healling_reanaissance/controller/homeScreenController.dart';
import 'package:kavita_healling_reanaissance/route/route.dart';
import 'package:kavita_healling_reanaissance/screen/VideoListScreen.dart';
import 'package:kavita_healling_reanaissance/screen/commonfunction.dart';
import 'package:kavita_healling_reanaissance/screen/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenController homeController = Get.put(HomeScreenController());
  bool isDrawerOpen = false;
  final double drawerWidth = 200.0;
  List<List<Color>> gradients = AppColors().gradients;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    homeController.fetchCategoryByUserId();
  }

  Future<void> _checkLoginStatus() async {
    String? userId = await SharedPreferencesHelper.getUserId("sUserId");
    if (userId == null || userId == '0') {
      await SharedPreferencesHelper.clearSharedPreferences();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dWidth = Get.width;
    final dHeight = Get.height;
    final isWide = dWidth > 900;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 239, 240, 241),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipRRect(
          // Glassmorphism AppBar
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 2,
              backgroundColor: Colors.white.withOpacity(0.4),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Row(
                      children: [
                        Container(
                          width: isWide ? 56 : 48,
                          height: isWide ? 56 : 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade200,
                                Colors.purple.shade200
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: isWide ? 32 : 28,
                            ),
                          ),
                        ),
                        SizedBox(width: isWide ? 16 : 10),
                        Text(
                          "Kvita's Healling Reanaissance",
                          style: TextStyle(
                            fontSize: isWide ? 22 : 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    // Profile Icon
                    GestureDetector(
                      onTap: () {
                        ZoomMenuController().loadStoredPreference();
                        ZoomDrawer.of(context)?.toggle();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: isWide ? 28 : 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isWide ? 24 : 16,
                  horizontal: isWide ? 32 : 20,
                ),
                child: Text(
                  "Category Videos",
                  style: TextStyle(
                    fontSize: isWide ? 32 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Categories Grid
              Expanded(
                child: Obx(() {
                  if (homeController.userCategory.value.isEmpty) {
                    return const Center(
                      child: Text(
                        'No categories found',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    );
                  }
                  final int crossCount = isWide
                      ? 4
                      : (dWidth > 600
                          ? 3
                          : 2);
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 32 : 16, vertical: 8),
                    child: GridView.builder(
                      itemCount: homeController.userCategory.value.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return buildVideoCategory(
                          homeController.userCategory.value[index], dWidth, isWide);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVideoCategory(
    Map<String, dynamic> aCategory,
    double dWidth,
    bool isWide,
  ) {
    final String sName = aCategory['name'] as String;
    final String sDescription = aCategory['description'] ?? '';
    final List<Color> selectedGradient =
        gradients[Random().nextInt(gradients.length)];

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: () {
          Get.to(() => VideoListScreen(categoryId: aCategory['id']));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: selectedGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      child: Icon(
                        Icons.slow_motion_video_rounded,
                        key: ValueKey<int>(Random().nextInt(1000)),
                        size: isWide ? dWidth * 0.05 : dWidth * 0.12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FittedBox(
                      child: Text(
                        sName,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: isWide ? dWidth * 0.012 : dWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.4),
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      limitWords(sDescription, 12),
                      style: TextStyle(
                        color: const Color.fromARGB(179, 0, 0, 0),
                        fontSize: isWide ? dWidth * 0.009 : dWidth * 0.025,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isHovering = false;
}
