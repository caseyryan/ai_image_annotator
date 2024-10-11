import 'package:ai_image_annotator/constants.dart';
import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/lite_state/long_living_controllers/coco_image_annotator_controller.dart';
import 'package:ai_image_annotator/lite_state/single_use_controllers/image_container_controller.dart';
import 'package:ai_image_annotator/models/coco_model/coco_category.dart';
import 'package:ai_image_annotator/theme_extensions/custom_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lite_forms/lite_forms.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({
    super.key,
    required this.controller,
  });

  final ImageContainerController controller;

  Widget _categoryIconBuilder(
    context,
    LiteDropSelectorItem item,
    isSelected,
  ) {
    final ButtonType additionType = item.payload as ButtonType;
    return SizedBox(
      width: kButtonHeight,
      height: kButtonHeight,
      child: SvgPicture.asset(
        '${additionType.name}.svg'.toSvgAssetPath(),
        // color: additionType.color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.0 - controller.rightOffset.dy,
      right: 20.0 - controller.rightOffset.dx,
      child: LiteForm(
          name: 'controlForm',
          builder: (c, s) {
            return Material(
              color: CustomColorTheme.of(context).actionSheetColor.withOpacity(.93),
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 14.0,
                  cornerSmoothing: 1.0,
                ),
              ),
              child: Row(
                children: [
                  LiteDropSelector(
                    selectorViewBuilder: (context, selectedItems, error) {
                      return const ControlPanelButton(
                        svgFileName: 'add-button.svg',
                      );
                    },
                    settings: const DropSelectorSettings(
                      dropSelectorType: DropSelectorType.menu,
                      dropSelectorActionType: DropSelectorActionType.simpleWithNoSelection,
                      maxMenuWidth: double.infinity,
                    ),
                    name: 'addNew',
                    onChanged: (value) {
                      controller.onAddNew(
                        (value as LiteDropSelectorItem).payload,
                      );
                    },
                    items: [
                      LiteDropSelectorItem(
                        title: 'Add New Category'.translate(),
                        payload: ButtonType.category,
                        iconBuilder: _categoryIconBuilder,
                      ),
                      LiteDropSelectorItem(
                        title: 'Add New Shape'.translate(),
                        payload: ButtonType.shape,
                        iconBuilder: _categoryIconBuilder,
                      ),
                      LiteDropSelectorItem(
                        title: 'Add New Object'.translate(),
                        payload: ButtonType.object,
                        iconBuilder: _categoryIconBuilder,
                      ),
                    ],
                  ),
                  LiteDropSelector(
                    selectorViewBuilder: (context, selectedItems, error) {
                      return ControlPanelButton(
                        svgFileName: '${controller.workMode.name}.svg',
                      );
                    },
                    initialValue: controller.workMode,
                    settings: const DropSelectorSettings(
                      dropSelectorType: DropSelectorType.menu,
                      dropSelectorActionType: DropSelectorActionType.simple,
                      maxMenuWidth: double.infinity,
                    ),
                    name: 'settings',
                    onChanged: (value) {
                      controller.updateWorkMode(
                        (value as LiteDropSelectorItem).payload,
                      );
                    },
                    items: [
                      LiteDropSelectorItem(
                        title: 'Draw Shape Mode'.translate(),
                        payload: ButtonType.draw,
                        iconBuilder: _categoryIconBuilder,
                      ),
                      LiteDropSelectorItem(
                        title: 'Drag Point Mode'.translate(),
                        payload: ButtonType.drag,
                        iconBuilder: _categoryIconBuilder,
                      ),
                    ],
                  ),
                  LiteDropSelector(
                    selectorViewBuilder: (context, selectedItems, error) {
                      return ControlPanelButton(
                        svgFileName: '${ButtonType.category.name}.svg',
                      );
                    },
                    settings: DropSelectorSettings(
                      dropSelectorType: DropSelectorType.menu,
                      dropSelectorActionType: DropSelectorActionType.simple,
                      maxMenuWidth: double.infinity,
                      searchSettings: MenuSearchConfiguration(
                        searchFieldDecoration: InputDecoration(
                          hintText: 'Enter category name'.translate(),
                        ),
                      ),
                    ),
                    name: 'selectCategory',
                    onChanged: (value) {},
                    items: cocoImageAnnotatorController.categories.map(
                      (c) {
                        return LiteDropSelectorItem<CocoCategory>(
                          title: c.name.firstToUpperCase(),
                          payload: c,
                        );
                      },
                    ).toList(),
                  ),
                  _MoveButton(
                    controller: controller,
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class _MoveButton extends StatelessWidget {
  const _MoveButton({
    required this.controller,
  });

  final ImageContainerController controller;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        controller.updatePanelPosition(event.delta);
      },
      child: Container(
        color: Colors.transparent,
        child: IgnorePointer(
          child: Padding(
            padding: const EdgeInsets.only(right: kPadding, left: kPadding),
            child: SvgPicture.asset(
              'move.svg'.toSvgAssetPath(),
              height: kButtonHeight,
              width: kButtonHeight,
              color: CustomColorTheme.of(context).circleButtonIconColor,
            ),
          ),
        ),
      ),
    );
  }
}

class ControlPanelButton extends StatelessWidget {
  const ControlPanelButton({
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
      ),
    );
  }
}
