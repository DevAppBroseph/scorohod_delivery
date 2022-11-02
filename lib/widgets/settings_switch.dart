import 'package:delivery/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsSwitch extends StatelessWidget {
  const SettingsSwitch({
    Key? key,
    required this.icon,
    required this.text,
    required this.switchValue,
    required this.onChanged,
  }) : super(key: key);

  final IconData? icon;
  final String text;
  final bool switchValue;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        decoration: BoxDecoration(boxShadow: shadow),
        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Material(
          color: Theme.of(context).cardColor,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            child: ListTile(
              leading: icon != null ? Icon(icon) : null,
              trailing: CupertinoSwitch(
                value: switchValue,
                onChanged: (value) {
                  onChanged(value);
                },
              ),
              title: Text(
                text,
              ),
            ),
          ),
        ));
  }
}
