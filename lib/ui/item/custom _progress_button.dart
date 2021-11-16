import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomProgressButton extends StatefulWidget {
  @required
  final Function onTap;
  @required
  final bool isConnect;

  final Function afterTimeEnd;
  final Duration duration;
  final Color boxBackGroundColor;
  final String buttonText;
  CustomProgressButton(
      {this.onTap,
      this.afterTimeEnd,
      this.isConnect = false,
      this.buttonText = "Tap me",
      this.boxBackGroundColor = Colors.orange,
      this.duration = const Duration(seconds: 40)});

  @override
  _CustomProgressButtonState createState() => _CustomProgressButtonState();
}

class _CustomProgressButtonState extends State<CustomProgressButton>
    with TickerProviderStateMixin {
  int _state = 0;
  double _width = 70;
  bool _animationDirection = true; //forward animation

  GlobalKey _globalKey = new GlobalKey();
  Animation _animation;
  AnimationController _controller;

  final EdgeInsetsGeometry scaledPadding = ButtonStyleButton.scaledPadding(
    const EdgeInsets.all(8),
    const EdgeInsets.symmetric(horizontal: 8),
    const EdgeInsets.symmetric(horizontal: 4),
    1,
  );
  @override
  Widget build(BuildContext context) {
    if (widget.isConnect) _state = 2;
    return PhysicalModel(
      color: Colors.orangeAccent,
      borderRadius: BorderRadius.circular(3.0),
      elevation: 5,
      shadowColor: Colors.deepOrange,
      child: Container(
        key: _globalKey,
        decoration: BoxDecoration(),
        height: 36,
        width: _width,
        padding: scaledPadding,
        child: InkWell(
          onTap: () {
            setState(() {
              if (_state == 0) {
                animateButton();
                widget.onTap();
              }
            });
          },
          child: Center(child: setUpButtonChild()),
        ),
      ),
    );
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text(
        widget.buttonText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    } else if (_state == 1) {
      return Container(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;

    setState(() {
      _state = 1;
    });
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          if (_animationDirection) {
            _width = initialWidth - ((initialWidth - 48.0) * _animation.value);
          } else {
            _width =
                initialWidth - ((initialWidth - 48.0) * (1 - _animation.value));
            if (_width == 80) _animationDirection = true;
          }
        });
      });
    _controller.forward();
    Timer(widget.duration, () {
      if (widget.afterTimeEnd != null) widget.afterTimeEnd();
      _animationDirection = false; //backward animation
      _controller.reset();
      _controller.forward();
      setState(() {
        if (!widget.isConnect) _state = 0;
      });
    });
  }
}
