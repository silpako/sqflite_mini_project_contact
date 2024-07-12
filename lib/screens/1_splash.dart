import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_mini_project_contact/screens/2_ui_screen.dart';
import 'package:sqflite_mini_project_contact/screens/4_colors.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()));
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 4), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => NoteApp()));
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo/notesss.png",
              height: 150,
              width: 150,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Note Keeper",
              style: GoogleFonts.bonaNova(
                  color: MyColors.ThemeColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
