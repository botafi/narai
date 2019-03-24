import 'package:flutter/material.dart';
import 'package:narai/bloc/bloc.dart';
import 'package:narai/bloc/blocProvider.dart';
import 'package:narai/blocs/applicationBlocProvider.dart';

class ApplicationBlocProviderWidget extends InheritedWidget {
  final ApplicationBlocProvider applicationBlocProvider;

  ApplicationBlocProviderWidget({Key key, @required Widget child, @required this.applicationBlocProvider})
  : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static T of<T extends Bloc>(BuildContext context) {
    return
      (context.inheritFromWidgetOfExactType(ApplicationBlocProviderWidget) as ApplicationBlocProviderWidget)
        .applicationBlocProvider.get<T>();
  }

}