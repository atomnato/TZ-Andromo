import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery/bloc/gallery_bloc.dart';
import 'package:gallery/bloc/provider.dart';

import 'image_details.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late final ScrollController _scrollController = ScrollController();
  late final GalleryBloc bloc;
  List<String> images = [];

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      bloc.galleryEvent();
    }
  }

  _navigateTo(String url, String heroTag) {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (_, a1, a2) =>
                ImageDetails(urlImage: url, heroTag: heroTag)));
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);

    bloc = Provider.of<GalleryBloc>(context);
    bloc.galleryEvent();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            StreamBuilder<List<String>>(
              stream: bloc.imageStream,
              initialData: images,
              builder: (context, snapshot) {
                List<String>? data = snapshot.data;
                images += data ?? [];

                return _buildGallery(images);
              },
            ),
            StreamBuilder<ValidModel>(
                stream: bloc.galleryStream,
                builder: (context, snapshot) {
                  ValidModel? model = snapshot.data;

                  if (model?.end ?? false) {
                    _scrollController.removeListener(() {});
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      alignment: Alignment.center,
                      child: const Text('end of story :('),
                    );
                  }

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: const SizedBox(
                        child: Center(child: CircularProgressIndicator())),
                  );
                })
          ],
        ),
      )),
    );
  }

  GridView _buildGallery(List<String> data) {
    const count = 20;

    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: data.isEmpty ? count : data.length,
        itemBuilder: (BuildContext context, int index) {
          if (data.isEmpty) {
            return Container(color: Colors.black12);
          }

          return CachedNetworkImage(
            imageUrl: data[index],
            imageBuilder: (context, imageProvider) {
              return GestureDetector(
                onTap: () => _navigateTo(data[index], 'image $index'),
                child: Hero(
                  tag: 'image $index',
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
            placeholder: (context, url) => Container(
              color: Colors.black12,
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.black12,
              child: Image.asset('assets/images/icons8-no-image-24.png'),
            ),
          );
        });
  }
}
