import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_mini_project_contact/screens/4_colors.dart';

class Setting extends StatelessWidget {
  final List<Map<String, String>> settingsOptions = [
    {"title": "Manage Notification", "subtitle": "Notifications settings"},
    {"title": "About", "subtitle": "Learn more about the app"},
    {"title": "Version", "subtitle": "App version info"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: MyColors.ThemeColor,
        title: Text(
          'Settings',
          style: GoogleFonts.bonaNova(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: settingsOptions.length,
        itemBuilder: (context, index) {
          final option = settingsOptions[index];
          return ListTile(
            title: Text(
              option['title']!,
              style: GoogleFonts.bonaNova(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: MyColors.texColor),
            ),
            subtitle: Text(
              option['subtitle']!,
              style: GoogleFonts.bonaNova(),
            ),
            onTap: () {
              switch (index) {
                case 0:
                  break;
                case 1:
                  break;
                case 2:
                  // Show version info
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Version",
                            style: GoogleFonts.bonaNova(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: MyColors.texColor)),
                        content: Text(
                          "App version: 1.0.0",
                          style: GoogleFonts.bonaNova(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Close',
                              style: GoogleFonts.bonaNova(
                                color: MyColors.ThemeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                  break;
              }
            },
          );
        },
      ),
    );
  }
}
