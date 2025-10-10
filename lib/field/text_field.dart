import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputBorderType {
  outline,
  underline,
  none,
}

class WrapperTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final UndoHistoryController? undoController;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool readOnly;
  final bool? showCursor;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool? ignorePointers;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final bool? cursorOpacityAnimates;
  final Color? cursorColor;
  final Color? cursorErrorColor;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final DragStartBehavior dragStartBehavior;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final GestureTapCallback? onTap;
  final bool onTapAlwaysCalled;
  final TapRegionCallback? onTapOutside;
  final MouseCursor? mouseCursor;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String> autofillHints;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final Clip clipBehavior;
  final String? restorationId;
  final bool stylusHandwritingEnabled;
  final bool enableIMEPersonalizedLearning;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final bool canRequestFocus;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final InputBorderType inputBorderType;

  WrapperTextField.outline({
    super.key,
    this.controller,
    this.focusNode,
    this.undoController,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.ignorePointers,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.cursorErrorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.stylusHandwritingEnabled =
        EditableText.defaultStylusHandwritingEnabled,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.canRequestFocus = true,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.inputBorderType = InputBorderType.outline,
    InputDecoration? decorationOutline,
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
    Widget? prefixWidget,
    Widget? suffixWidget,
    BoxConstraints? prefixWidgetConstraints,
    BoxConstraints? suffixWidgetConstraints,
  }) : decoration = defaultDecoration(
          inputBorderType,
          decorationOutline,
          borderSide: borderSide,
          borderRadius: borderRadius,
          gapPadding: gapPadding,
          prefixWidget: prefixWidget,
          suffixWidget: suffixWidget,
          prefixWidgetConstraints: prefixWidgetConstraints,
          suffixWidgetConstraints: suffixWidgetConstraints,
        );

  WrapperTextField.underline({
    super.key,
    this.controller,
    this.focusNode,
    this.undoController,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.ignorePointers,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.cursorErrorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.stylusHandwritingEnabled =
        EditableText.defaultStylusHandwritingEnabled,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.canRequestFocus = true,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.inputBorderType = InputBorderType.underline,
    InputDecoration? decorationUnderline,
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    Widget? prefixWidget,
    Widget? suffixWidget,
    BoxConstraints? prefixWidgetConstraints,
    BoxConstraints? suffixWidgetConstraints,
  }) : decoration = defaultDecoration(
          inputBorderType,
          decorationUnderline,
          borderSide: borderSide,
          borderRadius: borderRadius,
          prefixWidget: prefixWidget,
          suffixWidget: suffixWidget,
          prefixWidgetConstraints: prefixWidgetConstraints,
          suffixWidgetConstraints: suffixWidgetConstraints,
        );

  WrapperTextField.none({
    super.key,
    this.controller,
    this.focusNode,
    this.undoController,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.ignorePointers,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.cursorErrorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.stylusHandwritingEnabled =
        EditableText.defaultStylusHandwritingEnabled,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.canRequestFocus = true,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.inputBorderType = InputBorderType.none,
    InputDecoration? decorationNone,
    Widget? prefixWidget,
    Widget? suffixWidget,
    BoxConstraints? prefixWidgetConstraints,
    BoxConstraints? suffixWidgetConstraints,
  }) : decoration = defaultDecoration(
          inputBorderType,
          decorationNone,
          prefixWidget: prefixWidget,
          suffixWidget: suffixWidget,
          prefixWidgetConstraints: prefixWidgetConstraints,
          suffixWidgetConstraints: suffixWidgetConstraints,
        );

  static InputDecoration defaultDecoration(
    InputBorderType inputBorderType,
    InputDecoration? decoration, {
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding = 0,
    Widget? prefixWidget,
    Widget? suffixWidget,
    BoxConstraints? prefixWidgetConstraints,
    BoxConstraints? suffixWidgetConstraints,
  }) {
    InputBorder? inputBorder;
    EdgeInsetsGeometry? contentPadding;
    if (inputBorderType == InputBorderType.outline) {
      inputBorder = OutlineInputBorder(
        borderSide: borderSide ?? const BorderSide(),
        borderRadius:
            borderRadius ?? const BorderRadius.all(Radius.circular(4.0)),
        gapPadding: gapPadding ?? 4.0,
      );
    } else if (inputBorderType == InputBorderType.underline) {
      inputBorder = UnderlineInputBorder(
        borderSide: borderSide ?? const BorderSide(),
        borderRadius: borderRadius ??
            const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
      );
    } else if (inputBorderType == InputBorderType.none) {
      inputBorder = InputBorder.none;
      contentPadding = EdgeInsets.zero;
    }
    return InputDecoration(
      icon: decoration?.icon,
      iconColor: decoration?.iconColor,
      label: decoration?.label,
      labelText: decoration?.labelText,
      labelStyle: decoration?.labelStyle,
      floatingLabelStyle: decoration?.floatingLabelStyle,
      helperText: decoration?.helperText,
      helperStyle: decoration?.helperStyle,
      helperMaxLines: decoration?.helperMaxLines,
      hintText: decoration?.hintText,
      hintStyle: decoration?.hintStyle,
      hintTextDirection: decoration?.hintTextDirection,
      hintMaxLines: decoration?.hintMaxLines,
      hintFadeDuration: decoration?.hintFadeDuration,
      error: decoration?.error,
      errorText: decoration?.errorText,
      errorStyle: decoration?.errorStyle,
      errorMaxLines: decoration?.errorMaxLines,
      floatingLabelBehavior: decoration?.floatingLabelBehavior,
      floatingLabelAlignment: decoration?.floatingLabelAlignment,
      isCollapsed: decoration?.isCollapsed ?? false,
      isDense: decoration?.isDense ?? true,
      contentPadding: decoration?.contentPadding ?? contentPadding,
      prefixIcon: decoration?.prefixIcon ?? prefixWidget,
      prefixIconConstraints: decoration?.prefixIconConstraints ??
          prefixWidgetConstraints ??
          const BoxConstraints(minHeight: 0),
      prefix: decoration?.prefix,
      prefixText: decoration?.prefixText,
      prefixStyle: decoration?.prefixStyle,
      prefixIconColor: decoration?.prefixIconColor,
      suffixIcon: decoration?.suffixIcon ?? suffixWidget,
      suffix: decoration?.suffix,
      suffixText: decoration?.suffixText,
      suffixStyle: decoration?.suffixStyle,
      suffixIconColor: decoration?.suffixIconColor,
      suffixIconConstraints: decoration?.suffixIconConstraints ??
          suffixWidgetConstraints ??
          const BoxConstraints(minHeight: 0),
      counter: decoration?.counter,
      counterText: decoration?.counterText,
      counterStyle: decoration?.counterStyle,
      filled: decoration?.filled,
      fillColor: decoration?.fillColor,
      focusColor: decoration?.focusColor,
      hoverColor: decoration?.hoverColor,
      errorBorder: decoration?.errorBorder ?? inputBorder,
      focusedBorder: decoration?.focusedBorder ?? inputBorder,
      focusedErrorBorder: decoration?.focusedErrorBorder ?? inputBorder,
      disabledBorder: decoration?.disabledBorder ?? inputBorder,
      enabledBorder: decoration?.enabledBorder ?? inputBorder,
      border: decoration?.border ?? inputBorder,
      enabled: decoration?.enabled ?? true,
      semanticCounterText: decoration?.semanticCounterText,
      alignLabelWithHint: decoration?.alignLabelWithHint,
      constraints: decoration?.constraints,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      undoController: undoController,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      readOnly: readOnly,
      showCursor: showCursor,
      autofocus: autofocus,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      onAppPrivateCommand: onAppPrivateCommand,
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      onTap: onTap,
      onTapOutside: onTapOutside,
      mouseCursor: mouseCursor,
      buildCounter: buildCounter,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      contextMenuBuilder: contextMenuBuilder,
      stylusHandwritingEnabled: stylusHandwritingEnabled,
      canRequestFocus: canRequestFocus,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
    );
  }

  static Widget _defaultContextMenuBuilder(
      BuildContext context, EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }
}
