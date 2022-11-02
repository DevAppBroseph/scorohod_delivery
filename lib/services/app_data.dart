import 'package:delivery/models/error.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  int _webStatus = 200;
  AnswerError _webError = AnswerError(message: "");

  int get webStatus => _webStatus;
  AnswerError get webError => _webError;

  void setWebError(int status, {AnswerError? error}) {
    _webStatus = status;
    if (error != null) {
      _webError = error;
    }
    notifyListeners();
  }
}
