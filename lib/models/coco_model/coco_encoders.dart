

import 'package:ai_image_annotator/extensions/datetime_extensions.dart';

Object? encodeCocoDate(DateTime? date) {
  return date?.toCocoDateFormat();
}
