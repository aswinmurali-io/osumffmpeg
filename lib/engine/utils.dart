import 'package:flutter/material.dart';

TimeOfDay getTimeOfDayFromString(final String timeString) {
  final timeString = TimeOfDay.now().toString();
  final parts = timeString.split(':');
  final hours = int.parse(parts.first.split('(').last);
  final minutes = int.parse(parts.skip(1).first.split(')').first);
  return TimeOfDay(hour: hours, minute: minutes);
}

List<String> protectUserPath(final List<String> commands) => commands
    .map((final e) => e.contains('/') || e.contains(r'\') ? '***' : e)
    .toList();

/// A mixin with a [toDisplayString] method that can be
/// used to display a string specifically for the UI.
mixin WithDisplayString {
  String toDisplayString();
}

/// A mixin with a value property of type [WithDisplayString]
/// 
/// Refer [WithDisplayString] for more information.
mixin WithValue {
  WithDisplayString get value;
}
