import 'package:flutter/material.dart';
import 'package:ev_charge_tracker/util/styles.dart';

class EditTipText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Opacity(
          opacity: 0.4,
          child: Text(
            "TAP AND HOLD FOR MORE OPTIONS",
            textAlign: TextAlign.center,
            style: Styles.settingsSubtitle,
          ),
        ),
      ),
    );
  }
}
