// ignore_for_file: depend_on_referenced_packages

import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:ai_image_annotator/extensions/datetime_extensions.dart';
import 'package:flutter_multi_formatter/utils/enum_utils.dart';


enum KeyChangePolicy {
  remove,
  replace,
}

class KeyChangeValue {
  final String originalKey;
  final String? newKey;
  final KeyChangePolicy keyChangePolicy;

  KeyChangeValue({
    required this.originalKey,
    this.newKey,
    this.keyChangePolicy = KeyChangePolicy.replace,
  });
}

extension MapExtensions on Map<dynamic, dynamic> {
  String? toEncodable(encodable) {
    if (encodable is DateTime) {
      return encodable.toCommonDateFormatWithTime();
    } else if (encodable is File) {
      return encodable.path;
    }
    return null;
  }

  String toBase64() {
    return base64.encode(
      utf8.encode(jsonEncode(this)),
    );
  }

  String toQueryParams() {
    var hashSet = HashSet<String>();
    forEach((key, value) {
      hashSet.add("$key=$value");
    });
    return hashSet.join('&');
  }

  void copyAllFrom(Map other) {
    for (var kv in other.entries) {
      this[kv.key] = kv.value;
    }
  }


  Map filterNullValues() {
    var map = {};
    forEach((key, value) {
      if (value != null) {
        map[key] = value;
      }
    });
    return map;
  }

  String toParamString({
    bool ignoreEmpty = true,
  }) {
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < entries.length; i++) {
      final isFirst = i == 0;
      if (isFirst) {
        buffer.write('?');
      }
      final kv = entries.elementAt(i);
      if (kv.value != null) {
        if (!isFirst) {
          buffer.write('&');
        }
        dynamic value = kv.value;
        if (kv.value is Enum) {
          value = enumToString(kv.value);
        }
        value = value.toString();
        if (ignoreEmpty) {
          if (value.isEmpty) {
            continue;
          }
        }
        buffer.write(kv.key);
        buffer.write('=');
        buffer.write(value);
      }
    }
    return buffer.toString();
  }


  String toFormattedJson({
    bool includeNull = false,
  }) {
    var map = {};
    for (var kv in entries) {
      if (kv.value == null) {
        continue;
      }
      map[kv.key] = kv.value;
    }
    return const JsonEncoder.withIndent("  ").convert(map);
  }
}
