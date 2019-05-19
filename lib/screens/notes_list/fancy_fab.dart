import 'package:flutter/material.dart';

typedef void OnPressed(String id);

class FancyFab extends StatefulWidget {
  final OnPressed onPressed;

  FancyFab({@required this.onPressed});

  @override
  _FancyFabState createState() => _FancyFabState(onPressed: onPressed);
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  final OnPressed onPressed;
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  _FancyFabState({@required this.onPressed});

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: Curves.linear)));
    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 0.75, curve: _curve)));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (isOpened) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    isOpened = !isOpened;
  }

  Widget addNote() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          onPressed('add_note');
          animate();
        },
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget addCategory() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          onPressed('add_category');
          animate();
        },
        tooltip: 'Add category',
        child: Icon(Icons.category),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle options',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Transform(
          transform:
              Matrix4.translationValues(0.0, _translateButton.value * 2.0, 0.0),
          child: addCategory(),
        ),
        Transform(
          transform:
              Matrix4.translationValues(0.0, _translateButton.value * 1.0, 0.0),
          child: addNote(),
        ),
        toggle()
      ],
    );
  }
}
