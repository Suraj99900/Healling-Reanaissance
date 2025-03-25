import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healing_renaissance/SharedPreferencesHelper.dart';
import 'package:healing_renaissance/controller/configController.dart';
import 'package:healing_renaissance/route/route.dart';
import 'package:healing_renaissance/screen/commonfunction.dart';
import 'package:healing_renaissance/screen/menu.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:healing_renaissance/screen/CustomWebView.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
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
    // Additional initialization code can go here
  }

  ConfigController configController = Get.put(ConfigController());
  bool isDrawerOpen = false;
  final double drawerWidth = 200.0; // Width of the drawer when open
  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        elevation: 0.6,
        shadowColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () {
                Get.offNamed(AppRoutes.zoom);
              },
            ),
            Image.asset(
              'assets/images/new_logo.png',
              width: dWidth > 900 ? dWidth * 0.1 : dWidth * 0.3,
              height: dHeight * 0.1,
              fit: BoxFit.cover,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ],
        ),
      ),
      body: Container(
        color:
            const Color.fromARGB(255, 255, 255, 255), // Dark background color
        padding: EdgeInsets.symmetric(horizontal: dWidth > 1200 ? 80.0 : 20.0),
        child: GridView.count(
          crossAxisCount: dWidth > 1200
              ? 6
              : dWidth > 800
                  ? 4
                  : 2,
          padding: const EdgeInsets.all(5.0),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.2, // Adjust as needed for item size
          children: [
            buildAdminMenuItem(
              "Category Management ",
              Icons.category_rounded,
              onTap: () {
                Get.toNamed(AppRoutes.categoryManage);
              },
            ),
            buildAdminMenuItem(
              "Video Management",
              Icons.video_camera_back_rounded,
              onTap: () {
                Get.toNamed(AppRoutes.videoManage);
              },
            ),
            buildAdminMenuItem(
              "User Access Management",
              Icons.access_time,
              onTap: () {
                kIsWeb
                    ? Get.to(() => LaunchURL(
                        "https://lifehealerkavita.com/user-access"))
                    : Get.toNamed(AppRoutes.addUserAccessScreen);
              },
            ),
            buildAdminMenuItem(
              "User Management",
              Icons.person,
              onTap: () {
                kIsWeb
                    ? Get.to(() => LaunchURL(
                        "https://lifehealerkavita.com/user-management"))
                    : Get.toNamed(AppRoutes.userManagement);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAdminMenuItem(String label, IconData icon,
      {VoidCallback? onTap}) {
    var dWidth = Get.width;
    var dHeight = Get.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(
              255, 246, 246, 246), // Darker card background color
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              blurRadius: 6.0,
              offset: const Offset(0, 3), // Shadow offset
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: dWidth > 900 ? dWidth * 0.05 : dWidth * 0.1,
              color: const Color.fromARGB(255, 0, 0, 0), // White icon color
            ),
            const SizedBox(height: 10.0),
            Text(
              label,
              style: GoogleFonts.cairo(
                textStyle: GoogleFonts.cairo(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: dWidth > 900 ? dWidth * 0.007 : dWidth * 0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
