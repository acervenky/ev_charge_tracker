import 'package:flutter/material.dart';
import 'package:ev_charge_tracker/screens/shared_widgets/center_icon.dart';
import 'package:ev_charge_tracker/util/hive_keys.dart';
import 'package:ev_charge_tracker/util/trip_computer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TotalChargeTile extends StatefulWidget {
  @override
  _TotalChargeTileState createState() => _TotalChargeTileState();
}

class _TotalChargeTileState extends State<TotalChargeTile> {
  final prefsBox = Hive.box(PREFS_BOX);

  double _getTotalCharge() {
    if (prefsBox.get(TOTAL_CHARGE) != null) {
      return prefsBox.get(TOTAL_CHARGE) + prefsBox.get(LAST_CHARGE);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // tap for debug
        print(prefsBox.get(TOTAL_CHARGE) + prefsBox.get(LAST_CHARGE));
      },
      leading: CenterIcon(
        Icon(MdiIcons.evStation),
      ),
      title: Text("Total Charge Time"),
      subtitle: ValueListenableBuilder(
        valueListenable: prefsBox.listenable(),
        builder: (BuildContext context, dynamic value, Widget child) {
          return Text(_getTotalCharge().toStringAsFixed(2) + TripComputer.getCHARGEUnit());
        },
      ),
    );
  }
}
