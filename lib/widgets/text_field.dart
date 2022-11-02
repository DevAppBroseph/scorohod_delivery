import 'package:delivery/services/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    this.hint,
    this.icon,
    this.type,
    this.controller,
    this.onTap,
    this.formatter,
    this.maxLength,
    this.maxLines = 1,
    this.readOnly,
    this.textCapitalization = TextCapitalization.sentences,
    this.password = false,
    this.margin = const EdgeInsets.fromLTRB(15, 15, 15, 0),
    this.color = const Color(0xFFFBFBFB),
    this.textAlign = TextAlign.start,
    this.onChanged,
  });

  final String? hint;
  final IconData? icon;
  final TextInputType? type;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final Function()? onTap;
  final List<TextInputFormatter>? formatter;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final EdgeInsets margin;
  final Color color;
  final int maxLines;
  final bool? readOnly;
  final bool password;
  final TextAlign textAlign;

  get radius => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: margin,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: constants.radius,
      ),
      child: TextField(
        onTap: onTap,
        obscureText: password,
        onChanged: onChanged,
        maxLength: maxLength,
        maxLines: maxLines,
        readOnly: readOnly ?? false,
        controller: controller,
        inputFormatters: formatter,
        textCapitalization: textCapitalization,
        keyboardAppearance: Brightness.light,
        keyboardType: type,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        textAlign: textAlign,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          counterStyle: TextStyle(
            height: double.minPositive,
          ),
          counterText: "",
          prefixIcon: icon != null
              ? Icon(
                  icon!,
                  color: Colors.blueGrey,
                )
              : null,
        ),
      ),
    );
  }
}
