import 'package:wellness_app/controller/adminController.dart';
import 'package:wellness_app/route/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final AdminController _adminController = Get.put(AdminController());

  Map<String, String> aUserType = {
    "1": "Supper-Admin",
    "2": "App-user",
    "3": "Developer",
    "4": "Admin"
  };

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/register.png",
              width: dWidth,
              height: dHeight,
              fit: BoxFit.fill,
            ),
            Positioned.fill(
              top: dHeight * 0.04,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/new_logo.png',
                    width: dWidth >= 850? dWidth * 1: dWidth * 2,
                    height: dHeight * 0.20,
                    color: Colors.white,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: dHeight * 0.25,
                ),
                Center(
                  child: Container(
                    width: dWidth >= 850 ? dWidth * 0.6 : dWidth * 0.9,
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
                        key: _adminController.adminLoginFormKey,
                        child: Column(
                          children: [
                            Text(
                              "Registration User",
                              style: GoogleFonts.arsenal(
                                textStyle: TextStyle(
                                  fontSize: dWidth * 0.05,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      hintText: 'Enter your email',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter an email';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _adminController.sEmail.value = value!;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Obx(() {
                                  return _adminController.isGenrateOTP == true
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                          onPressed: () async {
                                            bool oResult =
                                                await _adminController.generateOTP();
                                            if (oResult == true) {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.success,
                                                text:
                                                    _adminController.oResultData.value,
                                                autoCloseDuration:
                                                    const Duration(seconds: 2),
                                                showConfirmBtn: false,
                                              );
                                            } else {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.error,
                                                title: 'Oops...',
                                                text: _adminController
                                                    .oResultData.value,
                                                backgroundColor: Colors.black,
                                                titleColor: Colors.white,
                                                textColor: Colors.white,
                                              );
                                            }
                                          },
                                          child: const Text('Generate OTP'),
                                        );
                                }),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'User Name',
                                hintText: 'Enter User Name',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the user name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _adminController.sUserName.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'OTP',
                                hintText: 'Enter OTP',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the OTP';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _adminController.sOTP.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Key',
                                hintText: 'Enter your Key',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a key';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _adminController.sKey.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Obx(() {
                              return DropdownButtonFormField<String>(
                                value: _adminController
                                        .sSelectedUserType.value.isEmpty
                                    ? null
                                    : _adminController.sSelectedUserType.value,
                                items: aUserType.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  _adminController.sSelectedUserType.value =
                                      newValue!;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'User Type',
                                  border: UnderlineInputBorder(),
                                ),
                              );
                            }),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _adminController.sPassword.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Obx(() {
                              return _adminController.isLogin.value
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton.icon(
                                      onPressed: () async {
                                        _adminController
                                            .setLoginProgressBar(true);
                                        var oResult = await _adminController.adminLogin();
                                        _adminController
                                            .setLoginProgressBar(false);

                                             if (oResult == true) {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.success,
                                                text:
                                                    _adminController.oResultData.value,
                                                autoCloseDuration:
                                                    const Duration(seconds: 2),
                                                showConfirmBtn: false,
                                              );

                                              Get.offNamed(AppRoutes.login);
                                            } else {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.error,
                                                title: 'Oops...',
                                                text: _adminController
                                                    .oResultData.value,
                                                backgroundColor: Colors.black,
                                                titleColor: Colors.white,
                                                textColor: Colors.white,
                                              );
                                            }
                                      },
                                      icon: const Icon(Icons.person),
                                      label: const Text(
                                        "submit",
                                        style: TextStyle(
                                          fontFamily: 'Manrope',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                            }),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Get.offNamed(AppRoutes.login);
                                  },
                                  icon: const Icon(Icons.person),
                                  label: Text(
                                    "User Login",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: "Manrope",
                                      fontSize: dWidth >= 550 ? 16 : 8,
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Get.toNamed(AppRoutes.forgetpassword);
                                  },
                                  icon: const Icon(Icons.password_rounded),
                                  label: Text(
                                    "Forget password",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: "Manrope",
                                      fontSize: dWidth >= 550 ? 16 : 8,
                                    ),
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
