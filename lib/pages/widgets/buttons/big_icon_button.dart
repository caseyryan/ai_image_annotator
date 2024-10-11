import 'package:ai_image_annotator/constants.dart';
import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/theme_extensions/custom_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BigIconButton extends StatelessWidget {
  const BigIconButton({
    super.key,
    required this.onTap,
    this.iconData,
    this.svgIconName,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.iconSize = 20.0,
    this.isEnabled = true,
    this.isLoading = false,
    this.buttonSize,
    this.iconColor,
    required this.tooltip,
  }) : assert(
          (iconData != null || svgIconName != null) && (iconData == null || svgIconName == null),
          'You must provide either iconData or svgIconName',
        );

  final IconData? iconData;
  final String? svgIconName;
  final VoidCallback onTap;
  final double iconSize;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final bool isEnabled;
  final bool isLoading;
  final String tooltip;
  final double? buttonSize;
  final Color? iconColor;

  Widget _buildLoader(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }
    return Center(
      child: CircularProgressIndicator(
        color: CustomColorTheme.of(context).circleButtonIconColor,
        strokeWidth: 2.0,
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    if (svgIconName?.isNotEmpty == true) {
      return SvgPicture.asset(
        svgIconName!.toSvgAssetPath(),
      );
    }
    return Icon(
      iconData,
      size: iconSize,
      color: iconColor ?? CustomColorTheme.of(context).circleButtonIconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight,
      ),
      child: Tooltip(
        message: tooltip,
        child: SizedBox(
          width: buttonSize ?? kBigButtonHeight,
          height: buttonSize ?? kBigButtonHeight,
          child: IgnorePointer(
            ignoring: !isEnabled || isLoading,
            child: AnimatedOpacity(
              duration: kThemeAnimationDuration,
              opacity: isEnabled ? 1.0 : .5,
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
                color: CustomColorTheme.of(context).circleButtonBackground,
                child: Stack(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      onTap: onTap,
                      child: IgnorePointer(
                        child: Center(
                          child: _buildIcon(context),
                        ),
                      ),
                    ),
                    _buildLoader(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
