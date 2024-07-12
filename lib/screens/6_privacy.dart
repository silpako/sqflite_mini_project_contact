import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_mini_project_contact/screens/4_colors.dart';

class Privacy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffoldColor,
      appBar: AppBar(
          backgroundColor: MyColors.ThemeColor,
          title: Text('Privacy',
              style: GoogleFonts.bonaNova(fontWeight: FontWeight.bold))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.privacy_tip_rounded,
              size: 50.0,
            ),
            SizedBox(
              height: 30,
            ),
            Text("Last updated and effective 31 july 2023"),
          ],
        ),
      ),
    );
  }
}
