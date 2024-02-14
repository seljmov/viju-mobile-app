import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/assets_constants.dart';

/// Просмотр изображения во весь экран
class FileFullScreen extends StatelessWidget {
  const FileFullScreen({
    super.key,
    required this.file,
  });

  final File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.close,
            width: 32,
            height: 32,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1,
        ),
        child: Center(
          child: InteractiveViewer(
            child: Image.file(file),
          ),
        ),
      ),
    );
  }
}
