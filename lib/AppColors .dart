import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF7B61FF); // Purple header
  static const Color backgroundColor = Color(0xFFEEF0F1); // Background color
  static const Color searchBarColor = Color(0xFF323233); // Dark search bar
  static const Color cardColor = Colors.white; // Card background
  static const Color textColor = Colors.black; // Default text color
  static const Color descriptionTextColor = Color(0xFF666666); // Grey description text

  List<List<Color>> gradients = [
  [Colors.blue.shade100.withOpacity(0.6), Colors.blue.shade300.withOpacity(0.8)],
  [Colors.purple.shade100.withOpacity(0.6), Colors.purple.shade300.withOpacity(0.8)],
  [Colors.red.shade100.withOpacity(0.6), Colors.red.shade300.withOpacity(0.8)],
  [Colors.green.shade100.withOpacity(0.6), Colors.green.shade300.withOpacity(0.8)],
  [Colors.orange.shade100.withOpacity(0.6), Colors.orange.shade300.withOpacity(0.8)],
  [Colors.pink.shade100.withOpacity(0.6), Colors.pink.shade300.withOpacity(0.8)],
  [Colors.teal.shade100.withOpacity(0.6), Colors.teal.shade300.withOpacity(0.8)],
  [Colors.cyan.shade100.withOpacity(0.6), Colors.cyan.shade300.withOpacity(0.8)],
  [Colors.amber.shade100.withOpacity(0.6), Colors.amber.shade300.withOpacity(0.8)],
  [Colors.indigo.shade100.withOpacity(0.6), Colors.indigo.shade300.withOpacity(0.8)],
  [Colors.deepPurple.shade100.withOpacity(0.6), Colors.deepPurple.shade300.withOpacity(0.8)],
  [Colors.lightBlue.shade100.withOpacity(0.6), Colors.lightBlue.shade300.withOpacity(0.8)],
  [Colors.lime.shade100.withOpacity(0.6), Colors.lime.shade300.withOpacity(0.8)],
  [Colors.deepOrange.shade100.withOpacity(0.6), Colors.deepOrange.shade300.withOpacity(0.8)],
  [Colors.brown.shade100.withOpacity(0.6), Colors.brown.shade300.withOpacity(0.8)],
  [Colors.grey.shade100.withOpacity(0.6), Colors.grey.shade300.withOpacity(0.8)],
  [Colors.blueGrey.shade100.withOpacity(0.6), Colors.blueGrey.shade300.withOpacity(0.8)],
  [Colors.greenAccent.shade100.withOpacity(0.6), Colors.greenAccent.shade200.withOpacity(0.8)],
  [Colors.redAccent.shade100.withOpacity(0.6), Colors.redAccent.shade200.withOpacity(0.8)],
  [Colors.purpleAccent.shade100.withOpacity(0.6), Colors.purpleAccent.shade200.withOpacity(0.8)],

  // **White-Transparent Combinations**
  [Colors.white.withOpacity(0.5), Colors.blue.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.purple.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.red.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.green.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.orange.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.pink.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.teal.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.cyan.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.amber.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.indigo.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.deepPurple.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.lightBlue.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.lime.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.deepOrange.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.brown.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.grey.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.blueGrey.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.greenAccent.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.redAccent.shade100.withOpacity(0.5)],
  [Colors.white.withOpacity(0.5), Colors.purpleAccent.shade100.withOpacity(0.5)],

  // **More Blended White Gradients**
  [Colors.white.withOpacity(0.4), Colors.blueGrey.withOpacity(0.7)],
  [Colors.white.withOpacity(0.4), Colors.indigo.withOpacity(0.7)],
  [Colors.white.withOpacity(0.4), Colors.deepOrange.withOpacity(0.7)],
  [Colors.white.withOpacity(0.4), Colors.teal.withOpacity(0.7)],
  [Colors.white.withOpacity(0.4), Colors.pink.withOpacity(0.7)],
  [Colors.white.withOpacity(0.4), Colors.red.withOpacity(0.7)],
  [Colors.white.withOpacity(0.4), Colors.green.withOpacity(0.7)],
  [Colors.white.withOpacity(0.4), Colors.amber.withOpacity(0.7)],
  [Colors.white.withOpacity(0.4), Colors.lime.withOpacity(0.7)],
  [Colors.white.withOpacity(0.4), Colors.cyan.withOpacity(0.7)],
  [Colors.white.withOpacity(0.4), Colors.blue.shade300.withOpacity(0.7)],
  [Colors.white.withOpacity(0.4), Colors.deepPurple.shade300.withOpacity(0.7)],

  // **Pastel Transparent Gradients**
  [Colors.pink.shade50.withOpacity(0.5), Colors.purple.shade100.withOpacity(0.7)],
  [Colors.blue.shade50.withOpacity(0.5), Colors.cyan.shade100.withOpacity(0.7)],
  [Colors.orange.shade50.withOpacity(0.5), Colors.deepOrange.shade100.withOpacity(0.7)],
  [Colors.green.shade50.withOpacity(0.5), Colors.lime.shade100.withOpacity(0.7)],
  [Colors.grey.shade50.withOpacity(0.5), Colors.blueGrey.shade100.withOpacity(0.7)],
  [Colors.amber.shade50.withOpacity(0.5), Colors.yellow.shade100.withOpacity(0.7)],
  [Colors.teal.shade50.withOpacity(0.5), Colors.lightBlue.shade100.withOpacity(0.7)],
  [Colors.red.shade50.withOpacity(0.5), Colors.pink.shade100.withOpacity(0.7)],
  [Colors.deepPurple.shade50.withOpacity(0.5), Colors.indigo.shade100.withOpacity(0.7)],

  // **Unique Soft Transparent White Blends**
  [Colors.white.withOpacity(0.3), Colors.blue.withOpacity(0.6)],
  [Colors.white.withOpacity(0.3), Colors.purple.withOpacity(0.6)],
  [Colors.white.withOpacity(0.3), Colors.red.withOpacity(0.6)],
  [Colors.white.withOpacity(0.3), Colors.green.withOpacity(0.6)],
  [Colors.white.withOpacity(0.3), Colors.orange.withOpacity(0.6)],
  [Colors.white.withOpacity(0.3), Colors.teal.withOpacity(0.6)],
  [Colors.white.withOpacity(0.3), Colors.pink.withOpacity(0.6)],
  [Colors.white.withOpacity(0.3), Colors.indigo.withOpacity(0.6)],
  [Colors.white.withOpacity(0.3), Colors.blueGrey.withOpacity(0.6)],
  [Colors.white.withOpacity(0.3), Colors.lime.withOpacity(0.6)],
];

}



