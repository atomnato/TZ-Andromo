import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'bloc.dart';

/// Class with business logic of gallery view.
class GalleryBloc extends Bloc {
  final _imageController = StreamController<List<String>>();

  Stream<List<String>> get imageStream => _imageController.stream;

  final _galleryController = StreamController<ValidModel>();

  Stream<ValidModel> get galleryStream => _galleryController.stream;

  List<int> imageCount = [];
  static const maxImage = 100;

  Future<void> galleryEvent() async {
    if (imageCount.length >= maxImage) {
      _galleryController.sink.add(ValidModel(false, true));
    } else {
      _galleryController.sink.add(ValidModel(true, false));
      await _getImages();
      _galleryController.sink.add(ValidModel(false, false));
    }
  }

  /// Get media from service use unsplash API.
  Future<void> _getImages() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.unsplash.com/photos/random?'
              'query=job&'
              'count=24&'
              'client_id=dIDaE4IqfKUv3_6_xsPFC3U5Nf8bcszf3-73hzjhNI4'));
      if (response.statusCode != 200) {
        throw Exception('Закончилось количество запросов на фотографии'
            'сервиса unsplash.com для того чтобы восстановить необоходим'
            'новый ключ. Подробнее на https://unsplash.com/developers');
      }
      final List<dynamic> decodeResponse = jsonDecode(response.body);
      List<String> listImage =
          decodeResponse.map<String>((e) => e['urls']['small']).toList();

      imageCount += listImage.asMap().entries.map((e) => e.key).toList();

      _imageController.sink.add(listImage);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _imageController.close();
    _galleryController.close();
  }
}

/// Model for track the progress of action.
class ValidModel {
  final bool progress;
  final bool end;

  ValidModel(this.progress, this.end);
}
