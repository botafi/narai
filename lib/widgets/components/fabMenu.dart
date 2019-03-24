import 'package:flutter/material.dart';

class FabMenu extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;
  final List<Widget> children;

  FabMenu({this.onPressed, this.tooltip, this.icon, this.children});

  @override
  _FabMenuState createState() => _FabMenuState();
}

class _FabMenuState extends State<FabMenu>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateText;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 550))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateText = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.55,
          1.00,
          curve: Curves.linear,
        ),
      )
    );
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        heroTag: "togglefab",
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int childrenNum = this.widget.children.length;
    List<Widget> children = this.widget.children.asMap().entries.map((entry) {
      var child = entry.value as FloatingActionButton;
      var index = entry.key;
      var color =  child.backgroundColor;
      var container = Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromARGB(150, color.red, color.green, color.blue),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(7), bottomLeft: Radius.circular(7), topRight: Radius.circular(27), bottomRight: Radius.circular(27)),
          boxShadow: <BoxShadow> [ BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 5) ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Opacity(
              opacity: _animateText.value,
              child: Container(
                padding: EdgeInsets.all(14),
                child: Text(child.tooltip, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15))
              ),
            ),
            child
          ]
        )
      );
      return
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * (childrenNum - index),
            0.0,
          ),
          child: Opacity(child: container, opacity: _animateIcon.value),
        ) as Widget;
    }).toList();
    children.add(toggle());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: children
    );
  }
}