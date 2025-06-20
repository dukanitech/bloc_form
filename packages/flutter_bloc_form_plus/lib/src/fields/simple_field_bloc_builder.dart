import 'package:flutter/material.dart';
import 'package:flutter_bloc_form_plus/src/features/appear/can_show_field_bloc_builder.dart';
import 'package:flutter_bloc_form_plus/src/features/scroll/scrollable_field_bloc_target.dart';
import 'package:bloc_form_plus/bloc_form.dart';

/// Use these widgets:
/// - [CanShowFieldBlocBuilder]
/// - [ScrollableFieldBlocTarget]
class SimpleFieldBlocBuilder extends StatelessWidget {
  final SingleFieldBloc singleFieldBloc;
  final bool animateWhenCanShow;
  final bool focusOnValidationFailed;
  final Widget Function(BuildContext context, bool canShow) builder;

  const SimpleFieldBlocBuilder({
    super.key,
    required this.singleFieldBloc,
    this.animateWhenCanShow = true,
    this.focusOnValidationFailed = true,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return CanShowFieldBlocBuilder(
      fieldBloc: singleFieldBloc,
      animate: animateWhenCanShow,
      builder: (context, canShow) {
        final field = builder(context, canShow);

        if (!canShow) {
          return field;
        }

        return ScrollableFieldBlocTarget(
          singleFieldBloc: singleFieldBloc,
          canScroll: focusOnValidationFailed,
          child: field,
        );
      },
    );
  }
}
