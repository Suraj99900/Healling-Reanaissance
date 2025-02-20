import 'package:wellness_app/route/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Healling Reanaissance',
      initialRoute:
          AppRoutes.initial,
      getPages: AppRoutes
          .routes,
    );
  }
}
