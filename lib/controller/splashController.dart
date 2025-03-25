import 'package:healing_renaissance/route/route.dart';
import 'package:get/get.dart';


class SplashController extends GetxController {
  RxString splashMessage = "Edu-App".obs;
  late RxDouble fontSize = 0.0.obs;
  late RxDouble sWidet = Get.width.obs;
  late RxDouble sHight = Get.height.obs;
  fadeIn() async {
    fontSize.value = sWidet * 0.05;
    Future.delayed(const Duration(seconds: 2), () {
      fadeOut();
    });
  }

  fadeOut() async {
    fontSize.value = sWidet * 0.15;
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(AppRoutes.userHomeScreen);
    });
  }
}
