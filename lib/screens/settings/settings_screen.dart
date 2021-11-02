import 'package:flutter/material.dart';
import 'package:ev_charge_tracker/screens/settings/widgets/settings_subtitle.dart';

import 'widgets/tiles/date_format_tile.dart';
import 'widgets/tiles/cust_info_tile.dart';
import 'widgets/tiles/brand_info_tile.dart';
import 'widgets/tiles/recalculate_tile.dart';
import 'widgets/tiles/reset_everything_tile.dart';
import 'widgets/tiles/source_code_tile.dart';
import 'widgets/tiles/theme_tile.dart';
import 'widgets/tiles/total_charge_tile.dart';


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SettingsSubtitle("Stats"),
          TotalChargeTile(),
          Divider(),
          SettingsSubtitle("General settings"),
          ThemeTile(),
          Divider(),
          SettingsSubtitle("About"),
          SourceCodeTile(),
          ResetEverythingTile(),
          Divider(),
          SettingsSubtitle("Designed For"),
          BrandInfoTile(),
          Divider(),
          SettingsSubtitle("Developer"),
          CustInfoTile(),
        ],
      ),
    );
  }
}
