import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  static const TABLE_NAME = "notes";
  static const COLUMNS = ['id', 'data', 'createdAt', 'categoryId'];

  static const TABLE_CREATE_QUERY = '''
    CREATE TABLE $TABLE_NAME (
      id TEXT PRIMARY KEY,
      data TEXT NOT NULL,
      createdAt INTEGER NOT NULL,
      categoryId TEXT,
      FOREIGN KEY (categoryId) REFERENCES category (id)
        ON DELETE SET NULL ON UPDATE CASCADE
    )
  ''';

  String id;
  String data;
  int createdAt;
  String categoryId;

  Note({this.id, this.data, this.createdAt, this.categoryId});

  Note.create(this.data, this.categoryId) {
    final uuid = Uuid();
    this.id = uuid.v4();
    this.createdAt = DateTime.now().millisecondsSinceEpoch;
  }

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
