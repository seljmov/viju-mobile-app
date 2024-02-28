import '../../../../core/constants/constants.dart';

/// Расширение для работы с датой и временем
extension DateTimeExtensions on DateTime {
  /// Форматирование даты и времени в строку
  String toLocalFormattedString() {
    return kDateTimeFormatter.format(DateTime.utc(
      this.year,
      this.month,
      this.day,
      this.hour,
      this.minute,
    ).toLocal());
  }
}
