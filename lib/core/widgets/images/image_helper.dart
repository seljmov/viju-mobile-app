import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart' as http;

import '../../helpers/dio_helper.dart';

/// Помощник работы с изображениями
abstract class ImageHelper {
  /// Сохранить изображение на сервере
  static Future<String> register(File image, String path) async {
    try {
      final compressedFile = await _compressImage(image);
      final formData = FormData.fromMap({
        "image": MultipartFile.fromBytes(
          compressedFile,
          filename: image.path.split("/").last,
          contentType: http.MediaType("image", "jpeg"),
        ),
      });
      final response = await DioHelper.postData(
        url: path,
        data: formData,
      );

      switch (response.statusCode) {
        case 200:
          return response.data['url'];
        default:
          throw Exception('Что-то пошло не так');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Uint8List> _compressImage(File file) async {
    final decodedImage = await decodeImageFromList(file.readAsBytesSync());
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: (decodedImage.width * 0.6).toInt(),
      minHeight: (decodedImage.height * 0.6).toInt(),
      quality: 60,
    );

    return result ?? file.readAsBytesSync();
  }
}
