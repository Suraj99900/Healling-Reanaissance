import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_flutter_icons/new_flutter_icons.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wellness_app/controller/userHomeController.dart';
import 'package:wellness_app/route/route.dart';
import 'package:wellness_app/screen/commonfunction.dart';
import 'package:wellness_app/widgets/CountdownTimerWidget.dart';
import 'package:wellness_app/widgets/Search.dart';
import 'package:wellness_app/widgets/navbar.dart';
import 'package:wellness_app/widgets/slider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;
    UserHomeController userHomeController = UserHomeController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(40, 0, 0, 0),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8FBFF),
                Color.fromARGB(255, 234, 201, 244),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: dWidth * 0.00),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: dHeight * 0.02),
                NavBar(),
                SizedBox(height: dHeight * 0.1),
                dWidth > 950
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: dWidth * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello!",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: dWidth >= 850
                                          ? dWidth * 0.03
                                          : dWidth * 0.05,
                                      color: const Color(0xFF8591B0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: "WellCome To ",
                                    style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                        fontSize: dWidth >= 850
                                            ? dWidth * 0.03
                                            : dWidth * 0.05,
                                        color: const Color(0xFF8591B0),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Healing Renaissance",
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            fontSize: dWidth >= 850
                                                ? dWidth * 0.03
                                                : dWidth * 0.05,
                                            color: const Color.fromARGB(
                                                173, 34, 13, 2),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Image.asset("assets/images/userHome_2.gif",
                                scale: 1),
                          ),
                        ],
                      )
                    : Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: dWidth * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello!",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: dWidth >= 850
                                          ? dWidth * 0.03
                                          : dWidth * 0.05,
                                      color: const Color(0xFF8591B0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: "WellCome To ",
                                    style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                        fontSize: dWidth >= 850
                                            ? dWidth * 0.03
                                            : dWidth * 0.05,
                                        color: const Color(0xFF8591B0),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Healing Renaissance",
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            fontSize: dWidth >= 850
                                                ? dWidth * 0.03
                                                : dWidth * 0.05,
                                            color: const Color.fromARGB(
                                                173, 34, 13, 2),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Image.asset("assets/images/userHome_2.gif",
                                scale: 1),
                          ),
                        ],
                      ),

                Padding(
                  padding: EdgeInsets.only(left: dWidth * 0.02, top: 20),
                  child: Text(
                    "LET’S EXPLORE THE WORLD",
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: dWidth >= 850 ? dWidth * 0.01 : dWidth * 0.03,
                        color: const Color.fromARGB(173, 34, 13, 2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: dWidth > 850 ?dWidth * 0.5: dWidth * 0.8,
                  child: Search(),
                ),
                SizedBox(
                  height: dWidth > 850 ? dHeight * 0.1:dHeight * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: dWidth > 850 ?dWidth * 0.5:dWidth * 0.9,
                          alignment: Alignment.center,
                          child: Card(
                            margin: const EdgeInsets.all(10.0),
                            color: const Color.fromARGB(48, 252, 251, 251),
                            elevation: 0, // Add elevation for shadow effect
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            borderOnForeground: true,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  '10X Your Power Of Manifestation Within 2 Hours',
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: dWidth >= 850
                                          ? dWidth * 0.02
                                          : dWidth * 0.03,
                                      color:
                                          const Color.fromARGB(173, 34, 13, 2),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: dHeight * 0.02,
                ),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 50.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 179, 210, 245),
                          Color.fromARGB(210, 243, 240, 243),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 8),
                            blurRadius: 8)
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: dWidth * 0.5,
                              child: Text(
                                "Revealing the “4D Success Framework” that will help you get unstuck from an unfulfilling corporate job, restart your career at any age, and find your true calling, happiness & peace! Career growth, income hike, dream job manifestation, unexpected promotion - ready to push the restart button of your career",
                                style: GoogleFonts.cairo(
                                  textStyle: TextStyle(
                                    fontSize: dWidth >= 850
                                        ? dWidth * 0.015
                                        : dWidth * 0.02,
                                    color: const Color.fromARGB(173, 34, 13, 2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                                width:
                                    dWidth >= 850
                                        ? 40
                                        : dWidth * 0.02),
                            Card(
                              elevation: 5, // Add elevation for shadow effect
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Container(
                                width:dWidth >= 950? 400 :dWidth * 0.3,
                                height: dWidth >= 950? 400 :dWidth * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Image.asset("assets/images/web1.jpg",fit: BoxFit.fill,),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: dWidth >= 850 ?dHeight * 0.1 : dHeight * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 50.0, bottom: 50.0, left: 20, right: 20),
                              child: SizedBox(
                                width: dWidth * 0.6,
                                child: Text(
                                  'अपूर्ण कॉर्पोरेट नोकरीतून मुक्त होण्यासाठी, कोणत्याही वयात, आपल्या वास्तविक कॉलिंग, आनंद आणि शांततेवर पुन्हा करिअर सुरु करण्यास मदत करणारा "4D सफलता फ्रेमवर्क" उघडणारा!करिअर विकास, इनकम वाढ, स्वप्न नोकरी साकारण, अनपेक्षित प्रमोशन - आपल्या करिअरचे पुनरारंभ करण्यासाठी पुश करण्यासाठी तयार?"',
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: dWidth >= 850
                                          ? dWidth * 0.011
                                          : dWidth * 0.02,
                                      color: const Color.fromARGB(164, 34, 13, 2),
                                      fontWeight: FontWeight.w400,
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
                ),
                SizedBox(
                  height: dWidth >= 850 ?dHeight * 0.1 : dHeight * 0.01,
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 20.0, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Card(
                            elevation: 0, // Add elevation for shadow effect
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                LaunchURL(
                                    "https://rzp.io/i/KNhuciEeUM");
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Reserve your Spot @just 99/-\nतुमचे स्थान राखा @केवळ ९९/-',
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: dWidth >= 850
                                          ? dWidth * 0.015
                                          : dWidth * 0.02,
                                      color:
                                          const Color.fromARGB(173, 34, 13, 2),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CountdownTimerCard(),
                          Card(
                            elevation: 0, // Add elevation for shadow effect
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.all((dWidth >= 850 ?20.0: 5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '22 June 2024, Saturday',
                                    style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                        fontSize: dWidth >= 850
                                            ? dWidth * 0.015
                                            :  dWidth * 0.02,
                                        color: const Color.fromARGB(
                                            173, 34, 13, 2),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Time: 6 am To 8 am',
                                    style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                        fontSize: dWidth >= 850
                                            ? dWidth * 0.015
                                            : dWidth * 0.02,
                                        color: const Color.fromARGB(
                                            173, 34, 13, 2),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                 height: dWidth >= 850 ?dHeight * 0.1 : dHeight * 0.0,
                ),
                const ImageSlider(),
                SizedBox(
                 height: dWidth >= 850 ?dHeight * 0.1 : dHeight * 0.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Card(
                    elevation: 0, // Add elevation for shadow effect
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: dWidth > 850 ? dWidth * 0.3 :dWidth * 0.5,
                            child: Column(
                              children: [
                                Text(
                                  "“RESTART YOUR LIFE” 2:00-HOUR ",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: dWidth >= 850
                                          ? dWidth * 0.01
                                          : dWidth * 0.02,
                                      color:
                                          const Color.fromARGB(173, 34, 13, 2),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "आपल्या जीवनाचे पुनरारंभ करा 2:00 तासांचे.",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: dWidth >= 850
                                          ? dWidth * 0.01
                                          : dWidth * 0.02,
                                      color:
                                          const Color.fromARGB(173, 34, 13, 2),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "22 June 2024,SaturdayTime: 6 am To 8 am",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: dWidth >= 850
                                          ? dWidth * 0.01
                                          : dWidth * 0.02,
                                      color:
                                          const Color.fromARGB(173, 34, 13, 2),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   width: dWidth * 0.09,
                          // ),
                          InkWell(
                            onTap: () => {
                              LaunchURL('https://rzp.io/i/KNhuciEeUM'),
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 20),
                              width:  dWidth >= 850 ?280 : dWidth * 0.3,
                              height: dWidth >= 850?70 : dHeight * 0.04,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFC86DD7),
                                      Color(0xFF3023AE)
                                    ],
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0xFF6078ea).withOpacity(.3),
                                      offset: const Offset(0, 8),
                                      blurRadius: 8)
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: Center(
                                  child: Text(
                                    "Click Here to Get Access",
                                    style: GoogleFonts.cairo(
                                      color: Colors.white,
                                      fontSize:  dWidth> 850
                                          ? 18
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
                    ),
                  ),
                ),
                SizedBox(
                 height: dWidth >= 850 ?dHeight * 0.1 : dHeight * 0.01,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 179, 210, 245),
                        Color.fromARGB(210, 243, 240, 243),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 8),
                          blurRadius: 8)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: dWidth * 0.5,
                        padding: EdgeInsets.all(dWidth * 0.09),
                        child: Form(
                          key: userHomeController.userFormContact,
                          child: Column(
                            children: [
                              Text(
                                "Contact Us",
                                style: GoogleFonts.arsenal(
                                  textStyle: TextStyle(
                                    fontSize: dWidth > 900
                                        ? dWidth * 0.02
                                        : dWidth * 0.05,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  hintText: 'Enter your name',
                                  labelStyle: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: dWidth > 900
                                        ? dWidth * 0.01
                                        : dWidth * 0.03,
                                  ),
                                  hintStyle: TextStyle(
                                    color: const Color.fromARGB(179, 0, 0, 0),
                                    fontSize: dWidth > 900
                                        ? dWidth * 0.01
                                        : dWidth * 0.03,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userHomeController.FirstName.value = value!;
                                },
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  hintText: 'Enter Phone Number',
                                  labelStyle: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: dWidth > 900
                                        ? dWidth * 0.01
                                        : dWidth * 0.03,
                                  ),
                                  hintStyle: TextStyle(
                                    color: const Color.fromARGB(179, 0, 0, 0),
                                    fontSize: dWidth > 900
                                        ? dWidth * 0.01
                                        : dWidth * 0.03,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the phone number';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userHomeController.FirstName.value = value!;
                                },
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'Enter your email',
                                  labelStyle: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: dWidth > 900
                                        ? dWidth * 0.01
                                        : dWidth * 0.03,
                                  ),
                                  hintStyle: TextStyle(
                                    color: const Color.fromARGB(179, 0, 0, 0),
                                    fontSize: dWidth > 900
                                        ? dWidth * 0.01
                                        : dWidth * 0.03,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the Email';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userHomeController.FirstName.value = value!;
                                },
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                decoration: InputDecoration(
                                  labelText: 'Message',
                                  hintText: 'Enter your message',
                                  labelStyle: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: dWidth > 900
                                        ? dWidth * 0.01
                                        : dWidth * 0.03,
                                  ),
                                  hintStyle: TextStyle(
                                    color: const Color.fromARGB(179, 0, 0, 0),
                                    fontSize: dWidth > 900
                                        ? dWidth * 0.01
                                        : dWidth * 0.03,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the Message';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userHomeController.FirstName.value = value!;
                                },
                              ),
                              SizedBox(
                               height: dWidth >= 850 ?dHeight * 0.1 : dHeight * 0.01,
                              ),
                              Obx(
                                () {
                                  return userHomeController
                                          .isAddingFormData.value
                                      ? const CircularProgressIndicator()
                                      : InkWell(
                                          onTap: () async {
                                            userHomeController
                                                .setAddingFormData(true);
                                            var oResult =
                                                await userHomeController
                                                    .addFormData();
                                            userHomeController
                                                .setAddingFormData(false);

                                            if (oResult == true) {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.success,
                                                // text: _categoryController
                                                //     .oResultData.value,
                                                autoCloseDuration:
                                                    const Duration(seconds: 2),
                                                showConfirmBtn: false,
                                              );

                                              Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                Get.offNamed(
                                                    AppRoutes.categoryManage);
                                              });
                                            } else {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.error,
                                                title: 'Oops...',
                                                // text: _categoryController
                                                //     .oResultData.value,
                                                backgroundColor: Colors.black,
                                                titleColor: Colors.white,
                                                textColor: Colors.white,
                                              );
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 20),
                                            width: dWidth >850 ? 100: dWidth * 0.15,
                                            height: dWidth >850 ? 50: 30,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFFC86DD7),
                                                    Color(0xFF3023AE)
                                                  ],
                                                  begin: Alignment.bottomRight,
                                                  end: Alignment.topLeft),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: const Color(0xFF6078ea)
                                                        .withOpacity(.3),
                                                    offset: const Offset(0, 8),
                                                    blurRadius: 8)
                                              ],
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Center(
                                                child: Text(
                                                  "Submit",
                                                  style: GoogleFonts.cairo(
                                                    color: Colors.white,
                                                    fontSize: dWidth > 850
                                                        ? dWidth * 0.009
                                                        : dWidth * 0.02,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                       height: dWidth >= 850 ?dHeight * 0.1 : dHeight * 0.01,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Image.asset("assets/images/image_01.png",
                            scale: dWidth >= 950 ? .8:dWidth >= 550? 3:5),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                 height: dWidth >= 850 ?dHeight * 0.1 : dHeight * 0.01,
                ),
                // footer
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Color.fromARGB(255, 2, 23, 47),
                    //     Color.fromARGB(210, 166, 176, 180),
                    //   ],
                    // ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        color: Colors.black,
                        elevation: 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: dWidth * 0.01,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      FontAwesome.instagram,
                                      size: dWidth > 850 ? dWidth * 0.02: dWidth * 0.05,
                                      color: const Color.fromARGB(255, 255, 110, 207),
                                    ),
                                  ),
                                  SizedBox(
                                    width: dWidth * 0.01,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      FontAwesome.facebook,
                                      size: dWidth > 850 ? dWidth * 0.02: dWidth * 0.05,
                                      color: Colors.blue[600],
                                    ),
                                  ),
                                  SizedBox(
                                    width: dWidth * 0.01,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      FontAwesome.whatsapp,
                                      size: dWidth > 850 ? dWidth * 0.02: dWidth * 0.05,
                                      color: Colors.green[600],
                                    ),
                                  ),
                                  SizedBox(
                                    width: dWidth * 0.01,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                             width: dWidth > 850 ? dWidth * 0.5 : dWidth * 0.1,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 60,
                                ),
                                Text(
                                  "Healling Reanaissance",
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: dWidth >= 850
                                          ? dWidth * 0.01
                                          : dWidth * 0.03,
                                      color: const Color.fromARGB(253, 255, 254, 253),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
