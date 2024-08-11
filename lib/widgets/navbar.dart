import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellness_app/SharedPreferencesHelper.dart';
import 'package:wellness_app/route/route.dart';
import 'package:wellness_app/utils/responsiveLayout.dart';

import '../screen/commonfunction.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String? id;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    String? userId = await SharedPreferencesHelper.getUserId("sUserId");
    setState(() {
      id = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;

    return Padding(
      padding: EdgeInsets.only(
        top: dWidth > 950 ? dWidth * 0.01 : dWidth * 0.1,
        bottom: dWidth * 0.02,
        right: dWidth * 0.01,
        left: dWidth * 0.02,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: dWidth > 850 ? dWidth * 0.03 : dWidth * 0.09,
                    height: dWidth > 850 ? dWidth * 0.03 : dWidth * 0.09,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                            colors: [
                              Color(0xFFC86DD7),
                              Color(0xFF3023AE),
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft)),
                    child: Center(
                      child: Text("K",
                          style: TextStyle(
                              fontSize:
                                  dWidth > 850 ? dWidth * 0.02 : dWidth * 0.05,
                              color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    width: dWidth > 850 ? dWidth * 0.009 : dWidth * 0.01,
                  ),
                  Text(
                    "Healing Renaissance",
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: dWidth >= 850 ? dWidth * 0.01 : dWidth * 0.04,
                        color: Color.fromARGB(173, 34, 13, 2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  (id == null || id == '0')
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => {
                                Get.toNamed(AppRoutes.login),
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: dWidth > 850 ? 10 : dWidth * 0.01,
                                ),
                                width: dWidth > 850 ? 120 : dWidth * 0.13,
                                height: dWidth > 850 ? 40 : dWidth * 0.06,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFC86DD7),
                                          Color(0xFF3023AE)
                                        ],
                                        begin: Alignment.bottomRight,
                                        end: Alignment.topLeft),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color(0xFF6078ea).withOpacity(.3),
                                          offset: Offset(0, 8),
                                          blurRadius: 8)
                                    ]),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontSize: dWidth >= 850
                                            ? dWidth * 0.01
                                            : dWidth * 0.02,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width:
                                  dWidth > 850 ? dWidth * 0.02 : dWidth * 0.01,
                            ),
                            InkWell(
                              onTap: () => {
                                Get.toNamed(AppRoutes.adminLogin),
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: dWidth > 850 ? 10 : dWidth * 0.01,
                                ),
                                width: dWidth > 850 ? 160 : dWidth * 0.18,
                                height: dWidth > 850 ? 40 : dWidth * 0.06,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFC86DD7),
                                        Color(0xFF3023AE)
                                      ],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xFF6078ea).withOpacity(.3),
                                        offset: Offset(0, 8),
                                        blurRadius: 8)
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      "Register User",
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontSize: dWidth >= 850
                                            ? dWidth * 0.01
                                            : dWidth * 0.02,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width:
                                  dWidth > 850 ? dWidth * 0.02 : dWidth * 0.03,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            InkWell(
                              onTap: () => {
                                Get.toNamed(AppRoutes.zoom),
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: dWidth > 850 ? 10 : dWidth * 0.01,
                                ),
                                width: dWidth > 850 ? 160 : dWidth * 0.18,
                                height: dWidth > 850 ? 40 : dWidth * 0.06,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFC86DD7),
                                        Color(0xFF3023AE)
                                      ],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xFF6078ea).withOpacity(.3),
                                        offset: Offset(0, 8),
                                        blurRadius: 8)
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      "Dashboard",
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontSize: dWidth >= 850
                                            ? dWidth * 0.01
                                            : dWidth * 0.02,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => {
                                buildButton("Log Out", AppRoutes.initial, Colors.red),
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: dWidth > 850 ? 10 : dWidth * 0.01,
                                ),
                                width: dWidth > 850 ? 160 : dWidth * 0.18,
                                height: dWidth > 850 ? 40 : dWidth * 0.06,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFC86DD7),
                                        Color(0xFF3023AE)
                                      ],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xFF6078ea).withOpacity(.3),
                                        offset: Offset(0, 8),
                                        blurRadius: 8)
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      "Log Out",
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontSize: dWidth >= 850
                                            ? dWidth * 0.01
                                            : dWidth * 0.02,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    width: dWidth > 850 ? dWidth * 0.02 : dWidth * 0.03,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: dWidth >= 850 ? dWidth * 0.05 : dWidth * 0.0009,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => {
                    Get.toNamed(AppRoutes.userHomeScreen),
                  },
                  child: Text(
                    "Home",
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize:
                            dWidth >= 850 ? dWidth * 0.01 : dWidth * 0.035,
                        color: Color.fromARGB(173, 34, 13, 2),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: dWidth > 850 ? dWidth * 0.009 : dWidth * 0.01,
                ),
                InkWell(
                  onTap: () => {
                    Get.toNamed(AppRoutes.zoom),
                  },
                  child: Text(
                    "Category",
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: dWidth >= 850 ? dWidth * 0.01 : dWidth * 0.03,
                        color: Color.fromARGB(173, 34, 13, 2),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: dWidth > 850 ? dWidth * 0.009 : dWidth * 0.01,
                ),
                InkWell(
                  onTap: () => {
                    // Get.toNamed(AppRoutes.zoom),
                    LaunchURL("http://lifehealerkavita.com/"),
                  },
                  child: Text(
                    "About",
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: dWidth >= 850 ? dWidth * 0.01 : dWidth * 0.03,
                        color: Color.fromARGB(173, 34, 13, 2),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: dWidth > 850 ? dWidth * 0.02 : dWidth * 0.01,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
