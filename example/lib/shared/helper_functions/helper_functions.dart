class HelperFunctions {
  static void tryCatchWrapper(
      {required Future<void> Function() operation,
      required String errorMessage}) async {
    try {
      await operation();
    } catch (e) {
      throw FormatException('$errorMessage: $e');
    }
  }
}
