import 'package:ai_image_annotator/theme_extensions/custom_text_theme.dart';
import 'package:flutter/material.dart';

/// A Caption is simple text
/// Use it where ever you need a 17pt regular text with Label/Primary color
class Caption extends StatelessWidget {
  const Caption({
    required this.text,
    this.textAlign,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.isSliver = false,
    this.style,
    super.key,
  });

  final String text;
  final TextAlign? textAlign;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final bool isSliver;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = CustomTextTheme.of(context);
    final child = Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight,
      ),
      child: Text(
        text,
        style: style ?? theme.captionStyle,
        textAlign: textAlign,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
    if (isSliver) {
      return SliverToBoxAdapter(
        child: child,
      );
    }
    return child;
  }
}
