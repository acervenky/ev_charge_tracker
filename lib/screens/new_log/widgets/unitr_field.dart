import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UnitrField extends StatefulWidget {
  final FocusNode focus;
  final TextEditingController textEditingController;

  UnitrField(this.focus, this.textEditingController);

  @override
  _UnitrFieldState createState() => _UnitrFieldState();
}

class _UnitrFieldState extends State<UnitrField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 28, 16),
      child: TextFormField(
        controller: widget.textEditingController,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(
          icon: Icon(MdiIcons.currencyInr),
          labelText: "Unit Rate",
          suffixText: "Rs/kWh",
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter a valid value';
          }
          return null;
        },
      ),
    );
  }
}
