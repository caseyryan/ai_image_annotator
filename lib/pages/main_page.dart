import 'package:ai_image_annotator/lite_state/long_living_controllers/coco_image_annotator_controller.dart';
import 'package:ai_image_annotator/pages/widgets/custom_appbar.dart';
import 'package:ai_image_annotator/pages/widgets/image_container/image_container.dart';
import 'package:flutter/material.dart';
import 'package:lite_state/lite_state.dart';

class MainPage extends StatefulWidget {
  static const String routeName = 'MainPage';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return LiteState<CocoImageAnnotatorController>(
      onReady: (controller) {
        controller.tryLoadData();
      },
      builder: (BuildContext c, CocoImageAnnotatorController controller) {
        return Scaffold(
          appBar: const CustomAppbar(),
          body: Center(
            child: Stack(
              children: [
                if (controller.hasSelectedImage) ImageContainer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
