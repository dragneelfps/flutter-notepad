import 'package:flutter/material.dart';
import 'package:notepad/screens/notes_list/sort_order.dart';
import 'package:notepad/utils/helpers.dart';

typedef void OnMenuItemClick(String menuItemId);

class Menu extends StatefulWidget {
  final OnMenuItemClick onMenuItemClick;

  Menu({@required this.onMenuItemClick});

  @override
  _MenuState createState() => _MenuState(onMenuItemClick: onMenuItemClick);
}

class _MenuState extends State<Menu> {
  final OnMenuItemClick onMenuItemClick;

  final popupButtonKey = GlobalKey<State>();

  _MenuState({@required this.onMenuItemClick});

  static final List<PopupMenuEntry<String>> _mainPage = [
    PopupMenuItem(
      value: 'sort_order',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('Sort by'), Icon(Icons.chevron_right)],
      ),
    ),
    PopupMenuItem(
      value: 'delete_all_notes',
      child: Text('Delete all notes'),
    )
  ].toList();

  static final List<PopupMenuEntry<String>> _sortPage = [
    PopupMenuItem(
      value: SortOrder.CATEGORY.toString(),
      child: Text('Category'),
    ),
    PopupMenuItem(
      value: SortOrder.DATE.toString(),
      child: Text('Time'),
    ),
    PopupMenuItem(
      value: SortOrder.TEXT.toString(),
      child: Text('Alphabet'),
    ),
  ];

  void _showSortPage(BuildContext context) {
    showNestedMenu(
            context: context, popupButtonKey: popupButtonKey, items: _sortPage)
        .then((itemId) => onMenuItemClick(itemId));
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      key: popupButtonKey,
      itemBuilder: (_) => _mainPage,
      onSelected: (itemId) {
        if (itemId == 'delete_all_notes') {
          onMenuItemClick(itemId);
        } else if (itemId == 'sort_order') {
          _showSortPage(context);
        }
      },
    );
  }
}
