import 'package:flutter/material.dart';
import 'package:ev_charge_tracker/screens/shared_widgets/center_icon.dart';
import 'package:ev_charge_tracker/util/hive_keys.dart';
import 'package:ev_charge_tracker/util/trip_computer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TotalDistanceTile extends StatefulWidget {
  @override
  _TotalDistanceTileState createState() => _TotalDistanceTileState();
}

class _TotalDistanceTileState extends State<TotalDistanceTile> {
  final prefsBox = Hive.box(PREFS_BOX);

  double _getTotalCharge() {
    if (prefsBox.get(MAX_ODO) != null) {
      double minOdo = prefsBox.get('minOdo') ?? 0;
      double maxOdo = prefsBox.get('maxOdo') ?? 0;
      double totalOdo = maxOdo - minOdo;
      return totalOdo;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // tap for debug
        print(prefsBox.get(MAX_ODO) - prefsBox.get(MIN_ODO));
      },
      leading: CenterIcon(
        Icon(MdiIcons.evcharge),
      ),
      title: Text("Total Distance"),
      subtitle: ValueListenableBuilder(
        valueListenable: prefsBox.listenable(),
        builder: (BuildContext context, dynamic value, Widget child) {
          return Text(_getTotalCharge().toStringAsFixed(2));
        },
      ),
    );
  }
}
