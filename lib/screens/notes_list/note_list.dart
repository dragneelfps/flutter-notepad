import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notepad/data/database_provider.dart';
import 'package:notepad/models/category.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/screens/notes_list/add_category.dart';
import 'package:notepad/screens/notes_list/add_note.dart';
import 'package:notepad/screens/notes_list/all_note_list.dart';
import 'package:notepad/screens/notes_list/fancy_fab.dart';
import 'package:notepad/screens/notes_list/menu.dart';
import 'package:notepad/screens/notes_list/note_list_item.dart';
import 'package:notepad/screens/notes_list/notes_by_categories.dart';
import 'package:notepad/screens/notes_list/sort_order.dart';
import 'package:notepad/utils/pair.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> with WidgetsBindingObserver {
  List<Pair<Note, Category>> data;
  List<Category> categories;
  DatabaseProvider _databaseProvider;

  SortOrder sortOrder = SortOrder.DEFAULT;

  _NoteListState() {
    _databaseProvider = DatabaseProvider();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index == 0) {
      _loadSavedNoteFromOkGoogleIfAny();
    }
  }

  void _loadSavedNoteFromOkGoogleIfAny() async {
    String savedNote = await const MethodChannel('app.channel.shared.data')
        .invokeMethod('getSavedNote');
    if (savedNote != null) {
      new Future.delayed(Duration.zero, () {
        print('received note: $savedNote');
        _displayAddNoteDialog(context, savedNote);
      });
    }
  }

  void _loadData() async {
    await _databaseProvider.create();
    final notes = await _databaseProvider.getNotes();
    final categories = await _databaseProvider.getCategories();
    List<Pair<Note, Category>> data = List();
    notes.forEach((note) {
      var result =
          categories.where((cat) => cat.id == note.categoryId).toList();
      if (result.isNotEmpty) {
        final category = result[0];
        data.add(Pair(note, category));
      } else {
        data.add(Pair(note, null));
      }
    });
    setState(() {
      this.data = data;
      this.categories = categories;
    });
  }

  void _displayAddNoteDialog(BuildContext parentContext,
      [String initialNote]) async {
    final result = await showDialog(
        context: parentContext,
        builder: (context) {
          return AlertDialog(
            title: Text('Add note'),
            content: SingleChildScrollView(
              child: AddNoteDialogForm(
                  categories: categories, initialNote: initialNote),
            ),
          );
        });
    if (result != null) {
      _loadData();
    }
  }

  void _displayAddCategoryDialog(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add category'),
            content: SingleChildScrollView(
              child: AddCategoryDialogForm(),
            ),
          );
        });
    if (result != null) {
      _loadData();
    }
  }

  void _deleteAllNotes() async {
    await _databaseProvider.deleteAllNotes();
    _loadData();
  }

  void _onMenuItemClick(String itemId) {
    print('sortby: $itemId');
    SortOrder sortType;
    if (itemId == 'delete_all_notes') {
      _deleteAllNotes();
    } else if (itemId == SortOrder.DEFAULT.toString()) {
      sortType = SortOrder.DEFAULT;
    } else if (itemId == SortOrder.CATEGORY.toString()) {
      sortType = SortOrder.CATEGORY;
    } else if (itemId == SortOrder.DATE.toString()) {
      sortType = SortOrder.DATE;
    } else if (itemId == SortOrder.TEXT.toString()) {
      sortType = SortOrder.TEXT;
    }
    if (sortType != null) {
      setState(() {
        this.sortOrder = sortType;
      });
    }
  }

  Widget _buildMenu() {
    return Menu(onMenuItemClick: _onMenuItemClick);
  }

  Widget _getListView() {
    if (this.data != null && this.data.isNotEmpty) {
      switch (sortOrder) {
        case SortOrder.DEFAULT:
          return AllNotesList(data: data);
        case SortOrder.CATEGORY:
          Map<Category, List<Note>> notesByCategories = Map();
          this.data.forEach((noteWithCategory) {
            final note = noteWithCategory.first;
            final category = noteWithCategory.second;
            final notesByCategory =
                notesByCategories.putIfAbsent(category, () => List<Note>());
            notesByCategory.add(note);
          });
          return NotesByCategories(data: notesByCategories);
        case SortOrder.DATE:
          return AllNotesList(data: data, sortOrder: SortOrder.DATE);
        case SortOrder.TEXT:
          return AllNotesList(data: data, sortOrder: SortOrder.TEXT);
        default:
          return AllNotesList(data: data);
      }
    } else {
      return Text('Nothing here. Yet.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [_buildMenu()],
      ),
      body: _getListView(),
      floatingActionButton: FancyFab(
        onPressed: (id) {
          if (id == 'add_note') {
            _displayAddNoteDialog(context);
          } else if (id == 'add_category') {
            _displayAddCategoryDialog(context);
          }
        },
      ),
    );
  }
}
