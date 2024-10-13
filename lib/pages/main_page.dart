import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/lite_state/long_living_controllers/coco_image_annotator_controller.dart';
import 'package:ai_image_annotator/pages/widgets/buttons/big_icon_button.dart';
import 'package:ai_image_annotator/pages/widgets/custom_appbar.dart';
import 'package:ai_image_annotator/pages/widgets/image_container/image_container.dart';
import 'package:ai_image_annotator/utils/segmentation_utils.dart';
import 'package:ai_image_annotator/widgets/description.dart';
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
    final area = segmentationToRLE([
      [
        41.52,
        617.23,
        47.25,
        598.62,
        57.27,
        581.44,
        42.95,
        567.12,
        45.82,
        549.94,
        57.27,
        531.32,
        60.13,
        519.87,
        74.45,
        502.69,
        77.32,
        496.96,
        57.27,
        474.05,
        48.68,
        436.83,
        57.27,
        419.65,
        70.16,
        319.42,
        88.77,
        270.74,
        104.52,
        250.7,
        107.38,
        249.27,
        105.95,
        220.63,
        114.54,
        217.77,
        118.84,
        214.9,
        84.47,
        179.11,
        65.86,
        146.18,
        61.57,
        103.23,
        68.72,
        78.89,
        81.61,
        61.7,
        98.79,
        51.68,
        134.59,
        38.8,
        169.61,
        40.79,
        199.02,
        53.11,
        210.47,
        57.41,
        220.49,
        67.43,
        233.38,
        87.48,
        234.81,
        106.09,
        230.51,
        108.95,
        256.29,
        141.32,
        247.9,
        155.03,
        267.74,
        171.95,
        269.17,
        172.16,
        279.19,
        166.22,
        271.58,
        185.35,
        262.17,
        195.32,
        284.92,
        216.34,
        289.22,
        230.65,
        282.06,
        262.15,
        277.76,
        279.33,
        303.53,
        368.1,
        300.67,
        426.81,
        286.35,
        446.85,
        266.31,
        445.42,
        256.29,
        485.51,
        253.42,
        537.05,
        249.13,
        537.05,
        350.78,
        567.12,
        426.0,
        565.94,
        459.03,
        590.59,
        449.57,
        605.78,
        443.03,
        613.5,
        416.7,
        597.24,
        422.06,
        622.86,
        396.29,
        640.0,
        374.25,
        622.34,
        331.61,
        614.57,
        313.56,
        607.21,
        231.95,
        585.73,
        221.92,
        581.44,
        236.24,
        620.09,
        226.78,
        640.0,
        40.65,
        640.0
      ]
    ], 640, 556);
    // print(area);

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
                if (controller.hasSelectedImage)
                  ImageContainer(
                    key: Key(controller.selectedImage!.id.toString()),
                  )
                else if (controller.hasAnnotationFile)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BigIconButton(
                        isEnabled: !controller.isLoading,
                        onTap: controller.selectImageToEdit,
                        tooltip: 'Select Image To Edit'.translate(),
                        svgIconName: 'edit_image.svg',
                      ),
                      Description(
                        text: 'Select Image To Edit'.translate(),
                      )
                    ],
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
