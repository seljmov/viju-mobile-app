import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../theme/theme_colors.dart';
import '../../helpers/my_logger.dart';
import '../../models/multi_image.dart';
import '../thesis_progress_bar.dart';

class ImageSeletorHelper {
  Future<File?> _pickImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      return pickedFile == null ? null : File(pickedFile.path);
    } catch (e) {
      MyLogger.e('ImageSeletor -> _pickImageFromCamera() -> e -> $e');
    }

    return null;
  }

  Future<List<File>?> _pickImagesFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFileList = await picker.pickMultiImage();
      return List.of(pickedFileList.map((e) => File(e.path)));
    } catch (e) {
      MyLogger.e('ImageSeletor -> _pickImagesFromGallery() -> e -> $e');
    }
    return null;
  }

  Future<List<MultiImage>> select(BuildContext context) async {
    final cameraPickerInProgress = ValueNotifier<bool>(false);
    final galleryPickerInProgress = ValueNotifier<bool>(false);
    List<File> myFiles = [];
    await showBarModalBottomSheet(
      enableDrag: true,
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 22,
              right: 22,
              bottom: 8,
            ),
            child: Text(
              "Откуда взять изображение?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AdaptiveTheme.of(context)
                    .theme
                    .textTheme
                    .titleMedium
                    ?.color,
              ),
            ),
          ),
          Column(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: cameraPickerInProgress,
                builder: (context, inProgress, child) {
                  return ListTile(
                    horizontalTitleGap: 0,
                    dense: true,
                    leading: Visibility(
                      visible: inProgress,
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                        child: ThesisProgressBar(),
                      ),
                      replacement: const Icon(
                        Icons.camera_alt,
                        color: kPrimaryColor,
                      ),
                    ),
                    title: Text(
                      "С камеры",
                      style:
                          AdaptiveTheme.of(context).theme.textTheme.titleMedium,
                    ),
                    onTap: () async {
                      cameraPickerInProgress.value = true;
                      await _pickImageFromCamera().then((file) {
                        if (file != null) myFiles.add(file);
                      }).whenComplete(
                        () => cameraPickerInProgress.value = true,
                      );
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: galleryPickerInProgress,
                builder: (context, inProgress, child) {
                  return ListTile(
                    horizontalTitleGap: 0,
                    dense: true,
                    leading: Visibility(
                      visible: inProgress,
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                        child: ThesisProgressBar(),
                      ),
                      replacement: const Icon(
                        Icons.photo_library,
                        color: kPrimaryColor,
                      ),
                    ),
                    title: Text(
                      "Из галереи",
                      style:
                          AdaptiveTheme.of(context).theme.textTheme.titleMedium,
                    ),
                    onTap: () async {
                      galleryPickerInProgress.value = true;
                      await _pickImagesFromGallery().then((files) {
                        if (files != null) {
                          myFiles = List.of(files.map((e) => File(e.path)));
                        }
                      }).whenComplete(
                        () => galleryPickerInProgress.value = false,
                      );
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
    final multiImages = List<MultiImage>.of(
      myFiles.map((e) => MultiImage(file: e)),
    );
    return multiImages;
  }
}
