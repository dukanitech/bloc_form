import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_form_plus/bloc_form.dart';

/// Mark the widget as a possible scroll target
class ScrollableFieldBlocTarget extends StatefulWidget {
  final SingleFieldBloc singleFieldBloc;

  /// Enable auto scroll when the field has an error
  final bool canScroll;

  /// Force scroll to this target
  final bool mustScroll;

  final Widget child;

  const ScrollableFieldBlocTarget({
    super.key,
    required this.singleFieldBloc,
    this.canScroll = true,
    this.mustScroll = false,
    required this.child,
  });

  static ScrollableFieldBlocTargetState? findFirstWrong(BuildContext context) {
    ScrollableFieldBlocTargetState? scrollableState;

    void visit(Element element) {
      if (element is StatefulElement) {
        final state = element.state;
        if (state is ScrollableFieldBlocTargetState && state.canTarget) {
          scrollableState = state;
        }
      }
      if (scrollableState == null) {
        element.visitChildElements(visit);
      }
    }

    context.visitChildElements(visit);

    return scrollableState;
  }

  @override
  State<ScrollableFieldBlocTarget> createState() =>
      ScrollableFieldBlocTargetState();
}

class ScrollableFieldBlocTargetState extends State<ScrollableFieldBlocTarget> {
  bool _hasError = false;

  bool get hasError => _hasError;

  bool get canTarget => (hasError && widget.canScroll) || widget.mustScroll;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SingleFieldBloc, FieldBlocState>(
      bloc: widget.singleFieldBloc,
      listenWhen: (prev, curr) => prev.hasError != curr.hasError,
      listener: (context, state) {
        _hasError = state.hasError;
      },
      child: widget.child,
    );
  }
}
