import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extension/ext_context.dart';
import '../utils/app_size.dart';

/// Common Text filed
class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
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
    this.maxTextLength = 255,
    this.readOnly = false,
    this.keyboardType,
    this.onTap,
    this.subTitle,
    this.isStartTime = true,
    super.key,
    this.textAction,
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
    this.contentHeight,
    this.borderRadius,
    this.style,
    this.contentWidth,
    this.hintStyle,
    this.borderSide,
    this.textAlignVertical,
    this.prefix,
    this.isDense,
    this.prefixIconConstraints,
    this.autofocus,
    this.suffixIconConstraints,
    this.floatingLabelColor,
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
  final Color? floatingLabelColor;
  final Color? titleColor;
  final int? maxTextLength;
  final Color? cursorColor;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textAction;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? inputBorder;
  final int? maxLine;
  final int? minLine;
  final FocusNode? focusNode;
  final double? fontSize;
  final void Function(String?)? onSaved;
  final double? contentHeight;
  final double? contentWidth;
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
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
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
              if (widget.subTitle != null) SizedBox(width: AppSize.w6) else const SizedBox(),
              if (widget.subTitle != null)
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: AppSize.w10),
                    child: Text(
                      widget.subTitle!,
                      style:
                          widget.titleStyle ??
                          context.textTheme.titleMedium!.copyWith(
                            fontSize: AppSize.sp11,
                            fontWeight: FontWeight.w500,
                            color: context.themeTextColors.descriptionColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        if (widget.title != null) SizedBox(height: AppSize.h4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.w6),
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
                maxLength: widget.maxTextLength,
                cursorColor: widget.cursorColor ?? context.themeColors.primary,
                validator: widget.validator,
                textInputAction: widget.textAction,
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
                //   //   widget.maxTextLength ?? 100,
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
                      fontSize: AppSize.sp18,
                    ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: widget.contentWidth ?? AppSize.w12,
                    vertical: widget.contentHeight ?? AppSize.h9,
                  ),
                  errorMaxLines: 3,
                  counterText: '',
                  prefixIconConstraints: widget.prefixIconConstraints,
                  suffixIconConstraints: widget.suffixIconConstraints,
                  isDense: widget.isDense ?? false,
                  border:
                      widget.inputBorder ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? AppSize.r8),
                        borderSide: widget.borderSide ?? BorderSide.none,
                      ),
                  prefixIcon: widget.prefixIcon == null
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(left: AppSize.w14, right: AppSize.w8),
                          child: widget.prefixIcon,
                        ),
                  prefix: widget.prefix == null
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(left: AppSize.w14, right: AppSize.w8),
                          child: widget.prefix,
                        ),
                  suffix: widget.suffix == null
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(left: AppSize.w14, right: AppSize.w8),
                          child: widget.suffix,
                        ),
                  suffixIcon: widget.suffixIcon == null
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(left: AppSize.w14, right: AppSize.w8),
                          child: widget.suffixIcon,
                        ),
                  hintText: widget.hintText,
                  labelText: widget.labelText,
                  floatingLabelStyle: TextStyle(
                    fontSize: widget.fontSize ?? AppSize.sp14,
                    color: widget.floatingLabelColor ?? context.themeTextColors.textColor,
                  ),
                  labelStyle: TextStyle(
                    fontSize: widget.fontSize ?? AppSize.sp14,
                    // color: widget.labelColor ?? context.themeTextColors.hintTextColor,
                  ),
                  hintStyle:
                      widget.hintStyle ??
                      context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        // color: context.themeTextColors.hintTextColor,
                        fontSize: AppSize.sp14,
                      ),
                  errorStyle: TextStyle(color: Colors.red, fontSize: AppSize.sp12),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? AppSize.r8),
                    borderSide: widget.borderSide ?? BorderSide(width: AppSize.w2, color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? AppSize.r8),
                    borderSide: widget.borderSide ?? BorderSide(color: context.themeColors.backgroundColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? AppSize.r8),
                    borderSide: widget.borderSide ?? BorderSide(color: context.themeColors.primary, width: AppSize.w2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? AppSize.r8),
                    borderSide: widget.borderSide ?? BorderSide(width: AppSize.w2, color: Colors.red),
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
