import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageDetails extends StatelessWidget {
  final String urlImage;
  final String heroTag;

  const ImageDetails({Key? key, required this.urlImage, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Hero(
          tag: heroTag,
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: CachedNetworkImage(
                  width: double.infinity,
                  imageUrl: urlImage,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Flexible(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    width: double.infinity,
                    height: 48.0,
                    child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share),
                        label: const Text('Share'))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
