import 'package:flutter/material.dart';
import 'package:radio_app/states/radio_bloc.dart';

class RadioProvider extends InheritedWidget {
    final RadioBloc bloc;
    final Widget child;

  const RadioProvider({super.key, 
    required this.bloc,
    required this.child,
  }) : super(child: child);

  static RadioProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RadioProvider>();
  }

  @override
  bool updateShouldNotify(RadioProvider oldWidget) => true;
}