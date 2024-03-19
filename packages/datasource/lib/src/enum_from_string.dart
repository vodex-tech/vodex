T getEnumFromString<T extends Enum>(String? key, List<T> values,
    {required T defaultValue}) {
  return values.firstWhere((v) => key == v.toString().split('.').last,
      orElse: () => defaultValue);
}
