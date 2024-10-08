import 'package:ai_image_annotator/constants.dart';
import 'package:ai_image_annotator/navigator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:lite_forms/controllers/lite_form_controller.dart';
import 'package:lite_forms/lite_forms.dart';

Future<bool> showNativeConfirm({
  String? title,
  required String content,
  required String cancelText,
  required String confirmText,
}) async {
  final result = await showPlatformDialog(
    context: appContext,
    builder: (context) {
      return BasicDialogAlert(
        title: title != null ? Text(title) : null,
        content: Padding(
          padding: const EdgeInsets.only(
            top: kPadding,
          ),
          child: Text(content),
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: Text(cancelText),
            onPressed: () {
              pop(false);
            },
          ),
          BasicDialogAction(
            title: Text(confirmText),
            onPressed: () {
              pop(true);
            },
          ),
        ],
      );
    },
  );
  return result == true;
}

Future<String?> showNativeInputDialog({
  String? title,
  required String text,
  required String cancelText,
  required String confirmText,
  required NativeInputConfig config,
  bool autoSelectText = true,
  String? initialText,
  String? hintText,
}) async {
  final result = await showPlatformDialog(
    context: appContext,
    builder: (context) {
      return BasicDialogAlert(
        title: title != null ? Text(title) : null,
        content: LiteForm(
          name: 'alert',
          onPostFrame: () {
            if (autoSelectText) {
              form('alert').field('value').selectText();
            }
          },
          builder: (c, scrollController) {
            return Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  Text(text),
                  LiteTextFormField(
                    paddingTop: kPadding,
                    name: 'value',
                    hintText: hintText,
                    autofocus: true,
                    keyboardType: config.textInputType,
                    initialValue: initialText,
                    inputFormatters: config.formatters,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: Text(cancelText),
            onPressed: () {
              pop(null);
            },
          ),
          BasicDialogAction(
            title: Text(confirmText),
            onPressed: () {
              pop(form('alert').field('value').get());
            },
          ),
        ],
      );
    },
  );
  return result?.toString();
}

class NativeInputConfig {
  NativeInputConfig._(
    this.textInputType,
    this.formatters,
    this.validators,
  );

  final TextInputType textInputType;
  final List<TextInputFormatter> formatters;
  final List<LiteValidator> validators;

  factory NativeInputConfig.string({
    List<LiteValidator> validators = const [],
    List<TextInputFormatter> formatters = const [],
    TextInputType textInputType = TextInputType.text,
  }) {
    return NativeInputConfig._(
      textInputType,
      formatters,
      validators,
    );
  }

  factory NativeInputConfig.numberWithOptions({
    bool signed = false,
    bool decimal = false,
    int? maxLength,
  }) {
    final formatters = <TextInputFormatter>[];
    final validators = <LiteValidator>[];
    if (maxLength != null) {
      formatters.add(
        LengthLimitingTextInputFormatter(maxLength),
      );
    }
    if (!decimal && !signed) {
      formatters.add(
        FilteringTextInputFormatter.digitsOnly,
      );
    } else if (signed && decimal) {
      formatters.add(FilteringTextInputFormatter.allow(
        RegExp(r'[0-9-.]'),
      ));
    } else if (signed) {
      formatters.add(FilteringTextInputFormatter.allow(
        RegExp(r'[0-9-]'),
      ));
    } else if (decimal) {
      formatters.add(FilteringTextInputFormatter.allow(
        RegExp(r'[0-9.]'),
      ));
    }
    return NativeInputConfig._(
      TextInputType.numberWithOptions(
        signed: signed,
        decimal: decimal,
      ),
      formatters,
      validators,
    );
  }
}
