import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:healing_renaissance/controller/forgetController.dart';
import 'package:healing_renaissance/route/route.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  var dWidth = Get.width;
  var dHeight = Get.height;
  final ForgetPasswordController _forgetPasswordController = ForgetPasswordController();
  @override
  Widget build(BuildContext context) {
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
                    width: dWidth >= 850? dWidth * 0.4: dWidth * 2,
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
                        key: _forgetPasswordController.forgetFormKey,
                        child: Column(
                          children: [
                            Text(
                              "Forget Password",
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: dWidth >= 850? dWidth * 0.02: dWidth * 0.05,
                                  color: const Color.fromARGB(173, 34, 13, 2),
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
                                      _forgetPasswordController.sEmail.value = value!;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Obx(() {
                                  return _forgetPasswordController.isGenrateOTP == true
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                          onPressed: () async {
                                            bool oResult =
                                                await _forgetPasswordController
                                                    .generateOTP();
                                            if (oResult == true) {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.success,
                                                text: _forgetPasswordController
                                                    .oResultData.value,
                                                autoCloseDuration:
                                                    const Duration(seconds: 2),
                                                showConfirmBtn: false,
                                              );
                                            } else {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.error,
                                                title: 'Oops...',
                                                text: _forgetPasswordController
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
                                _forgetPasswordController.sOTP.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'password',
                                hintText: 'Enter your new password',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter new password';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _forgetPasswordController.sNewPassword.value = value!;
                              },
                            ),
                            const SizedBox(height: 20.0,),
                            Obx(() {
                              return _forgetPasswordController.bSetForget.value
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton.icon(
                                      onPressed: () async {
                                        _forgetPasswordController
                                            .setForgetProggressBar(true);
                                        var oResult =
                                            await _forgetPasswordController.forgetPassword();
                                        _forgetPasswordController
                                            .setForgetProggressBar(false);

                                        if (oResult == true) {
                                          Get.toNamed(AppRoutes.login);
                                        } else {
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.error,
                                            title: 'Oops...',
                                            text: _forgetPasswordController
                                                .oResultData.value,
                                            backgroundColor: Colors.black,
                                            titleColor: Colors.white,
                                            textColor: Colors.white,
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.person),
                                      label: Text(
                                        "submit",
                                        style:  GoogleFonts.cairo(
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
                                    style:  GoogleFonts.cairo(
                                      color: Colors.blue,
                                      fontSize: dWidth >= 550 ? 16 : 8,
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.password_rounded),
                                  label: Text(
                                    "Forget password",
                                    style:  GoogleFonts.cairo(
                                      color: Colors.blue,
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
