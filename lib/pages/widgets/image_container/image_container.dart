import 'package:ai_image_annotator/lite_state/long_living_controllers/coco_image_annotator_controller.dart';
import 'package:ai_image_annotator/lite_state/single_use_controllers/image_container_controller.dart';
import 'package:ai_image_annotator/pages/widgets/image_container/control_panel.dart';
import 'package:flutter/material.dart';
import 'package:lite_state/lite_state.dart';

import 'shape_painter.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({
    super.key,
  });
  

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  final _controller = ImageContainerController();

  @override
  Widget build(BuildContext context) {
    return LiteState<ImageContainerController>(
      controller: _controller,
      onReady: (ImageContainerController controller) {},
      builder: (BuildContext c, ImageContainerController controller) {
        return Stack(
          children: [
            Center(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: InteractiveViewer(
                  transformationController: controller.transformationController,
                  constrained: true,
                  alignment: Alignment.topLeft,
                  minScale: 1.0,
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
                      child: Image.file(
                        cocoImageAnnotatorController.selectedImageAsFile!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                MaterialButton(
                  onPressed: controller.clearPoints,
                  child: const Text('Clear'),
                ),
                MaterialButton(
                  onPressed: cocoImageAnnotatorController.findImage,
                  child: const Text('Load image'),
                ),
              ],
            ),
            ControlPanel(
              controller: controller,
            ),
          ],
        );
      },
    );
  }
}
