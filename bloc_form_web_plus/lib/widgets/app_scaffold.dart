import 'package:flutter/material.dart';
import 'package:bloc_form_web_plus/constants/style.dart';
import 'package:bloc_form_web_plus/widgets/app_drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.showParticlesBackground = false,
    required this.appBar,
    required this.body,
  });

  final bool showParticlesBackground;
  final AppBar appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (showParticlesBackground)
          Container(
            decoration: BoxDecoration(
              gradient: scaffoldBodyGradient,
            ),
          ),
        Row(
          children: [
            if (!displayMobileLayout(context))
              const AppDrawer(permanentlyDisplay: true),
            Expanded(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                drawer: displayMobileLayout(context)
                    ? const AppDrawer(permanentlyDisplay: false)
                    : null,
                appBar: appBar,
                body: body,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
