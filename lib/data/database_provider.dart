import 'package:notepad/models/category.dart';
import 'package:notepad/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  Database _db;

  bool isInitialized() => _db != null;

  Future create() async {
    if (_db == null) {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, 'notepad.db');
      _db = await openDatabase(path, version: 1, onCreate: _create);
    }
  }

  Future _create(Database db, int version) async {
    await db.execute(Category.TABLE_CREATE_QUERY);
    await db.execute(Note.TABLE_CREATE_QUERY);
  }

  Future insertCategory(Category category) async {
    await _db.insert(Category.TABLE_NAME, category.toJson());
  }

  Future updateCategory(Category category) async {
    await _db.update(Category.TABLE_NAME, {'name': category.name},
        where: 'id = ?', whereArgs: [category.id]);
  }

  Future insertNote(Note note) async {
    await _db.insert(Note.TABLE_NAME, note.toJson());
  }

  Future updateNote(Note note) async {
    await _db.update(
        Note.TABLE_NAME, {'data': note.data, 'categoryId': note.categoryId},
        where: 'id = ?', whereArgs: [note.id]);
  }

  Future deleteNote(String id) async {
    await _db.delete(Note.TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  Future deleteCategory(String id) async {
    await _db.delete(Category.TABLE_NAME, where: 'id =?', whereArgs: [id]);
  }

  Future<Category> getCategory(Note note) async {
    var response = await _db.query(Category.TABLE_NAME,
        columns: Category.COLUMNS,
        where: 'id = ?',
        whereArgs: [note.categoryId]);
    if (response.length > 0) {
      return Category.fromJson(response[0]);
    } else {
      return null;
    }
  }

  Future<List<Note>> getNotes() async {
    var response = await _db.query(Note.TABLE_NAME, columns: Note.COLUMNS);
    return response.map<Note>((json) => Note.fromJson(json)).toList();
  }

  Future<List<Category>> getCategories() async {
    var response =
        await _db.query(Category.TABLE_NAME, columns: Category.COLUMNS);
    return response.map((json) => Category.fromJson(json)).toList();
  }

  Future<Category> getCategoryByName(String name) async {
    var response = await _db
        .query(Category.TABLE_NAME, where: 'name = ?', whereArgs: [name]);
    if (response.isEmpty) {
      return null;
    } else {
      return Category.fromJson(response[0]);
    }
  }

  Future deleteAllCategories() async {
    await _db.delete(Category.TABLE_NAME);
  }

  Future deleteAllNotes() async {
    await _db.delete(Note.TABLE_NAME);
  }
}
