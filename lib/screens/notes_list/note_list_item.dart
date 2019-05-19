import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notepad/models/category.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/utils/helpers.dart';

typedef void NoteClickedListener(Note note);

class NoteListItem extends StatelessWidget {
  final Note note;
  final NoteClickedListener onNoteClick;
  final Category category;

  final DateFormat _df = DateFormat('HH:mm dd-MMM-yy');

  NoteListItem({@required this.note, this.onNoteClick, this.category});

  @override
  Widget build(BuildContext context) {
    final noteCategory = category != null ? category.name : '-';
    return ListTile(
        title: Text(note.data),
        subtitle: Text(formatDate(note, _df)),
        trailing: Text(noteCategory));
  }
}
