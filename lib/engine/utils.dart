import 'package:flutter/material.dart';

TimeOfDay getTimeOfDayFromString(final String timeString) {
  final timeString = TimeOfDay.now().toString();
  final parts = timeString.split(':');
  final hours = int.parse(parts.first.split('(').last);
  final minutes = int.parse(parts.skip(1).first.split(')').first);
  return TimeOfDay(hour: hours, minute: minutes);
}
