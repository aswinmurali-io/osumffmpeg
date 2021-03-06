// Copyright 2022 Aswin Murali & the Osumffmpeg Authors. All rights reserved.
// Use of this source code is governed by a GNU Lesser General Public License
// v2.1 that can be found in the LICENSE file.

import 'package:flutter/material.dart';

TimeOfDay getTimeOfDayFromString(String timeString) {
  final timeString = TimeOfDay.now().toString();
  final parts = timeString.split(':');
  final hours = int.parse(parts.first.split('(').last);
  final minutes = int.parse(parts.skip(1).first.split(')').first);
  return TimeOfDay(hour: hours, minute: minutes);
}

List<String> protectUserPath(List<String> commands) => commands
    .map((e) => e.contains('/') || e.contains(r'\') ? '***' : e)
    .toList();

/// A mixin with a [toDisplayString] method that can be
/// used to display a string specifically for the UI.
mixin WithDisplayString {
  String toDisplayString();
}

/// A mixin with a value property of type [WithDisplayString]
///
/// Refer [WithDisplayString] for more information.
mixin WithDisplayableValue {
  WithDisplayString get value;
}

mixin WithValue<T> {
  T get value;
}
