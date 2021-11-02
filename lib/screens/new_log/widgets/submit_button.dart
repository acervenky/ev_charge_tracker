import 'package:flutter/material.dart';
import 'package:ev_charge_tracker/models/log.dart';
import 'package:ev_charge_tracker/screens/history/history_screen.dart';
import 'package:ev_charge_tracker/state/picked_date_state.dart';
import 'package:ev_charge_tracker/util/hive_keys.dart';
import 'package:ev_charge_tracker/util/styles.dart';
import 'package:ev_charge_tracker/util/trip_computer.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class SubmitButton extends StatefulWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController chargeFormController;
  final TextEditingController odometerFormController;
  final TextEditingController unitrFormController;
  final int index;

  SubmitButton(this.formkey, this.chargeFormController, this.odometerFormController,this.unitrFormController, this.index);

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: FloatingActionButton(
            // backgroundColor: Colors.indigo,
            shape: Styles.roundShape,
            onPressed: () {
              onSubmit(context);
            },
            child: Container(
              child: Text('Submit', style: Styles.whiteBold.copyWith(fontSize: 24)),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit(BuildContext context) {
    final PickedDateState pickedDateState = Provider.of<PickedDateState>(context, listen: false);

    if (widget.formkey.currentState.validate()) {
      double chargeAmount = double.tryParse(widget.chargeFormController.text);
      int odometer = int.tryParse(widget.odometerFormController.text);
      double unitr = double.tryParse(widget.unitrFormController.text);


      // check that everything OK
      if (chargeAmount == null) {
        // That snackbar is ugly, but doesn't matter since this shouldn't be triggered in the first place
        Get.snackbar(
          "Error",
          "Invalid charge time",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (odometer == null) {
        Get.snackbar(
          "Error",
          "Invalid odometer reading",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (unitr == null) {
        Get.snackbar(
          "Error",
          "Invalid unit reading",
          snackPosition: SnackPosition.BOTTOM,
        );
      }else {
        // If values are OK save log object and update prefs
        final Log log = Log(
          pickedDateState.dt, // gets picked dt (default dt.now) from provider
          chargeAmount,
          odometer,
          unitr,
        );
        saveLog(log);

        // if editing log just recalculate prefs all over again to avoid something going wrong
        if (widget.index == null) {
          updatePrefs(odometer, chargeAmount, unitr);
          Get.back(); // goes normally back

        } else {
          TripComputer.recalculateEverything(); // ! FIGURE BETTER WAY HERE

          Get.back();
        }
      }
    }
  }

  void saveLog(Log log) {
    final logBox = Hive.box(LOGS_BOX);
    if (widget.index == null) {
      logBox.add(log);
    } else {
      logBox.putAt(widget.index, log);
    }
  }

  void updatePrefs(int odometer, double chargeAmount,double unitr) {
    // Prefs are used to quick-access some important stuff
    // Checks if the new log is smallest or biggest known log, and if so, saves it to prefs
    final prefs = Hive.box(PREFS_BOX);
    if (odometer < (prefs.get(MIN_ODO) ?? 1000000)) {
      prefs.put(MIN_ODO, odometer);
    } else if (odometer > (prefs.get(MAX_ODO) ?? 0)) {
      prefs.put(MAX_ODO, odometer);
    }

    // saves the amount you tanked as lastcharge, and recalculates currentTotalcharge (which does not include lastcharge)
    double currentTotalcharge = prefs.get(TOTAL_charge) ?? 0;
    double lastcharge = prefs.get(LAST_charge) ?? 0;
    double curtotalcost = prefs.get(CURRTOTAL_COST) ?? 0;
    double lasttotalcost = prefs.get(LASTTOTAL_COST) ?? 0;
    int n= prefs.get(NUM) ?? 0;
    if(chargeAmount>4.5){
      chargeAmount=4.5;
    }
    curtotalcost=curtotalcost + lasttotalcost;
    lasttotalcost=chargeAmount*unitr*0.739;
    n=n+1;
    prefs.put(TOTAL_charge, currentTotalcharge + lastcharge);
    prefs.put(LAST_charge, chargeAmount);
    prefs.put(LASTTOTAL_COST, lasttotalcost);
    prefs.put(CURRTOTAL_COST, curtotalcost);
    prefs.put(NUM, n);
    print('updatePrefs called');
  }
}
