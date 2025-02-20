import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellness_app/controller/configController.dart';
import 'package:wellness_app/screen/CustomWebView.dart';
import '../SharedPreferencesHelper.dart';
import '../route/route.dart';

class ZoomMenuController extends GetxController {
  final RxDouble sWidth = Get.width.obs;
  final RxString sUserName = "".obs;
  final RxInt sId = 0.obs;
  final RxInt sUserType = 0.obs;
  final RxString sProfileUrl = "".obs;
  RxBool isLoading = false.obs; // For showing loading indicator
  @override
  void onInit() {
    super.onInit();
    loadStoredPreference();
  }

  Future<void> loadStoredPreference() async {
    ImageCache().clear();

    String? id = await SharedPreferencesHelper.getUserId("sUserId");
    // Fetch additional user data from Firestore

    var userName = await SharedPreferencesHelper.getUserName("sUserName");

    var profileUrl = await SharedPreferencesHelper.getProfileURL("uProfileUrl");
    String? userType = await SharedPreferencesHelper.getUserType("sUserType");

    sUserName.value = userName ?? " ";
    sId.value = id != null && id.isNotEmpty ? int.tryParse(id) ?? 0 : 0;
    sUserType.value = userType != null && userType.isNotEmpty
        ? int.tryParse(userType) ?? 0
        : 0;
    sProfileUrl.value =
        profileUrl ?? "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";
  }

  Future<void> uploadProfileImage() async {}
}

class ZoomMenu extends StatefulWidget {
  const ZoomMenu({super.key});

  @override
  _ZoomMenuState createState() => _ZoomMenuState();
}

class _ZoomMenuState extends State<ZoomMenu> {
  final ZoomMenuController controller = Get.put(ZoomMenuController());
  final ConfigController configController = Get.put(ConfigController());

  @override
  void initState() {
    super.initState();
    controller.loadStoredPreference(); // Call the method in initState
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80.0),
              Center(
                child: Column(
                  children: [
                    controller.isLoading != true
                        ? GestureDetector(
                            onTap: () async {
                              await controller.uploadProfileImage();
                            },
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                controller.sProfileUrl.isNotEmpty
                                    ? controller.sProfileUrl.value
                                    : "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                              ),
                            ),
                          )
                        : const CircularProgressIndicator(),
                    const SizedBox(height: 20.0),
                    Obx(() => Text(
                          controller.sUserName.value,
                          style: GoogleFonts.arsenal(
                            textStyle: TextStyle(
                              fontSize: controller.sWidth.value > 900
                                  ? controller.sWidth.value * 0.01
                                  : controller.sWidth.value * 0.05,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              buildMenuItem("Home", Icons.home, AppRoutes.userHomeScreen),
              buildMenuItem("Category", Icons.home, AppRoutes.zoom),
              buildMenuItem("About", Icons.person, "https://lifehealerkavita.com/"),
              Obx(() => controller.sUserType.value == 1
                  ? buildMenuItem("Dashboard",
                      Icons.dashboard_customize_rounded, AppRoutes.dashBoard)
                  : const SizedBox(
                      height: 0.0,
                    )),

              // buildDashboardMenuItem(),
              const SizedBox(height: 50.0),
              buildLoginRegisterButtons(),
            ],
          );
        }),
      ),
    );
  }

  Widget buildMenuItem(String label, IconData icon, routeName) {
    return TextButton.icon(
      onPressed: () {
        // Handle navigation and logic based on the label
        if (label == "About") {
          Get.to(CustomWebViewScreen(url: routeName, title: label));
        }else{
          Get.toNamed(routeName);
        }
        
      },
      icon: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
      label: Text(
        label,
        style: GoogleFonts.arsenal(
          textStyle: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: controller.sWidth.value > 900
                ? controller.sWidth.value * 0.008
                : controller.sWidth.value * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildDashboardMenuItem() {
    return Obx(() {
      return (controller.sId.value != 0 && controller.sUserType.value == 1)
          ? TextButton.icon(
              onPressed: () {
                configController.setDashBoard(true);
                Get.toNamed(AppRoutes.zoom);
              },
              icon: const Icon(Icons.dashboard_customize_rounded,
                  color: Color.fromARGB(255, 0, 0, 0)),
              label: Text(
                "Dashboard",
                style: GoogleFonts.arsenal(
                  textStyle: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: controller.sWidth.value > 900
                        ? controller.sWidth.value * 0.008
                        : controller.sWidth.value * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : const SizedBox();
    });
  }

  Widget buildLoginRegisterButtons() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildButton("Log Out", AppRoutes.initial, Colors.red),
        ],
      );
    });
  }

  Widget buildButton(String label, String route, [Color? color]) {
    return TextButton(
      style: ButtonStyle(
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          return BorderSide(
            style: BorderStyle.solid,
            color: color ?? const Color.fromARGB(255, 0, 0, 0),
          );
        }),
      ),
      onPressed: () async {
        if (route == AppRoutes.initial) {
          await SharedPreferencesHelper.clearSharedPreferences();
          Get.snackbar(
            "Success",
            "Log out Successfully",
            colorText: Colors.black,
            backgroundColor: Colors.blue,
            barBlur: 0.5,
          );
          Get.toNamed(route);
        }
        Get.toNamed(route);
      },
      child: Text(
        label,
        style: GoogleFonts.arsenal(
          textStyle: TextStyle(
            color: color ?? const Color.fromARGB(255, 0, 0, 0),
            fontSize: controller.sWidth.value > 900
                ? controller.sWidth.value * 0.008
                : controller.sWidth.value * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
