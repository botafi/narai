import 'package:flutter/widgets.dart';

mixin ExtendedState<T extends StatefulWidget> on State<T> {
  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () => this.afterBuild());
  }
  afterBuild() {

  }
}