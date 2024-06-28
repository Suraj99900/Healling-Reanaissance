import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownTimerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime endTime = DateTime(2025, 6, 22, 6, 8, 0);
    int endTimeInMilliseconds = endTime.millisecondsSinceEpoch;
    var dWidth = Get.width;
    var dHeight = Get.height;

    return Card(
      elevation: 0, // Add elevation for shadow effect
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Add border radius for card
      ),
      child: Padding(
        padding: EdgeInsets.all((dWidth >= 850 ?16.0: 5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Countdown Timer',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                  fontSize: dWidth >= 850 ? dWidth * 0.015 :  dWidth * 0.02,
                  color: const Color.fromARGB(173, 34, 13, 2),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            CountdownTimer(
              endTime: endTimeInMilliseconds,
              textStyle: GoogleFonts.cairo(
                textStyle: TextStyle(
                  fontSize: dWidth >= 850 ? dWidth * 0.015 :  dWidth * 0.02,
                  color: const Color.fromARGB(173, 34, 13, 2),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onEnd: () {
                // Add your action when the countdown ends
              },
            ),
          ],
        ),
      ),
    );
  }
}
