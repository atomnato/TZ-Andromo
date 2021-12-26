import 'package:flutter/material.dart';
import 'package:gallery/bloc/provider.dart';
import 'package:gallery/screens/gallery_screen.dart';

import 'bloc/gallery_bloc.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<GalleryBloc>(
      bloc: GalleryBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/' : (_) => const GalleryScreen()
        },
      ),
    );
  }
}


