import 'package:flutter/material.dart';
import 'package:bloc_form_web/widgets/widgets.dart';

class ShowAllCodeButton extends StatelessWidget {
  const ShowAllCodeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: GradientElevatedButton(
        onPressed: () => DefaultTabController.of(context).animateTo(2),
        child: const Text(
          'SHOW ALL CODE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
