import 'package:flutter/material.dart';

extension MyNavigator on Navigator {
  void nextPage(context, widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }
}
