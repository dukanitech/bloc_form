import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_form_plus/src/fields/simple_field_bloc_builder.dart';
import 'package:flutter_bloc_form_plus/src/groups/widgets/group_view.dart';
import 'package:flutter_bloc_form_plus/src/groups/widgets/item_group_tile.dart';
import 'package:flutter_bloc_form_plus/src/theme/field_theme_resolver.dart';
import 'package:flutter_bloc_form_plus/src/theme/bloc_form_theme.dart';
import 'package:flutter_bloc_form_plus/src/utils/utils.dart';
import 'package:bloc_form_plus/bloc_form.dart';

/// A material design checkboxes.
class CheckboxGroupFieldBlocBuilder<Value> extends StatelessWidget {
  const CheckboxGroupFieldBlocBuilder({
    super.key,
    required this.multiSelectFieldBloc,
    required this.itemBuilder,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.decoration = const InputDecoration(),
    this.nextFocusNode,
    this.animateWhenCanShow = true,
    this.textStyle,
    this.textColor,
    this.mouseCursor,
    this.fillColor,
    this.checkColor,
    this.overlayColor,
    this.splashRadius,
    this.shape,
    this.side,
    this.groupStyle = const FlexGroupStyle(),
    this.canTapItemTile,
  });

  /// {@macro flutter_bloc_form_plus.FieldBlocBuilder.fieldBloc}
  final MultiSelectFieldBloc<Value, dynamic> multiSelectFieldBloc;

  /// {@macro flutter_bloc_form_plus.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@macro flutter_bloc_form_plus.FieldBlocBuilder.itemBuilder}
  final FieldItemBuilder<Value> itemBuilder;

  /// {@macro flutter_bloc_form_plus.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_bloc_form_plus.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_bloc_form_plus.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro flutter_bloc_form_plus.FieldBlocBuilder.nextFocusNode}
  final FocusNode? nextFocusNode;

  /// {@macro flutter_bloc_form_plus.FieldBlocBuilder.decoration}
  final InputDecoration decoration;

  /// {@macro  flutter_bloc_form_plus.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  /// {@macro flutter_bloc_form_plus.FieldBlocBuilder.textStyle}
  final TextStyle? textStyle;

  /// {@macro flutter_bloc_form_plus.FieldBlocBuilder.textColor}
  final WidgetStateProperty<Color?>? textColor;

  /// {@macro flutter_bloc_form_plus.FieldBlocBuilder.groupStyle}
  final GroupStyle groupStyle;

  /// Identifies whether the item tile is touchable
  /// to change the status of the item
  /// Defaults `false`
  final bool? canTapItemTile;

  // ========== [Checkbox] ==========

  /// [Checkbox.mouseCursor]
  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  /// [Checkbox.fillColor]
  final WidgetStateProperty<Color?>? fillColor;

  /// [Checkbox.checkColor]
  final WidgetStateProperty<Color?>? checkColor;

  /// [Checkbox.overlayColor]
  final WidgetStateProperty<Color?>? overlayColor;

  /// [Checkbox.splashRadius]
  final double? splashRadius;

  /// [Checkbox.shape]
  final OutlinedBorder? shape;

  /// [Checkbox.side]
  final BorderSide? side;

  CheckboxFieldTheme themeStyleOf(BuildContext context) {
    final theme = Theme.of(context);
    final formTheme = FormTheme.of(context);
    final fieldTheme = formTheme.checkboxTheme;
    final resolver = FieldThemeResolver(theme, formTheme, fieldTheme);
    final checkboxTheme = fieldTheme.checkboxTheme ?? theme.checkboxTheme;

    return CheckboxFieldTheme(
      decorationTheme: resolver.decorationTheme,
      textStyle: textStyle ?? resolver.textStyle,
      textColor: textColor ?? resolver.textColor,
      checkboxTheme: checkboxTheme.copyWith(
        mouseCursor: mouseCursor,
        fillColor: fillColor,
        checkColor: checkColor,
        overlayColor: overlayColor,
        splashRadius: splashRadius,
        shape: shape,
        side: side,
      ),
      canTapItemTile: canTapItemTile ?? fieldTheme.canTapItemTile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = themeStyleOf(context);

    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: fieldTheme.checkboxTheme,
      ),
      child: SimpleFieldBlocBuilder(
        singleFieldBloc: multiSelectFieldBloc,
        animateWhenCanShow: animateWhenCanShow,
        builder: (_, __) {
          return BlocBuilder<MultiSelectFieldBloc<Value, dynamic>,
              MultiSelectFieldBlocState<Value, dynamic>>(
            bloc: multiSelectFieldBloc,
            builder: (context, state) {
              final isEnabled = fieldBlocIsEnabled(
                isEnabled: this.isEnabled,
                enableOnlyWhenFormBlocCanSubmit:
                    enableOnlyWhenFormBlocCanSubmit,
                fieldBlocState: state,
              );

              return DefaultFieldBlocBuilderPadding(
                padding: padding,
                child: GroupInputDecorator(
                  decoration:
                      _buildDecoration(context, state, isEnabled, fieldTheme),
                  child:
                      _buildCheckboxes(context, state, isEnabled, fieldTheme),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCheckboxes(
    BuildContext context,
    MultiSelectFieldBlocState<Value, dynamic> state,
    bool isFieldEnabled,
    CheckboxFieldTheme fieldTheme,
  ) {
    return DefaultTextStyle(
      style: Style.resolveTextStyle(
        isEnabled: isEnabled,
        style: fieldTheme.textStyle!,
        color: fieldTheme.textColor!,
      ),
      child: GroupView(
        style: groupStyle,
        padding: Style.getGroupFieldBlocContentPadding(
          isVisible: true,
          decoration: decoration,
        ),
        count: state.items.length,
        builder: (context, index) {
          final item = state.items[index];
          final fieldItem = itemBuilder(context, item);
          final isEnabled = isFieldEnabled && fieldItem.isEnabled;

          final onChanged = fieldBlocBuilderOnChange<bool?>(
            isEnabled: isEnabled,
            nextFocusNode: nextFocusNode,
            onChanged: (isChecked) {
              if (!isChecked!) {
                multiSelectFieldBloc.deselect(item);
              } else {
                multiSelectFieldBloc.select(item);
              }
              fieldItem.onTap?.call();
            },
          );

          return ItemGroupTile(
            customBorder: Style.getInputBorder(
              decoration: decoration,
              decorationTheme: fieldTheme.decorationTheme!,
            ),
            onTap: fieldTheme.canTapItemTile && onChanged != null
                ? () => onChanged(!state.value.contains(item))
                : null,
            leading: Checkbox(
              value: state.value.contains(item),
              onChanged: onChanged,
            ),
            content: fieldItem,
          );
        },
      ),
    );
  }

  InputDecoration _buildDecoration(
    BuildContext context,
    MultiSelectFieldBlocState<Value, dynamic> state,
    bool isEnabled,
    CheckboxFieldTheme fieldTheme,
  ) {
    var decoration = this.decoration;

    decoration = decoration.copyWith(
      enabled: isEnabled,
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: errorBuilder,
        fieldBlocState: state,
        fieldBloc: multiSelectFieldBloc,
      ),
    );

    return decoration.applyDefaults(fieldTheme.decorationTheme!);
  }
}
