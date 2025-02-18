import 'dart:developer';
import 'package:flutter/material.dart';

getAnimatedLeftToRightRoute(Widget page) {
  try {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(-1.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  } catch (e) {
    log("navigation error $e ");
  }
}

getAnimatedRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (_, a, b, c) => FadeTransition(opacity: a, child: c),
  );
}
