import 'package:ai_image_annotator/constants.dart';
import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/lite_state/long_living_controllers/coco_image_annotator_controller.dart';
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

  Widget _buildDropSelector() {
    return LiteDropSelector(
      paddingRight: kPadding,
      paddingLeft: kPadding,
      selectorViewBuilder: (context, selectedItems, error) {
        return IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.add,
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
          cocoImageAnnotatorController.pickImageDirectory();
        } else if (item.payload == 'file.svg') {
          cocoImageAnnotatorController.pickAnnotationJsonFile();
        } else if (item.payload == 'ai.svg') {
          cocoImageAnnotatorController.createNewDataset();
        } else if (item.payload == 'new_image.svg') {
          cocoImageAnnotatorController.addImageToDataset();
        } else if (item.payload == 'edit_image.svg') {
          cocoImageAnnotatorController.selectImageToEdit();
        }
      },
      menuItemBuilder: (index, item, isLast, double menuWidth) {
        String? subtitle;
        if (item.payload == 'folder.svg') {
          if (!cocoImageAnnotatorController.hasImageDirectory) {
            return null;
          } else {
            subtitle = cocoImageAnnotatorController.selectedImageDirectory?.path.getLastSegmentsOfPath(3);
          }
        } else if (item.payload == 'file.svg') {
          if (!cocoImageAnnotatorController.hasAnnotationFile) {
            return null;
          } else {
            subtitle = cocoImageAnnotatorController.selectedAnnotationFile?.path.getLastSegmentsOfPath(3);
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
        if (cocoImageAnnotatorController.isDataSetSelected) ...[
          LiteDropSelectorItem<String>(
            title: 'Add New Image To Dataset'.translate(),
            payload: 'new_image.svg',
            iconBuilder: _categoryIconBuilder,
          ),
          LiteDropSelectorItem<String>(
            title: 'Select Image To Edit'.translate(),
            payload: 'edit_image.svg',
            iconBuilder: _categoryIconBuilder,
          ),
        ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return LiteState<CocoImageAnnotatorController>(
      builder: (BuildContext c, CocoImageAnnotatorController controller) {
        return LiteForm(
          name: 'appbarForm',
          builder: (context, scrollController) {
            return AppBar(
              backgroundColor: Theme.of(context).cardColor,
              title: Text(cocoImageAnnotatorController.pageTitle),
              leading: _buildDropSelector(),
              actions: [],
            );
          },
        );
      },
    );
  }
}
