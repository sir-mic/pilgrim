import 'package:flutter/material.dart';

/// A calm fade-and-rise page transition, matching the app's quiet feel.
Route<T> fadeRoute<T>(Widget page) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position:
                Tween(begin: const Offset(0, 0.02), end: Offset.zero).animate(curved),
            child: child,
          ),
        );
      },
    );
