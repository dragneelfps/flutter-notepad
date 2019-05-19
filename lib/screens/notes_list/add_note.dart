import 'package:flutter/material.dart';
import 'package:notepad/data/database_provider.dart';
import 'package:notepad/models/category.dart';
import 'package:notepad/models/note.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class AddNoteDialogForm extends StatefulWidget {
  final List<Category> categories;
  final String initialNote;

  AddNoteDialogForm({@required this.categories, this.initialNote});

  @override
  _AddNoteDialogFormState createState() =>
      _AddNoteDialogFormState(categories: categories, initialNote: initialNote);
}

class _AddNoteDialogFormState extends State<AddNoteDialogForm> {
  final List<Category> categories;
  final String initialNote;

  DatabaseProvider _dbController = new DatabaseProvider();

  TextEditingController _noteDataController;
  String _error;
  Category _selectedCategory;

  SpeechRecognition _speech;
  bool _speechRecognitionAvailable;
  String _currentLocale;
  bool _isListening = false;
  String _transcription;

  _AddNoteDialogFormState({@required this.categories, this.initialNote}) {
    _noteDataController = TextEditingController(text: this.initialNote);
  }

  @override
  void initState() {
    _dbController.create();
    _initSpeechRecognition();
    super.initState();
  }

  void _initSpeechRecognition() {
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler((result) {
      setState(() {
        _speechRecognitionAvailable = result;
      });
    });
    _speech.setCurrentLocaleHandler((locale) {
      setState(() {
        _currentLocale = locale;
      });
    });
    _speech.setRecognitionStartedHandler(() {
      setState(() {
        _isListening = true;
      });
    });
    _speech.setRecognitionResultHandler((text) {
      setState(() {
        _noteDataController.text = text;
      });
    });
    _speech.setRecognitionCompleteHandler(() {
      setState(() {
        _isListening = false;
      });
    });
    _speech.activate().then((res) {
      setState(() {
        _speechRecognitionAvailable = res;
      });
    });
  }

  void _addNote(BuildContext context) async {
    if (!_dbController.isInitialized()) {
      return;
    }
    if (_selectedCategory == null) {
      setState(() {
        this._error = 'Please select a category.';
      });
    } else {
      final noteValue = _noteDataController.text;
      if (noteValue == null || noteValue.trim().isEmpty) {
        setState(() {
          this._error = 'Please enter a note';
        });
      } else {
        Note note = Note.create(noteValue, _selectedCategory.id);
        await _dbController.insertNote(note);
        Navigator.pop(context, note);
      }
    }
  }

  void _startSpeechRecognition() async {
    final permissionStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone);
    if (permissionStatus != PermissionStatus.granted) {
      PermissionHandler().requestPermissions([PermissionGroup.microphone]);
    } else {
      if (_speechRecognitionAvailable && !_isListening) {
        _speech.listen(locale: _currentLocale).then((result) {
          print('result: $result');
        });
      } else if (_speechRecognitionAvailable && _isListening) {
        _speech.cancel();
      }
    }
  }

  Widget _buildForm() {
    return Column(
      children: [
        TextField(
          controller: _noteDataController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
              errorText: _error,
              suffixIcon: IconButton(
                color: _isListening ? Colors.green : Colors.black,
                icon: Icon(Icons.mic),
                onPressed: () {
                  _startSpeechRecognition();
                },
              )),
        ),
        DropdownButton(
          hint: Text('Select category'),
          value: _selectedCategory,
          items: categories.map<DropdownMenuItem>((category) {
            return DropdownMenuItem(
                value: category, child: Text(category.name));
          }).toList(),
          onChanged: (newCategory) {
            setState(() {
              _selectedCategory = (newCategory as Category);
            });
          },
        ),
        FlatButton(
          child: Text('Add'),
          onPressed: () {
            _addNote(context);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildForm();
  }
}
