import 'package:fluttertoast/fluttertoast.dart';
import 'package:ev_charge_tracker/util/hive_keys.dart';
import 'package:hive/hive.dart';

abstract class TripComputer {
  static double calculateCost() {
    final prefs = Hive.box(PREFS_BOX);

    int minOdo = prefs.get('minOdo') ?? 0;
    int maxOdo = prefs.get('maxOdo') ?? 0;
    int n=prefs.get('num')??0;
    int totalOdo = maxOdo - minOdo;
    double totalcost = prefs.get('curtotalcost') ?? 0.0;

    double avgCharge = totalcost / totalOdo;

    if (avgCharge.isNaN || avgCharge == double.infinity) {
      return 0;
    } else {
      return avgCharge;
    }
  }

  static double calculateCarbon() {
    final prefs = Hive.box(PREFS_BOX);

    int minOdo = prefs.get('minOdo') ?? 0;
    int maxOdo = prefs.get('maxOdo') ?? 0;
    int totalOdo = maxOdo - minOdo;
    double avgCharge = totalOdo*12.47;

    if (avgCharge.isNaN || avgCharge == double.infinity) {
      return 0;
    } else {
      return avgCharge;
    }
  }

  static double calculateConsumption() {
    final Box prefs = Hive.box(PREFS_BOX);
    return _calculateMetricConsumption();
    
  }

  static double _calculateMetricConsumption() {
    final prefs = Hive.box(PREFS_BOX);

    int minOdo = prefs.get('minOdo') ?? 0;
    int maxOdo = prefs.get('maxOdo') ?? 0;
    int unitr = prefs.get('unit') ?? 0;
    int n=prefs.get('num')??0;
    int totalOdo = maxOdo - minOdo;

    double totalCharge = prefs.get('totalCharge') ?? 0.0;

    double avgCharge = totalOdo / (n-1);

    if (avgCharge.isNaN || avgCharge == double.infinity) {
      return 0;
    } else {
      return avgCharge;
    }
  }


  static void recalculateEverything() {
    final prefs = Hive.box(PREFS_BOX);
    final logsBox = Hive.box(LOGS_BOX);

    var logsList = logsBox.values;

    double totalCharge = 0; // totalCharge does NOT include lastCharge
    double lastCharge = 0;

    int minOdo = 0;
    int maxOdo = 0;

    // Goes through every log, calculates total consumption and finds log with smallest and biggest odometer
    logsList.forEach((log) {
      // adds each logs consumption to totalconsumption
      totalCharge = totalCharge + log.amount;

      // checks every logs odometer if its smaller than the smallest or bigger than the biggest
      if (log.odometer < minOdo || minOdo == 0) {
        minOdo = log.odometer;
      } else if (log.odometer > maxOdo) {
        maxOdo = log.odometer;
        lastCharge = log.amount;
      }
    });

    totalCharge = totalCharge - lastCharge;

    prefs.put(MIN_ODO, minOdo);
    prefs.put(MAX_ODO, maxOdo);
    prefs.put(TOTAL_CHARGE, totalCharge);
    prefs.put(LAST_CHARGE, lastCharge);

    print("minOdo: " + minOdo.toString());
    print("maxOdo: " + maxOdo.toString());
    print("totalCharge: " + totalCharge.toString());
  }


