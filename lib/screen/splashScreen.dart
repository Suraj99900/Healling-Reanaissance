import 'package:wellness_app/controller/splashController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController splashController = SplashController();
  var sWidth = Get.width;
  var sHeight = Get.height;
  @override
  void initState() {
    super.initState();
    splashController.fadeIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            return TweenAnimationBuilder(
              curve: Curves.easeInOut,
              tween: Tween<double>(
                begin: splashController.fontSize.value == sWidth * 0.05
                    ? sWidth * 0.05
                    : sWidth * 0.15,
                end: splashController.fontSize.value,
              ),
              duration: const Duration(seconds: 1),
              builder: (BuildContext context, double fontSize, Widget? child) {
                return Image.asset(
                  'assets/images/new_logo.png',
                  width: sWidth >= 850 ? sWidth * 0.1 : sWidth * 1,
                  height: sHeight * 0.7,
                  fit: BoxFit.cover,
                  color: Colors.white,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
