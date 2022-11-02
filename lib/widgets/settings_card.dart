import 'package:delivery/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final IconData? icon;
  final String text;
  final Function() onTap;

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
            onTap: onTap,
            child: ListTile(
              leading: icon != null ? Icon(icon) : null,
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.red,
                size: 20,
              ),
              title: Text(
                text,
                style: accentFont.copyWith(fontSize: 16),
              ),
            ),
          ),
        ));
  }
}
