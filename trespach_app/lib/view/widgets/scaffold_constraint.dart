import 'package:flutter/material.dart';
import 'package:trespach_app/main.dart';

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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: FractionallySizedBox(
        widthFactor: screenWidth < 1000 ? 1.0 : 800 / screenWidth,
        child: Scaffold(appBar: appBar, body: body, bottomSheet: bottomSheet),
      ),
    );
  }
}
