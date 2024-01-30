import 'dart:io';

/// Модель для отображения изображений
class MultiImage {
  final String? path;
  final File? file;

  const MultiImage({
    this.path,
    this.file,
  }) : assert(path != null || file != null);

  @override
  String toString() {
    return 'MultiImage(path: $path, file: $file)';
  }
}
