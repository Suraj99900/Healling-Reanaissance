import 'package:wellness_app/controller/forgetController.dart';
import 'package:wellness_app/screen/AddVideoScreen.dart';
import 'package:wellness_app/screen/AdminDashboardScreen.dart';
import 'package:wellness_app/screen/UserScreen.dart';
import 'package:wellness_app/screen/VideoTableScreen.dart';
import 'package:wellness_app/screen/addCategoryScreen.dart';
import 'package:wellness_app/screen/adminScreen.dart';
import 'package:wellness_app/screen/LoginScreen.dart';
import 'package:wellness_app/screen/categoryTable.dart';
import 'package:wellness_app/screen/forgetScreen.dart';
import 'package:wellness_app/screen/homeScreen.dart';
import 'package:wellness_app/screen/splashScreen.dart';
import 'package:wellness_app/screen/updateCategoryScreen.dart';
import 'package:wellness_app/screen/updateVideoScreen.dart';
import 'package:wellness_app/screen/zoomScreen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const initial = '/';
  static const home = '/home';
  static const zoom = '/zoom';
  static const login = '/login';
  static const forgetpassword = '/forgetpassword';
  static const adminLogin = '/adminLogin';
  static const dashBoard = '/dashBoard';
  static const uploadBlog = '/uploadBlog';
  static const addCategory = '/addCategory';
  static const updateCategory = '/updateCategory/:id';
  static const videoManage = '/videoManage';
  static const updateVideo = '/update-video';
  static const addVideo = '/add-video';
  static const categoryManage = '/categoryManage';
  static const userHomeScreen = '/userHomeScreen';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const SplashScreen()),
    GetPage(name: zoom, page: () => const ZoomScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: adminLogin, page: () => const AdminScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: forgetpassword, page: () => const ForgetPasswordScreen()),
    GetPage(name: addCategory, page: () => const AddCategoryScreen()),
    GetPage(
      name: updateCategory,
      page: () {
        final idParam = Get.parameters['id'];
        final id = idParam != null ? int.tryParse(idParam) : null;
        return UpdateCategoryScreen(iRowId: id);
      },
    ),
    GetPage(name: videoManage, page: () => VideoTable()),
    GetPage(name: addVideo, page: () => const AddVideoScreen()),
    GetPage(name: updateVideo, page: () => UpdateVideoScreen(videoId: Get.arguments)),
    GetPage(name: categoryManage, page: () => CategoryTable()),
    GetPage(name: dashBoard, page: () => const AdminDashboardScreen()),
    GetPage(name: userHomeScreen, page: () => const UserScreen()),
  ];
}
