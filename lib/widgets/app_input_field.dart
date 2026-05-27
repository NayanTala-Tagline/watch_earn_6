import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extension/ext_context.dart';
import '../utils/app_dimens.dart';

/// Common Text filed
class AppInputField extends StatefulWidget {
  const AppInputField({
    this.title,
    this.titleStyle,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.hintText,
    this.shadow,
    this.labelText,
    this.labelColor,
    this.inputFormatters,
    this.maxChars = 255,
    this.readOnly = false,
    this.keyboardType,
    this.onTap,
    this.subTitle,
    this.isStartTime = true,
    super.key,
    this.actionLabel,
    this.suffix,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.cursorColor,
    this.inputBorder,
    this.minLine = 1,
    this.maxLine = 1,
    this.fillColor,
    this.isFilled = true,
    this.titleColor,
    this.focusNode,
    this.fontSize,
    this.onSaved,
    this.bodyHeight,
    this.borderRadius,
    this.style,
    this.bodyWidth,
    this.hintStyle,
    this.borderSide,
    this.textAlignVertical,
    this.prefix,
    this.isDense,
    this.prefixIconConstraints,
    this.autofocus,
    this.suffixIconConstraints,
    this.activeLabelColor,
    this.autofillHints,
    this.textAlign = TextAlign.start,
    this.textColor,
    this.autovalidateMode,
  });
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? title;
  final TextStyle? titleStyle;
  final void Function(String?)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isStartTime;
  final Widget? suffix;
  final BoxShadow? shadow;
  final String? hintText;
  final String? labelText;
  final Color? labelColor;
  final Color? activeLabelColor;
  final Color? titleColor;
  final int? maxChars;
  final Color? cursorColor;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? actionLabel;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? inputBorder;
  final int? maxLine;
  final int? minLine;
  final FocusNode? focusNode;
  final double? fontSize;
  final void Function(String?)? onSaved;
  final double? bodyHeight;
  final double? bodyWidth;
  final double? borderRadius;
  final Color? fillColor;
  final bool isFilled;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final BorderSide? borderSide;
  final TextAlignVertical? textAlignVertical;
  final Widget? prefix;
  final bool? isDense;
  final BoxConstraints? prefixIconConstraints;
  final String? subTitle;
  final bool? autofocus;
  final BoxConstraints? suffixIconConstraints;
  final Iterable<String>? autofillHints;
  final TextAlign textAlign;
  final Color? textColor;
  final AutovalidateMode? autovalidateMode;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  final FocusNode _internalFocusNode = FocusNode();
  final ValueNotifier<bool> _focusedNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalFocusNode.addListener(() {
        _focusedNotifier.value = _internalFocusNode.hasFocus;
      });
    } else {
      widget.focusNode!.addListener(() {
        _focusedNotifier.value = widget.focusNode!.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _internalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Row(
            children: [
              Text(
                '  ${widget.title}',
                style:
                    widget.titleStyle ??
                    context.textTheme.titleSmall!.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                      color: widget.titleColor,
                    ),
              ),
              if (widget.subTitle != null) SizedBox(width: AppDimens.w6) else const SizedBox(),
              if (widget.subTitle != null)
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: AppDimens.w10),
                    child: Text(
                      widget.subTitle!,
                      style:
                          widget.titleStyle ??
                          context.textTheme.titleMedium!.copyWith(
                            fontSize: AppDimens.sp11,
                            fontWeight: FontWeight.w500,
                            color: context.themeTextColors.descriptionColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        if (widget.title != null) SizedBox(height: AppDimens.h4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w6),
          child: ValueListenableBuilder(
            valueListenable: _focusedNotifier,
            builder: (context, isFocused, child) {
              return TextFormField(
                focusNode: widget.focusNode ?? _internalFocusNode,
                controller: widget.controller,
                keyboardType: widget.keyboardType ?? TextInputType.number,
                // autovalidateMode:
                //     widget.autovalidateMode ??
                //     ((widget.readOnly || widget.onTap != null)
                //         ? AutovalidateMode.onUserInteraction
                //         : (widget.focusNode ?? _internalFocusNode).hasFocus
                //         ? AutovalidateMode.onUserInteraction
                //         : AutovalidateMode.disabled),
                // widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
                maxLength: widget.maxChars,
                cursorColor: widget.cursorColor ?? context.themeColors.primary,
                validator: widget.validator,
                textInputAction: widget.actionLabel,
                onChanged: widget.onChanged,
                readOnly: widget.readOnly,
                obscureText: widget.obscureText,
                onTap: widget.onTap,
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                onSaved: widget.onSaved,
                maxLines: widget.maxLine,
                inputFormatters: widget.inputFormatters,
                // [
                //   // LengthLimitingTextInputFormatter(
                //   //   widget.maxChars ?? 100,
                //   // ),
                //   // FilteringTextInputFormatter.digitsOnly,
                //   TextInputFormatter.withFunction((oldValue, newValue) {
                //     final text = newValue.text;
                //     if (RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
                //       return newValue;
                //     }
                //     return oldValue;
                //   }),
                // ],
                textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.center,
                textAlign: widget.textAlign,
                autofocus: widget.autofocus ?? false,
                autofillHints: widget.autofillHints,
                minLines: widget.minLine,
                style:
                    widget.style ??
                    context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: widget.textColor ?? context.themeTextColors.textColor,
                      fontSize: AppDimens.sp18,
                    ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: widget.bodyWidth ?? AppDimens.w12,
                    vertical: widget.bodyHeight ?? AppDimens.h9,
                  ),
                  errorMaxLines: 3,
                  counterText: '',
                  prefixIconConstraints: widget.prefixIconConstraints,
                  suffixIconConstraints: widget.suffixIconConstraints,
                  isDense: widget.isDense ?? false,
                  border:
                      widget.inputBorder ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? AppDimens.r8),
                        borderSide: widget.borderSide ?? BorderSide.none,
                      ),
                  prefixIcon: widget.prefixIcon == null
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(left: AppDimens.w14, right: AppDimens.w8),
                          child: widget.prefixIcon,
                        ),
                  prefix: widget.prefix == null
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(left: AppDimens.w14, right: AppDimens.w8),
                          child: widget.prefix,
                        ),
                  suffix: widget.suffix == null
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(left: AppDimens.w14, right: AppDimens.w8),
                          child: widget.suffix,
                        ),
                  suffixIcon: widget.suffixIcon == null
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(left: AppDimens.w14, right: AppDimens.w8),
                          child: widget.suffixIcon,
                        ),
                  hintText: widget.hintText,
                  labelText: widget.labelText,
                  floatingLabelStyle: TextStyle(
                    fontSize: widget.fontSize ?? AppDimens.sp14,
                    color: widget.activeLabelColor ?? context.themeTextColors.textColor,
                  ),
                  labelStyle: TextStyle(
                    fontSize: widget.fontSize ?? AppDimens.sp14,
                    // color: widget.labelColor ?? context.themeTextColors.hintTextColor,
                  ),
                  hintStyle:
                      widget.hintStyle ??
                      context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        // color: context.themeTextColors.hintTextColor,
                        fontSize: AppDimens.sp14,
                      ),
                  errorStyle: TextStyle(color: Colors.red, fontSize: AppDimens.sp12),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? AppDimens.r8),
                    borderSide: widget.borderSide ?? BorderSide(width: AppDimens.w2, color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? AppDimens.r8),
                    borderSide: widget.borderSide ?? BorderSide(color: context.themeColors.backgroundColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? AppDimens.r8),
                    borderSide: widget.borderSide ?? BorderSide(color: context.themeColors.primary, width: AppDimens.w2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? AppDimens.r8),
                    borderSide: widget.borderSide ?? BorderSide(width: AppDimens.w2, color: Colors.red),
                  ),
                  filled: widget.isFilled,
                  fillColor: widget.fillColor ?? context.theme.cardColor,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
