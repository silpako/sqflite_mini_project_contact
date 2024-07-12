import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_mini_project_contact/screens/4_colors.dart';
import 'package:sqflite_mini_project_contact/screens/3_db_helper.dart'; // Assuming this is your SQLHelper file
import 'package:sqflite_mini_project_contact/screens/5_settings.dart';
import 'package:sqflite_mini_project_contact/screens/6_privacy.dart';

class NoteApp extends StatefulWidget {
  @override
  _NoteAppState createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> filteredNotes = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshNotes();
    searchController.addListener(_filterNotes);
  }

  Future<void> refreshNotes() async {
    final data = await SQLHelper.getNotes();
    setState(() {
      notes = data;
      filteredNotes = data;
      isLoading = false;
    });
  }

  void _filterNotes() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredNotes = notes.where((note) {
        final noteTitle = note['title'].toLowerCase();
        final noteContent = note['note'].toLowerCase();
        return noteTitle.contains(query) || noteContent.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.ThemeColor,
        title: Text(
          'My Notes',
          style: GoogleFonts.bonaNova(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              width: double.infinity,
              height: 40,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: GoogleFonts.bonaNova(),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: MyColors.ThemeColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(filteredNotes[index]['title']),
                  subtitle: Text(filteredNotes[index]['note']),
                  onTap: () => showNoteDetailDialog(filteredNotes[index]),
                  trailing: Wrap(
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () =>
                              showNoteDialog(id: filteredNotes[index]['id'])),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              deleteNoteDialog(filteredNotes[index]['id'])),
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
                SnackBar(
                  content: Text(
                    'Note deleted successfully',
                    style: GoogleFonts.bonaNova(),
                  ),
                  backgroundColor: MyColors.ThemeColor,
                ),
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
