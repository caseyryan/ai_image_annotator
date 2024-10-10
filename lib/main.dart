import 'package:ai_image_annotator/constants.dart';
import 'package:ai_image_annotator/get_page_by_route_name.dart';
import 'package:ai_image_annotator/lite_state/long_living_controllers/coco_image_annotator_controller.dart';
import 'package:ai_image_annotator/lite_state/long_living_controllers/settings_controller.dart';
import 'package:ai_image_annotator/lite_state/long_living_controllers/theme_controller.dart';
import 'package:ai_image_annotator/theme_extensions/custom_color_theme.dart';
import 'package:ai_image_annotator/theme_extensions/custom_text_theme.dart';
import 'package:ai_image_annotator/widgets/snack_bar_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_bottom_sheet/flutter_cupertino_bottom_sheet.dart';
import 'package:lite_forms/base_form_fields/lite_drop_selector/lite_drop_selector.dart';
import 'package:lite_forms/base_form_fields/lite_text_form_field.dart';
import 'package:lite_forms/utils/controller_initializer.dart';
import 'package:lite_forms/utils/lite_forms_configuration.dart';
import 'package:lite_state/lite_state.dart';

part 'main_parts/_generate_route.dart';
part 'main_parts/_init_controller.dart';
part 'main_parts/_init_lite_forms.dart';
part 'main_parts/_widget_builder.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> get navigatorKey => cupertinoBottomSheetNavigatorKey;
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _initLiteStateControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LiteState<SettingsController>(
      /// [SettingsController] отвечает именно за настройки UI
      builder: (BuildContext c, SettingsController settingsController) {
        return LiteState<ThemeController>(
          builder: (BuildContext c, ThemeController themeController) {
            return CupertinoBottomSheetRepaintBoundary(
              child: MaterialApp(
                navigatorKey: cupertinoBottomSheetNavigatorKey,
                onGenerateRoute: _generateRoute,
                debugShowCheckedModeBanner: false,
                showPerformanceOverlay: false,
                title: 'AI Image Annotator',
                theme: ThemeData(
                  primarySwatch: Colors.deepOrange,
                  primaryColor: Colors.deepOrange,
                  splashFactory: InkRipple.splashFactory,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.deepOrange.withOpacity(.05),
                  scaffoldBackgroundColor: Colors.white,
                  cardColor: Colors.white,
                  canvasColor: Colors.white,
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.white,
                  ),
                  extensions: [
                    CustomColorTheme.light(),
                    CustomTextTheme.light(),
                  ],
                ),
                darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
                  splashFactory: InkRipple.splashFactory,
                  highlightColor: Colors.transparent,
                  primaryColor: const Color.fromARGB(
                    255,
                    171,
                    71,
                    13,
                  ),
                  primaryColorDark: const Color.fromARGB(
                    255,
                    59,
                    59,
                    59,
                  ),
                  appBarTheme: const AppBarTheme(
                    color: Color.fromARGB(
                      255,
                      59,
                      59,
                      59,
                    ),
                  ),
                  cardColor: const Color.fromARGB(
                    255,
                    59,
                    59,
                    59,
                  ),
                  colorScheme: const ColorScheme.dark().copyWith(
                    secondary: const Color.fromARGB(
                      255,
                      138,
                      45,
                      45,
                    ),
                  ),
                  scaffoldBackgroundColor: const Color.fromARGB(
                    255,
                    51,
                    51,
                    51,
                  ),
                  extensions: [
                    CustomColorTheme.dark(),
                    CustomTextTheme.dark(),
                  ],
                ),
                themeMode: themeController.themeMode,
                builder: _build,
              ),
              // ),
            );
          },
        );
      },
    );
  }
}
