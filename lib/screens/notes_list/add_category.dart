import 'package:flutter/material.dart';
import 'package:notepad/data/database_provider.dart';
import 'package:notepad/models/category.dart';

class AddCategoryDialogForm extends StatefulWidget {
  @override
  _AddCategoryDialogFormState createState() => _AddCategoryDialogFormState();
}

class _AddCategoryDialogFormState extends State<AddCategoryDialogForm> {
  final _categoryInputController = TextEditingController();
  String _error;

  DatabaseProvider dbController = new DatabaseProvider();

  @override
  void initState() {
    dbController.create();
    super.initState();
  }

  void _addCategory(BuildContext context) async {
    if (!dbController.isInitialized()) {
      return;
    }
    final input = _categoryInputController.text;
    if (input == null || input.isEmpty) {
      setState(() {
        this._error = 'Please enter a category';
      });
    } else {
      final alreadyExists = await dbController.getCategoryByName(input) != null;
      if (alreadyExists) {
        setState(() {
          this._error = 'Already exists';
        });
      } else {
        setState(() {
          this._error = null;
        });
        final category = Category.create(input);
        await dbController.insertCategory(category);
        Navigator.pop(context, category);
      }
    }
  }

  Widget _buildForm(BuildContext context) {
    return Column(children: [
      TextField(
          controller: _categoryInputController,
          decoration: InputDecoration(
            errorText: this._error,
          )),
      SizedBox(
        height: 8,
      ),
      FlatButton(
        child: Text('Add'),
        onPressed: () {
          _addCategory(context);
        },
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return _buildForm(context);
  }
}
