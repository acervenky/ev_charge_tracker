import 'package:flutter/material.dart';
import 'package:ev_charge_tracker/util/styles.dart';
import 'package:get/get.dart';

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.17,
      color: Colors.green,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
                onPressed: () {
                  Get.back();
                },
              ),
              Text(
                'Charge History',
                style: Styles.whiteBold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
