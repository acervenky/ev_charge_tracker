import 'package:flutter/material.dart';
import 'package:ev_charge_tracker/models/log.dart';
import 'package:ev_charge_tracker/screens/new_log/new_log_screen.dart';
import 'package:ev_charge_tracker/util/hive_keys.dart';
import 'package:ev_charge_tracker/util/trip_computer.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

class HistoryListView extends StatefulWidget {
  @override
  _HistoryListViewState createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  final Box logBox = Hive.box(LOGS_BOX);
  final Box settings = Hive.box(SETTINGS_BOX);

  String _dateFormat;

  @override
  void initState() {
    super.initState();
    _dateFormat = settings.get(DATE_FORMAT) ?? "dd.MM.yyyy";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.83,
      child: ListView.builder(
        // Wrap with WatchBoxBuilder if needed
        itemCount: logBox.length,
        itemBuilder: (context, index) {
          int reverseIndex = logBox.length - 1 - index;
          final log = logBox.getAt(reverseIndex) as Log;
          return _buildItem(log, reverseIndex);
        },
      ),
    );
  }

  Widget _buildItem(Log log, int hiveIndex) {
    String formattedDate = DateFormat(_dateFormat).format(log.date);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 4,
        child: GestureDetector(
          // Using GestureDetector instead of ListTiles onPress to get onTapDown details (for tap location)
          onTapDown: _storePosition, // This saves where the tap happened to _tapPosition variable
          onLongPress: () {
            _showOptionsMenu(hiveIndex);
          },
          child: ListTile(
            title: Text(log.amount.toString() + " hr"),
            subtitle: Text(log.odometer.toString() + " km")),
            trailing: Text(formattedDate),
          ),
        ),
      ),
    );
  }


  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Future<void> _showOptionsMenu(int hiveIndex) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    int selected = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        // magic code from stackoverflow, positions the PopupMenu on your tap location
        _tapPosition & Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          value: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.edit),
              SizedBox(width: 12),
              Text("Edit"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.delete),
              SizedBox(width: 12),
              Text("Delete"),
            ],
          ),
        ),
      ],
    );
    if (selected == 0) {
      Get.to(
        ThemeConsumer(
          child: NewLogScreen(index: hiveIndex), // passing hiveIndex so we know where to save the updated log
        ),
      ).then((value) {
        setState(() {}); // Setting state when getting back from edit screen
      });
    } else if(selected == 1) {
      Get.dialog(
        ThemeConsumer(
          child: AlertDialog(
            title: Text("Are you sure?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    logBox.deleteAt(hiveIndex);
                    TripComputer.recalculateEverything(); // recalculates prefs all over again if deleting log
                  });
                  Get.back();
                },
                child: Text("Delete"),
              ),
            ],
          ),
        ),
      );
    }
  }
}
