import 'package:delivery/screens/auth/auth_screen.dart';
import 'package:delivery/screens/courier/main_screen.dart';
import 'package:delivery/screens/manager/main.dart';
import 'package:delivery/services/prefs_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckScreen extends StatelessWidget {
  const CheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    return Scaffold(
      body: futureBuilder(provider, context),
    );
  }

  Widget futureBuilder(
    DataProvider provider,
    BuildContext context,
  ) {
    if (provider.hasCourier) {
      return const MainScreen();
    } else if (provider.hasManager) {
      return const MainPage();
    } else {
      return const AuthScreen();
    }
  }
}
