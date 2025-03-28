import 'package:flutter/material.dart';
import 'package:flutter_bloc_form/src/features/appear/can_show_field_bloc_builder.dart';
import 'package:flutter_bloc_form/src/features/scroll/scrollable_field_bloc_target.dart';
import 'package:bloc_form/bloc_form.dart';

/// Use these widgets:
/// - [CanShowFieldBlocBuilder]
/// - [ScrollableFieldBlocTarget]
class SimpleFieldBlocBuilder extends StatelessWidget {
  final SingleFieldBloc singleFieldBloc;
  final bool animateWhenCanShow;
  final bool focusOnValidationFailed;
  final Widget Function(BuildContext context, bool canShow) builder;

  const SimpleFieldBlocBuilder({
    Key? key,
    required this.singleFieldBloc,
    this.animateWhenCanShow = true,
    this.focusOnValidationFailed = true,
    required this.builder,
  }) : super(key: key);

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
