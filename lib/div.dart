import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';

class ExtraDiv extends StatelessWidget {
  final Widget widget;

  const ExtraDiv({super.key, required this.widget});
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
            child: Responsive(
          children: [
            Div(
                divison: Division(
                  colL: 6,
                  colXL: 4,
                ),
                child: widget)
          ],
        )));
  }
}
