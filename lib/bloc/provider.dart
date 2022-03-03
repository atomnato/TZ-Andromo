import 'package:flutter/material.dart';

import 'bloc.dart';

class Provider<T extends Bloc> extends StatefulWidget {
  final T bloc;
  final Widget child;

  const Provider({Key? key, required this.bloc, required this.child})
      : super(key: key);

  static T of<T extends Bloc>(BuildContext context) {
    final Provider<T>? provider =
        context.findAncestorWidgetOfExactType<Provider<T>>();
    return provider!.bloc;
  }

  @override
  _ProviderState createState() => _ProviderState();
}

class _ProviderState extends State<Provider> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
