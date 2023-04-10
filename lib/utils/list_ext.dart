extension Mapping<T extends num> on List<T?> {
  List<T> mapNotNull() {
    final List<T> result = [];
    for (final value in this) {
      if (value != null) {
        result.add(value);
      }
    }
    return result;
  }
}
