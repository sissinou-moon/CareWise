import 'package:flutter/material.dart';

class TransitionFirstType extends PageRouteBuilder {
  final Widget page;

  TransitionFirstType(this.page)
    : super(
        pageBuilder: (context, animation, anotherAnimation) => page,
        transitionDuration: Duration(milliseconds: 1000),
        reverseTransitionDuration: Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, anotherAnimation, child) {
          animation = CurvedAnimation(
              curve: Curves.fastLinearToSlowEaseIn,
              parent: animation,
              reverseCurve: Curves.fastOutSlowIn);
          return Align(
            alignment: Alignment.bottomCenter,
            child: SizeTransition(
              sizeFactor: animation,
              child: page,
              axisAlignment: 0,
            ),
          );
        },
      );
}