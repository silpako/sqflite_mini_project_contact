import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_mini_project_contact/screens/4_colors.dart';
import 'package:sqflite_mini_project_contact/screens/3_db_helper.dart';
import 'package:sqflite_mini_project_contact/screens/5_settings.dart';
import 'package:sqflite_mini_project_contact/screens/6_privacy.dart';

void main() {
  runApp(MaterialApp(
    home: NoteApp(),
  ));
}

class NoteApp extends StatefulWidget {
  @override
  _NoteAppState createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  List<Map<String, dynamic>> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future<void> refreshNotes() async {
    final data = await SQLHelper.getNotes();
    setState(() {
      notes = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: MyColors.ThemeColor,
        title: Text(
          'My Notes',
          style: GoogleFonts.bonaNova(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          Container(
            width: 30,
            height: 30,
            child: PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text("Settings",
                      style: GoogleFonts.sansita(
                        fontSize: 15,
                      )),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text("Privacy",
                      style: GoogleFonts.sansita(
                        fontSize: 15,
                      )),
                  value: 2,
                ),
              ];
            }, onSelected: (value) {
              switch (value) {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Setting()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Privacy()),
                  );
                  break;
                default:
              }
            }),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(notes[index]['title']),
                  subtitle: Text(notes[index]['note']),
                  onTap: () => showNoteDetailDialog(notes[index]),
                  trailing: Wrap(
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () =>
                              showNoteDialog(id: notes[index]['id'])),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              deleteNoteDialog(notes[index]['id'])),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.ThemeColor,
        onPressed: () => showNoteDialog(),
        child: Icon(Icons.edit),
      ),
    );
  }

  final titleController = TextEditingController();
  final noteController = TextEditingController();

  void showNoteDialog({int? id}) {
    if (id != null) {
      final existingNote = notes.firstWhere((element) => element['id'] == id);
      titleController.text = existingNote['title'];
      noteController.text = existingNote['note'];
    } else {
      titleController.clear();
      noteController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            id == null ? 'Add Note' : 'Update Note',
            style: GoogleFonts.bonaNova(
                color: MyColors.ThemeColor,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                cursorColor: MyColors.cursorColor,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: MyColors.focusedBorderColor, width: 2.0),
                    ),
                    hintText: 'Title',
                    hintStyle: GoogleFonts.bonaNova()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: noteController,
                cursorColor: MyColors.cursorColor,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: MyColors.focusedBorderColor, width: 2.0),
                    ),
                    hintText: 'Note',
                    hintStyle: GoogleFonts.bonaNova()),
              ),
              SizedBox(height: 10),
              if (id != null)
                Text(
                  'Date: ${notes.firstWhere((element) => element['id'] == id)['date']}',
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (id == null) {
                  addNote();
                } else {
                  updateNote(id);
                }
                Navigator.pop(context);
              },
              child: Text(
                id == null ? 'Add' : 'Update',
                style: GoogleFonts.bonaNova(
                    color: MyColors.ThemeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.bonaNova(
                    color: MyColors.ThemeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  void showNoteDetailDialog(Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(note['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(note['note']),
            SizedBox(height: 10),
            Text('Date: ${note['date']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.bonaNova(
                  color: MyColors.ThemeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addNote() async {
    final date = DateTime.now().toIso8601String();
    await SQLHelper.addNote(
      titleController.text,
      noteController.text,
      date,
    );
    refreshNotes();
  }

  Future<void> updateNote(int id) async {
    final date = DateTime.now().toIso8601String();
    await SQLHelper.updateNote(
      id,
      titleController.text,
      noteController.text,
      date,
    );
    refreshNotes();
  }

  Future<void> deleteNoteDialog(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Note ?',
          style: GoogleFonts.bonaNova(
              fontWeight: FontWeight.bold, color: MyColors.ThemeColor),
        ),
        content: Text(
          'Are you sure you want to delete this note?',
          style: GoogleFonts.bonaNova(),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await SQLHelper.deleteNote(id);
              refreshNotes();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Note deleted successfully')),
              );
            },
            child: Text(
              'Yes',
              style: GoogleFonts.bonaNova(
                  color: MyColors.ThemeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: GoogleFonts.bonaNova(
                  color: MyColors.ThemeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}