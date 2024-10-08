import 'package:ai_image_annotator/constants.dart';
import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/lite_state/long_living_controllers/image_annotator_controller.dart';
import 'package:ai_image_annotator/theme_extensions/custom_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/lite_forms.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  Widget _categoryIconBuilder(context, LiteDropSelectorItem item, isSelected) {
    if (item.isSeparator) {
      return const SizedBox.shrink();
    }
    const iconScale = .6;
    String? iconName = item.payload as String?;
    return SizedBox(
      width: kButtonHeight * iconScale,
      height: kButtonHeight * iconScale,
      child: SvgPicture.asset(
        iconName?.toSvgAssetPath() ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LiteForm(
        name: 'appbarForm',
        builder: (context, scrollController) {
          return AppBar(
            backgroundColor: Theme.of(context).cardColor,
            title: Text('AI Image Annotator'.translate()),
            actions: [
              LiteDropSelector(
                paddingRight: kPadding,
                selectorViewBuilder: (context, selectedItems, error) {
                  return IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu_rounded,
                    ),
                  );
                },
                settings: const DropSelectorSettings(
                  dropSelectorType: DropSelectorType.menu,
                  dropSelectorActionType: DropSelectorActionType.simpleWithNoSelection,
                  maxMenuWidth: double.infinity,
                ),
                name: 'imageDirectory',
                onChanged: (value) async {
                  if (value == null) {
                    return;
                  }
                  final item = value as LiteDropSelectorItem;
                  if (item.payload == 'folder.svg') {
                  } else if (item.payload == 'file.svg') {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      dialogTitle: 'Select Annotation JSON File'.translate(),
                      allowMultiple: false,
                      allowedExtensions: [
                        'json',
                        'JSON',
                      ],
                    );
                  } else if (item.payload == 'ai.svg') {
                    imageAnnotatorController.createNewDataset();
                  }
                },
                menuItemBuilder: (index, item, isLast, double menuWidth) {
                  String? subtitle;
                  if (item.payload == 'folder.svg') {
                    if (!imageAnnotatorController.hasImageDirectory) {
                      return null;
                    } else {
                      subtitle = imageAnnotatorController.selectedImageDirectory?.path;
                    }
                  } else if (item.payload == 'file.svg') {
                    if (!imageAnnotatorController.hasAnnotationFile) {
                      return null;
                    } else {
                      subtitle = imageAnnotatorController.selectedAnnotationFile?.path;
                    }
                  } else {
                    /// we don't need a special view for a new dataset menu item
                    return null;
                  }
                  return Padding(
                    padding: const EdgeInsets.all(kPadding),
                    child: Row(
                      children: [
                        _categoryIconBuilder(
                          context,
                          item,
                          false,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: kPadding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.title,
                                style: liteFormController.config?.defaultTextStyle,
                              ),
                              if (subtitle?.isNotEmpty == true)
                                SizedBox(
                                  width: menuWidth - 100.0,
                                  child: Text(
                                    subtitle!,
                                    textAlign: TextAlign.start,
                                    style: CustomTextTheme.of(context).captionStyle,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                items: [
                  LiteDropSelectorItem<String>(
                    title: 'Select Image Directory'.translate(),
                    subtitle: 'Selected',
                    payload: 'folder.svg',
                    iconBuilder: _categoryIconBuilder,
                  ),
                  LiteDropSelectorItem<String>(
                    title: 'Select Annotation File'.translate(),
                    payload: 'file.svg',
                    iconBuilder: _categoryIconBuilder,
                  ),
                  LiteDropSelectorItem(
                    payload: null,
                    title: '',
                    isSeparator: true,
                  ),
                  LiteDropSelectorItem<String>(
                    title: 'Create New Dataset'.translate(),
                    payload: 'ai.svg',
                    iconBuilder: _categoryIconBuilder,
                  ),
                ],
              ),
            ],
            // leading: IconButton(
            //   onPressed: () {},
            //   icon: const Icon(
            //     Icons.menu_rounded,
            //   ),
            // ),
          );
        });
  }
}
