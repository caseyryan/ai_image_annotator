import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/lite_state/single_use_controllers/image_container_controller.dart';
import 'package:ai_image_annotator/pages/widgets/image_container/mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:lite_state/lite_state.dart';

import 'shape_painter.dart';

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
        return Stack(
          children: [
            InteractiveViewer(
              transformationController: controller.transformationController,
              constrained: false,
              boundaryMargin: EdgeInsets.all(
                controller.margin,
              ),
              minScale: 0.1,
              maxScale: 10.0,
              child: Listener(
                onPointerDown: controller.onPointerDown,
                onPointerCancel: controller.onPointerCancel,
                onPointerUp: controller.onPointerUp,
                child: CustomPaint(
                  foregroundPainter: ShapePainter(
                    pointVectors: controller.pointVectors,
                    shapeColor: controller.shapeColor,
                  ),
                  child: Image.asset(
                    'street.jpg'.toImageAssetPath(),
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: controller.clearPoints,
              child: const Text('Clear'),
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: ModeSelector(
                controller: controller,
              ),
            ),
          ],
        );
      },
    );
  }
}
