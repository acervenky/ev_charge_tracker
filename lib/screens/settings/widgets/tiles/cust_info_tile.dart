import 'package:flutter/material.dart';
import 'package:ev_charge_tracker/screens/shared_widgets/center_icon.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustInfoTile extends StatefulWidget {
  @override
  _CustInfoTileState createState() => _CustInfoTileState();
}

class _CustInfoTileState extends State<CustInfoTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          _launchURL();
        });
      },
      leading: CenterIcon(Icon(MdiIcons.xml)),
      title: Text("Venkatesh Surve"),
    );
  }

  _launchURL() async {
    const url = 'https://www.linkedin.com/in/venkateshsurve/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Can't open url");
      throw 'Could not launch $url';
    }
  }
}

