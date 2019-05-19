import 'package:flutter/material.dart';
import 'package:notepad/models/category.dart';
import 'package:notepad/models/note.dart';
import 'package:intl/intl.dart';
import 'package:notepad/utils/helpers.dart';

class NotesByCategories extends StatelessWidget {
  final Map<Category, List<Note>> data;

  final DateFormat _df = DateFormat('HH:mm dd-MMM-yy');

  NotesByCategories({Key key, this.data}) : super(key: key);

  List<Widget> _buildList() {
    final widgetsSections = data.entries.map((notesByCategory) {
      final category = notesByCategory.key;
      final notes = notesByCategory.value;
      final listOfNotes = List<Widget>();
      listOfNotes.add(ListTile(
          title: Text(category.name,
              style: TextStyle(fontWeight: FontWeight.bold))));
      notes.forEach((note) {
        listOfNotes.add(ListTile(
            title: Text(note.data), subtitle: Text(formatDate(note, _df))));
      });
      return listOfNotes;
    }).toList();
    final listItems = List<Widget>();
    widgetsSections.forEach((section) => listItems.addAll(section));
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _buildList(),
    );
  }
}
