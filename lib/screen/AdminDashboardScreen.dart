import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellness_app/SharedPreferencesHelper.dart';
import 'package:wellness_app/controller/configController.dart';
import 'package:wellness_app/route/route.dart';
import 'package:wellness_app/screen/menu.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

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
           IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                 Get.offNamed(AppRoutes.zoom);
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
        color: Color(0xFF1B1B2F), // Dark background color
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
          color: const Color(0xFF162447), // Darker card background color
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              blurRadius: 6.0,
              offset: Offset(0, 3), // Shadow offset
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: dWidth > 900 ? dWidth * 0.08 : dWidth * 0.1,
              color: Colors.white, // White icon color
            ),
            SizedBox(height: 10.0),
            Text(
              label,
              style: GoogleFonts.arsenal(
                textStyle: TextStyle(
                  color: Colors.white, // White text color
                  fontFamily: 'Playwrite NL',
                  fontSize: dWidth > 900 ? dWidth * 0.02 : dWidth * 0.025,
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
