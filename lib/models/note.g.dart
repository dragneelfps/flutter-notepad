// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) {
  return Note(
      id: json['id'] as String,
      data: json['data'] as String,
      createdAt: json['createdAt'] as int,
      categoryId: json['categoryId'] as String);
}

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
      'createdAt': instance.createdAt,
      'categoryId': instance.categoryId
    };
