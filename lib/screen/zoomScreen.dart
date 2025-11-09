import 'package:kavita_healling_reanaissance/controller/configController.dart';
import 'package:kavita_healling_reanaissance/screen/dashBoard.dart';
import 'package:kavita_healling_reanaissance/screen/homeScreen.dart';
import 'package:kavita_healling_reanaissance/screen/menu.dart';
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
        menuScreen: const ZoomMenu(),
        mainScreen: configController.isDashBoard.value
            ? const DashBoardScreen()
            : const HomeScreen(),
        angle: 0.0,
        menuBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        mainScreenScale: 0.2,
        shadowLayer1Color: const Color.fromARGB(255, 255, 255, 255),
        shadowLayer2Color: const Color.fromARGB(255, 255, 255, 255),
        duration: const Duration(microseconds: 600),
      );
    });
  }
}
