import 'package:delivery/widgets/text_field.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color bgColor;
  final String title;
  final String message;
  final bool isText;
  final String positiveBtnText;
  final String negativeBtnText;
  final Function(String) onPostivePressed;
  final Function onNegativePressed;
  final double circularBorderRadius;

  CustomAlertDialog({
    required this.title,
    required this.message,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    required this.positiveBtnText,
    required this.negativeBtnText,
    required this.onPostivePressed,
    required this.onNegativePressed,
    this.isText = true,
  })  : assert(bgColor != null),
        assert(circularBorderRadius != null);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = message;
    return AlertDialog(
      title: title != null ? Text(title) : null,
      content: !isText
          ? TextFieldWidget(
              margin: EdgeInsets.zero,
              color: Colors.grey[200]!,
              type: TextInputType.phone,
              controller: controller,
            )
          : Text('Прежде чем удалить, необходимо позвонить клиенту.'),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: <Widget>[
        if (negativeBtnText != null)
          TextButton(
            child: Text(negativeBtnText),
            style: ButtonStyle(textStyle: MaterialStateProperty.all(TextStyle(color: Theme.of(context).colorScheme.secondary))),
            onPressed: () {
              Navigator.of(context).pop();
              if (onNegativePressed != null) {
                onNegativePressed();
              }
            },
          ),
        if (positiveBtnText != null)
          TextButton(
            child: Text(positiveBtnText),
            style: ButtonStyle(textStyle: MaterialStateProperty.all(TextStyle(color: Theme.of(context).colorScheme.secondary))),
            onPressed: () {
              Navigator.of(context).pop();
              if (onPostivePressed != null) {
                onPostivePressed(controller.text);
              }
            },
          ),
      ],
    );
  }
}
