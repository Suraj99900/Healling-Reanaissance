import 'package:healing_renaissance/screen/AddVideoScreen.dart';
import 'package:healing_renaissance/screen/AdminDashboardScreen.dart';
import 'package:healing_renaissance/screen/UserManagementScreen.dart';
import 'package:healing_renaissance/screen/UserScreen.dart';
import 'package:healing_renaissance/screen/VideoListScreen.dart';
import 'package:healing_renaissance/screen/VideoTableScreen.dart';
import 'package:healing_renaissance/screen/addCategoryScreen.dart';
import 'package:healing_renaissance/screen/adminScreen.dart';
import 'package:healing_renaissance/screen/loginScreen.dart';
import 'package:healing_renaissance/screen/categoryTable.dart';
import 'package:healing_renaissance/screen/forgetScreen.dart';
import 'package:healing_renaissance/screen/homeScreen.dart';
import 'package:healing_renaissance/screen/splashScreen.dart';
import 'package:healing_renaissance/screen/updateCategoryScreen.dart';
import 'package:healing_renaissance/screen/updateVideoScreen.dart';
import 'package:healing_renaissance/screen/userAccessAddScreen.dart';
import 'package:healing_renaissance/screen/zoomScreen.dart';
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
  static const addUserAccessScreen = '/addUserAccessScreen';
  static const userManagement = '/userManagement';

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
    GetPage(name: addUserAccessScreen, page: ()=> AddUserAccessScreen()),
     GetPage(name: userManagement, page: ()=> UserManagementScreen()),
  ];
}
