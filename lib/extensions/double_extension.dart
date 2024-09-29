// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';

extension DoubleExtension on double {
  String toStringAsSmartRound({
    int maxPrecision = 2,
  }) {
    final str = toString();
    try {
      if (str.contains('.')) {
        final split = str.split('');
        final mantissa = <String>[];
        final periodIndex = str.indexOf('.');
        final wholePart = str.substring(0, periodIndex);
        int numChars = 0;
        for (var i = periodIndex + 1; i < str.length; i++) {
          if (numChars >= maxPrecision) {
            break;
          }
          final char = split[i];
          // if (char == '0') {
          //   break;
          // } else {
          mantissa.add(char);
          // }
          numChars++;
        }
        if (mantissa.isNotEmpty) {
          int i = mantissa.length - 1;
          while (mantissa.isNotEmpty) {
            if (mantissa[i] != '0') {
              break;
            }
            i--;
            mantissa.removeLast();
          }
          if (mantissa.isNotEmpty) {
            return '$wholePart.${mantissa.join()}';
          }
        }
        return wholePart;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return str;
  }

  int toSafeInt({
    int? minValue,
    int? maxValue,
  }) {
    if (minValue == null && maxValue == null) {
      return toInt();
    }
    if (minValue != null) {
      if (this < minValue) {
        return minValue;
      }
    }
    if (maxValue != null) {
      if (this > maxValue) {
        return maxValue;
      }
    }
    return toInt();
  }

  double normalizeTo({
    double thisMaxValue = 1.0,
    double thisMinValue = 0.0,
    required double clampBetween,
    bool isReverse = false,
  }) {
    assert(clampBetween > thisMinValue && clampBetween <= thisMaxValue);
    double value = isReverse ? 1.0 - this : this;
    final curValue = value.clamp(thisMinValue, clampBetween);
    if (isReverse) {
      return 1.0 - curValue / clampBetween;
    }
    return curValue / clampBetween;
  }

  double roundToNearest({
    double roundTo = .01,
  }) {
    double value = this;
    value /= roundTo;
    value = value.roundToDouble();
    return value *= roundTo;
  }
}

final _trailingZeroesRegexp = RegExp(r'0+$');

TrailingZeroes getTrailingZeroes(String? value) {
  if (value == null || !value.contains('.')) {
    return TrailingZeroes(
      left: value,
      right: '',
    );
  }
  var match = _trailingZeroesRegexp.firstMatch(value);
  if (match == null || match.end <= match.start) {
    return TrailingZeroes(
      left: value,
      right: '',
    );
  }
  var left = value.substring(0, match.start);
  if (left.endsWith('.')) {
    left = left.replaceAll('.', '');
  }
  return TrailingZeroes(
    left: left,
    right: value.substring(match.start, match.end),
  );
}

class TrailingZeroes {
  final String? left;
  final String? right;

  TrailingZeroes({
    this.left,
    this.right,
  });
}
