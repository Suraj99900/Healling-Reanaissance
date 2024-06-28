// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

import '../controller/LoginController.dart';
import '../route/route.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/login.png",
              width: dWidth * 1,
              height: dHeight * 1,
              fit: BoxFit.fill,
            ),
            Positioned.fill(
              top: dHeight * 0.1,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/new_logo.png',
                    width: dWidth >= 850? dWidth * 0.4: dWidth * 2,
                    height: dHeight * 0.20,
                    fit: BoxFit.cover,
                    color: Colors.white
                  )
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: dHeight * 0.35,
                ),
                Center(
                  child: Container(
                    width: dWidth >= 850 ? dWidth * 0.6 : dWidth * 0.9,
                    height: dHeight * 0.6,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(70, 0, 0, 0),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: Offset(10, 10),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                        key: _loginController.loginFormKey,
                        child: Column(
                          children: [
                            Text(
                              "User Login",
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: dWidth >= 850? dWidth * 0.02: dWidth * 0.05,
                                  color: Color.fromARGB(173, 34, 13, 2),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextFormField(
                              decoration:  InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                hintStyle: GoogleFonts.cairo(
                                  color: Color.fromARGB(173, 34, 13, 2),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an email';
                                }
                                // You can add more email validation logic here
                                return null;
                              },
                              onSaved: (value) {
                                _loginController.email.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration:  InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                hintStyle: GoogleFonts.cairo(
                                  color: Color.fromARGB(173, 34, 13, 2),
                                ),
                              ),
                              obscureText: true, // Hide the password
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a password';
                                }
                                // You can add more password validation logic here
                                return null;
                              },
                              onSaved: (value) {
                                _loginController.password.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Obx(() {
                              return _loginController.isLogin == true
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton.icon(
                                      onPressed: () async {
                                        _loginController
                                            .setLoginProgressBar(true);
                                        var oResult =
                                            await _loginController.userLogin();
                                        _loginController
                                            .setLoginProgressBar(false);

                                        if (oResult) {
                                          QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.success,
                                              text: _loginController
                                                  .oResultData.value,
                                              autoCloseDuration:
                                                  Duration(seconds: 2),
                                              showConfirmBtn: false);
                                              Future.delayed(Duration(seconds: 2),(){
                                                Get.offAllNamed(AppRoutes.zoom);
                                              });
                                        } else {
                                          QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.error,
                                              text: _loginController
                                                  .oResultData.value,
                                              title: 'Oops...',
                                              backgroundColor: Colors.black,
                                              titleColor: Colors.white,
                                              textColor: Colors.white);
                                        }
                                      },
                                      icon: const Icon(Icons.login),
                                      label: Text(
                                        "Log in",
                                        style: GoogleFonts.cairo(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    );
                            }),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Get.offNamed(AppRoutes.adminLogin);
                                  },
                                  icon: const Icon(Icons.person_4_sharp),
                                  label: Text(
                                    "Register User",
                                    style: GoogleFonts.cairo(
                                        color: Colors.blue,
                                        fontSize: dWidth >= 550 ? 16 : 8),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Get.offNamed(AppRoutes.forgetpassword);
                                  },
                                  icon: const Icon(Icons.password_rounded),
                                  label: Text(
                                    "Forget password",
                                    style: GoogleFonts.cairo(
                                        color: Colors.blue,
                                        fontSize: dWidth >= 550 ? 16 : 8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
