import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLHelper {
  static Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, note TEXT, date TEXT)',
        );
      },
      version: 1,
    );
  }

  // Create new note
  static Future<int> addNote(String title, String note, String date) async {
    final db = await _getDatabase();
    final data = {'title': title, 'note': note, 'date': date};
    return await db.insert('notes', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Read all notes
  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await _getDatabase();
    return await db.query('notes', orderBy: 'id');
  }

  // Update a note
  static Future<int> updateNote(
      int id, String title, String note, String date) async {
    final db = await _getDatabase();
    final data = {'title': title, 'note': note, 'date': date};
    return await db.update('notes', data, where: 'id = ?', whereArgs: [id]);
  }

  // Delete a note
  static Future<void> deleteNote(int id) async {
    final db = await _getDatabase();
    try {
      await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Something went wrong when deleting a note: $e');
    }
  }
}
