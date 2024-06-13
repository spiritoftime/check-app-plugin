class HelperFunctions {
  static dynamic tryCatchWrapper(
      {required Future<dynamic> Function() operation,
      required String errorMessage}) async {
    try {
      return await operation();
    } catch (e) {
      throw FormatException('$errorMessage: $e');
    }
  }
}
