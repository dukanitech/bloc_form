import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_form_plus/src/features/scroll/scrollable_field_bloc_target.dart';
import 'package:flutter_bloc_form_plus/src/theme/bloc_form_theme.dart';
import 'package:bloc_form_plus/bloc_form.dart';

/// Allows you to make the first wrong child visible
///
/// Place it on every page
class ScrollableFormBlocManager extends StatelessWidget {
  /// The form bloc instance
  final FormBloc formBloc;

  /// See [ScrollPosition.ensureVisible]
  final Duration? duration;

  /// See [ScrollPosition.ensureVisible]
  final double? alignment;

  /// See [ScrollPosition.ensureVisible]
  final Curve? curve;

  /// See [ScrollPosition.ensureVisible]
  final ScrollPositionAlignmentPolicy? alignmentPolicy;

  /// The tree
  final Widget child;

  const ScrollableFormBlocManager({
    Key? key,
    required this.formBloc,
    this.duration,
    this.alignment,
    this.curve,
    this.alignmentPolicy,
    required this.child,
  }) : super(key: key);

  /// Search from the context for the first wrong field and make it visible by scrolling
  void ensureFieldVisible(BuildContext context) {
    final target = ScrollableFieldBlocTarget.findFirstWrong(context);

    if (target == null) return;

    final formTheme = FormTheme.of(context);
    final scrollableConfig = formTheme.scrollableFormTheme;

    Scrollable.ensureVisible(
      target.context,
      duration: duration ?? scrollableConfig.duration,
      alignment: alignment ?? scrollableConfig.alignment,
      curve: curve ?? scrollableConfig.curve,
      alignmentPolicy: alignmentPolicy ?? scrollableConfig.alignmentPolicy,
    );
  }

  void _onFormBlocState(BuildContext context, FormBlocState state) {
    if (state is FormBlocSubmissionFailed) {
      ensureFieldVisible(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FormBloc, FormBlocState>(
      bloc: formBloc,
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: _onFormBlocState,
      child: child,
    );
  }
}
