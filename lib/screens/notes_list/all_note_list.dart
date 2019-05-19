import 'package:flutter/material.dart';
import 'package:notepad/models/category.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/screens/notes_list/note_list_item.dart';
import 'package:notepad/screens/notes_list/sort_order.dart';
import 'package:notepad/utils/pair.dart';

class AllNotesList extends StatelessWidget {
  final List<Pair<Note, Category>> data;
  final SortOrder sortOrder;

  AllNotesList({@required this.data, this.sortOrder = SortOrder.DATE}) {
    _sortList();
  }

  void _sortList() {
    if (sortOrder == SortOrder.DATE) {
      data.sort(
          (first, second) => first.first.createdAt - second.first.createdAt);
    } else if (sortOrder == SortOrder.TEXT) {
      data.sort(
          (first, second) => first.first.data.compareTo(second.first.data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8),
      children: this.data.map((noteListItem) {
        return NoteListItem(
            note: noteListItem.first, category: noteListItem.second);
      }).toList(),
    );
  }
}
