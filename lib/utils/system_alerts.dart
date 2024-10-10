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

Future<bool> showConfirmation({
  required String header,
  required String text,
}) async {
  final result = await FlutterPlatformAlert.showAlert(
    windowTitle: header,
    text: text,
    options: PlatformAlertOptions(),
    alertStyle: AlertButtonStyle.okCancel,
  );
  return AlertButton.okButton == result;
}
