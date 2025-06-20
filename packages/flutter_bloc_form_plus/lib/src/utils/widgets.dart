import 'package:flutter/material.dart';
import 'package:flutter_bloc_form_plus/src/theme/bloc_form_theme.dart';
import 'package:flutter_bloc_form_plus/src/theme/material_states.dart';
import 'package:flutter_bloc_form_plus/src/utils/utils.dart';

class DefaultFieldBlocBuilderTextStyle extends StatelessWidget {
  final bool isEnabled;
  final TextStyle? style;
  final Widget child;

  const DefaultFieldBlocBuilderTextStyle({
    super.key,
    required this.isEnabled,
    this.style,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formStyle = FormTheme.of(context);

    return DefaultTextStyle(
      style: Style.resolveTextStyle(
        isEnabled: isEnabled,
        style: style ?? formStyle.textStyle ?? theme.textTheme.titleMedium!,
        color: formStyle.textColor ??
            SimpleMaterialStateProperty(
              normal: theme.textTheme.titleMedium!.color,
              disabled: theme.disabledColor,
            ),
      ),
      child: child,
    );
  }
}

class DefaultFieldBlocBuilderPadding extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const DefaultFieldBlocBuilderPadding({
    super.key,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? FormTheme.of(context).padding ?? FormTheme.defaultPadding,
      child: child,
    );
  }
}

/// Removes the suffix from the decoration, moves the label to the right as
/// if the suffix were present and keeps the error shifted slightly to the right
class GroupInputDecorator extends StatelessWidget {
  final InputDecoration decoration;
  final Widget child;

  const GroupInputDecorator({
    super.key,
    required this.decoration,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Shows the shifted error of common field padding
        InputDecorator(
          decoration: decoration.copyWith(
            // Align the label with the texts of the children
            prefixIcon: const SizedBox.shrink(),
            prefix: const SizedBox.shrink(),
            contentPadding: Style.getGroupFieldBlocContentPadding(
              isVisible: false,
              decoration: decoration,
            ),
          ),
          child: Opacity(
            opacity: 0.0,
            child: child,
          ),
        ),
        InputDecorator(
          decoration: Style.inputDecorationWithoutBorder.copyWith(
            // Removes the prefix and the space it would occupy
            prefixIcon: const SizedBox.shrink(),
            prefix: const SizedBox.shrink(),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0.0,
              minHeight: 0.0,
              maxHeight: 0.0,
              maxWidth: 0.0,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
