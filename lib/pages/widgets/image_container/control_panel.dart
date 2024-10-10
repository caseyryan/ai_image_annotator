import 'package:ai_image_annotator/constants.dart';
import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/lite_state/single_use_controllers/image_container_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lite_forms/base_form_fields/lite_drop_selector/lite_drop_selector.dart';
import 'package:lite_forms/base_form_fields/lite_form.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({
    super.key,
    required this.controller,
  });

  final ImageContainerController controller;

  Widget _categoryIconBuilder(context, LiteDropSelectorItem item, isSelected) {
    final AdditionType additionType = item.payload as AdditionType;
    const iconScale = .6;
    return SizedBox(
      width: kButtonHeight * iconScale,
      height: kButtonHeight * iconScale,
      child: SvgPicture.asset(
        '${additionType.name}.svg'.toSvgAssetPath(),
        // color: additionType.color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LiteForm(
        name: 'controlForm',
        builder: (c, s) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              border: Border.all(
                color: Theme.of(context).iconTheme.color!,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(100.0),
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
                      payload: AdditionType.category,
                      iconBuilder: _categoryIconBuilder,
                    ),
                    LiteDropSelectorItem(
                      title: 'Add New Shape'.translate(),
                      payload: AdditionType.shape,
                      iconBuilder: _categoryIconBuilder,
                    ),
                    LiteDropSelectorItem(
                      title: 'Add New Object'.translate(),
                      payload: AdditionType.object,
                      iconBuilder: _categoryIconBuilder,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
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
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
