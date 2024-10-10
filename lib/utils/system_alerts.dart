import 'package:flutter_platform_alert/flutter_platform_alert.dart';

Future showAlert({
  required String header,
  required String text,
}) async {
  await FlutterPlatformAlert.showAlert(
    windowTitle: header,
    text: text,
    options: PlatformAlertOptions(),
  );
}
