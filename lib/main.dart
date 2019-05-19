import 'package:flutter/material.dart';
import 'package:notepad/screens/notes_list/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notepad',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: NoteList(),
    );
  }
}
