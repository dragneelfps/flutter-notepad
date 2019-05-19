import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notepad/models/note.dart';

void showSnackbar(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

String formatDate(Note note, DateFormat _df) =>
    _df.format(DateTime.fromMillisecondsSinceEpoch(note.createdAt));

Future<T> showNestedMenu<T>(
    {@required BuildContext context,
    @required GlobalKey<State> popupButtonKey,
    @required List<PopupMenuEntry<T>> items}) async {
  final RenderBox popupButtonObject =
      popupButtonKey.currentContext.findRenderObject();
  final RenderBox overlay = Overlay.of(context).context.findRenderObject();

  final position = RelativeRect.fromRect(
      Rect.fromPoints(
          popupButtonObject.localToGlobal(Offset.zero, ancestor: overlay),
          popupButtonObject.localToGlobal(
              popupButtonObject.size.bottomRight(Offset.zero),
              ancestor: overlay)),
      Offset.zero & overlay.size);

  return showMenu(context: context, items: items, position: position);
}
