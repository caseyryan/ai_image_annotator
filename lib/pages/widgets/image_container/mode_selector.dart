import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/lite_state/single_use_controllers/image_container_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({
    super.key,
    required this.controller,
  });

  final ImageContainerController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border.all(
          color: Theme.of(context).iconTheme.color!,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: const Row(
        children: [
          ModeSelectorButton(
            svgFileName: 'add-button.svg',
          ),
        ],
      ),
    );
  }
}

class ModeSelectorButton extends StatelessWidget {
  const ModeSelectorButton({
    super.key,
    required this.svgFileName,
  });

  final String svgFileName;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(
        width: 40.0,
        height: 40.0,
        svgFileName.toSvgAssetPath(),
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
