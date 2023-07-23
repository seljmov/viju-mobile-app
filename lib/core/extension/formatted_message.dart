/// Расширение для получения обработанного текста исключения
extension FormattedMessage on Exception {
  String get getMessage {
    if (this.toString().startsWith("Exception: ")) {
      return this.toString().substring(11);
    } else {
      return this.toString();
    }
  }
}
