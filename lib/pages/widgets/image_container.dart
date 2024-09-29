import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/lite_state/single_use_controllers/image_container_controller.dart';
import 'package:flutter/material.dart';
import 'package:lite_state/lite_state.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({super.key});

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  final _controller = ImageContainerController();

  @override
  Widget build(BuildContext context) {
    return LiteState<ImageContainerController>(
      controller: _controller,
      builder: (BuildContext c, ImageContainerController controller) {
        return InteractiveViewer(
          transformationController: controller.trackingScrollController,
          constrained: false,
          boundaryMargin: const EdgeInsets.all(
            100.0,
          ),
          minScale: 0.1,
          maxScale: 10.0,
          child: Image.asset(
            'crowd.jpg'.toImageAssetPath(),
          ),
        );
      },
    );
  }
}
