import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class chargeAmountField extends StatefulWidget {
  final FocusNode focus;
  final TextEditingController textEditingController;

  chargeAmountField(this.focus, this.textEditingController);

  @override
  _chargeAmountFieldState createState() => _chargeAmountFieldState();
}

class _chargeAmountFieldState extends State<chargeAmountField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 28, 16),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: widget.textEditingController,
        inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ |\\,]'))], // Blocks everything expect numbers and dots
        keyboardType: TextInputType.number,
        onFieldSubmitted: (v) {
          // This makes the focus shift to the next text field when clicking ok from keyboard
          FocusScope.of(context).requestFocus(widget.focus);
        },
        autofocus: true,
        decoration: InputDecoration(
          icon: Icon(MdiIcons.evStation),
          labelText: "Charge Time",
          suffixText: "hrs",
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter valid time';
          }
          return null;
        },
        
      ),
    );
  }
}
