import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  static TimeOfDay convertToTimeOfDay(String time) {
    return TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));
  }

  static String convertToHHMM(TimeOfDay timeOfDay) {
    return DateFormat('HH:mm').format(DateFormat('HH:mm', 'en_US')
        .parse('${timeOfDay.hour}:${timeOfDay.minute}'));
  }

  static String currentTime(){
    return DateFormat('HH:mm').format(DateTime.now());
  }
}
