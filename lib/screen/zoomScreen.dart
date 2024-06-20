import 'package:wellness_app/controller/configController.dart';
import 'package:wellness_app/screen/dashBoard.dart';
import 'package:wellness_app/screen/homeScreen.dart';
import 'package:wellness_app/screen/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class ZoomScreen extends StatefulWidget {
  const ZoomScreen({super.key});

  @override
  State<ZoomScreen> createState() => _ZoomScreenState();
}

class _ZoomScreenState extends State<ZoomScreen> {
  ConfigController configController = Get.put(ConfigController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ZoomDrawer(
        menuScreen: ZoomMenu(),
        mainScreen: configController.isDashBoard.value
            ? DashBoardScreen()
            : HomeScreen(),
        angle: 0.0,
        menuBackgroundColor: Color(0xFF0D1B2A),
        mainScreenScale: 0.2,
        shadowLayer1Color: Color(0xFF0D1B2A),
        shadowLayer2Color: Color(0xFF0D1B2A),
        duration: const Duration(microseconds: 600),
      );
    });
  }
}
