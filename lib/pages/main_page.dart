import 'package:ai_image_annotator/lite_state/long_living_controllers/image_annotator_controller.dart';
import 'package:ai_image_annotator/pages/widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:lite_state/lite_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return LiteState<ImageAnnotatorController>(
      builder: (BuildContext c, ImageAnnotatorController controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).cardColor,
            title: const Text('AI Image Annotator'),
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu_rounded,
              ),
            ),
          ),
          body: const Center(
            child: Stack(
              children: [
                ImageContainer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
