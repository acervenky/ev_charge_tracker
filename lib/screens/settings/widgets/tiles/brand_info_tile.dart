import 'package:flutter/material.dart';
import 'package:ev_charge_tracker/screens/shared_widgets/center_icon.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BrandInfoTile extends StatefulWidget {
  @override
  _BrandInfoTileState createState() => _BrandInfoTileState();
}

class _BrandInfoTileState extends State<BrandInfoTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          _launchURL();
        });
      },
      leading: CenterIcon(Icon(MdiIcons.lightningBolt)),
      title: Text("PURE ETrance Neo & EPluto 7G"),
    );
  }

  _launchURL() async {
    const url = 'https://pureev.in/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Can't open url");
      throw 'Could not launch $url';
    }
  }
}

