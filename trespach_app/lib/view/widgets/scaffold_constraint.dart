import 'package:flutter/material.dart';

class ScaffoldConstraint extends StatelessWidget {
  const ScaffoldConstraint({
    required this.body,
    this.bottomSheet,
    this.appBar,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomSheet;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return FractionallySizedBox(
      widthFactor: screenWidth < 1000 ? 1.0 : 800 / screenWidth,
      child: Scaffold(appBar: appBar, body: body, bottomSheet: bottomSheet),
    );
  }
}
