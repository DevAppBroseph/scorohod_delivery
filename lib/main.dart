import 'package:delivery/screens/check_token.dart';
import 'package:delivery/services/constants.dart';
import 'package:delivery/services/orders_bloc.dart';
import 'package:delivery/services/prefs_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var provider = await DataProvider.getInstance();
  // provider.signOutManager();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<OrderBloc>(create: (context) {
          return OrderBloc();
        }),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) => provider,
          ),
        ],
        child: OverlaySupport.global(
          child: MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            home: const CheckScreen(),
          ),
        ),
      ),
    ),
  );
}
