import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  static const TABLE_NAME = "categories";
  static const COLUMNS = ['id', 'name'];

  static const TABLE_CREATE_QUERY = '''
    CREATE TABLE $TABLE_NAME(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL
    )
  ''';

  String id;
  String name;

  Category({this.id, this.name});

  Category.create(this.name) : id = Uuid().v4();

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
