import 'package:flutter/material.dart';

class TransparentRoute<T> extends PageRoute<T> {
  TransparentRoute({required this.builder});

  final WidgetBuilder builder;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.25);

  @override
  bool get opaque => false;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget page = builder(context);
    return FadeTransition(
      opacity: animation,
      child: page,
    );
  }

  @override
  void didComplete(T? result) {
    super.didComplete(result);
  }
}
