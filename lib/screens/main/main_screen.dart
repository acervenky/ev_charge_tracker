import 'package:flutter/material.dart';
import 'package:ev_charge_tracker/screens/main/widgets/carbon_text.dart';
import 'package:ev_charge_tracker/util/styles.dart';

import 'widgets/consumption_text.dart';
import 'widgets/cost_text.dart';
import 'widgets/carbon_text.dart';
import 'widgets/new_log_button.dart';
import 'widgets/settings_button.dart';
import 'widgets/view_history_button.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SettingsButton(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        "Average Distance",
                        style: Styles.whiteBold.copyWith(fontSize: 14),
                      ),
                      ConsumptionText(),
                    Text(" "),
                    Text(
                      "Average Cost",
                      style: Styles.whiteBold.copyWith(fontSize: 14),
                    ),
                    CostText(),
                      Text(" "),
                      Text(
                        "CO2 Avoided",
                        style: Styles.whiteBold.copyWith(fontSize: 14),
                      ),
                      CarbonText(),],
                  ),
                  Column(
                    children: <Widget>[
                      ViewHistoryButton(),
                      SizedBox(height: 12),
                      NewLogButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
