import 'package:ai_image_annotator/pages/main_page.dart';
import 'package:flutter/material.dart';

bool isRouteFullScreenDialog(String? routeName) {
  switch (routeName) {

  }
  return false;
}

bool maintainState(String routeName) {
  return false;
}

Widget getPageByRouteName(
  String routeName,
  Object? arguments,
) {
  switch (routeName) {
    case MainPage.routeName:
      return const MainPage();
  }
  return _getDefaultPage();
}

Widget _getDefaultPage() {
  return const MainPage();
}
