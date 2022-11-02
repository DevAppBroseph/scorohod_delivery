import 'package:delivery/services/network.dart';
import 'package:delivery/services/objects.dart';
import 'package:delivery/services/prefs_handler.dart';
import 'package:delivery/widgets/app_bar.dart';
import 'package:delivery/services/enums.dart';
import 'package:delivery/widgets/my_flushbar.dart';
import 'package:delivery/widgets/settings_card.dart';
import 'package:delivery/widgets/text_field.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.account}) : super(key: key);
  final Account account;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        slivers: [
          const StandartAppBar(
            title: Text('Авторизация'),
          ),
          SliverToBoxAdapter(
            child: Container(
                margin: const EdgeInsets.fromLTRB(0, 60, 0, 30),
                height: 100,
                width: 100,
                child: Image.asset('lib/assets/logo.png')),
          ),
          SliverToBoxAdapter(
            child: TextFieldWidget(
              hint: 'E-Mail',
              controller: _loginController,
            ),
          ),
          SliverToBoxAdapter(
            child: TextFieldWidget(
              hint: 'Пароль',
              password: true,
              controller: _passController,
            ),
          ),
          SliverToBoxAdapter(
            child: SettingsCard(
              icon: null,
              text: 'Войти',
              onTap: () => auth(provider),
            ),
          ),
        ],
      ),
    );
  }

  void auth(DataProvider provider) async {
    if (_loginController.text.isNotEmpty && _passController.text.isNotEmpty) {
      var token = await FirebaseMessaging.instance.getToken();
      if (widget.account == Account.driver) {
        var result = await NetHandler.authCourier(
            context, _loginController.text, _passController.text, token!);
        if (result != null) {
          Navigator.pop(context);
          provider.setCourier(
            Courier(
              courierName: result.courier.courierName,
              courierEmail: result.courier.courierEmail,
              courierPhone: result.courier.courierPhone,
              courierId: result.courier.courierId,
              courierStatus: result.courier.courierStatus,
            ),
            result.jwt,
          );
          print(result);
        } else {
          MyFlushbar.showFlushbar(
              context, 'Ошибка.', 'Неправильный логин или пароль.');
        }
      } else if (widget.account == Account.manager) {
        var result = await NetHandler.authManager(
            context, _loginController.text, _passController.text, token!);

        if (result != null) {
          Navigator.pop(context);
          provider.setManager(result);
        } else {
          MyFlushbar.showFlushbar(
              context, 'Ошибка.', 'Неправильный логин или пароль.');
        }
      }
    } else {
      MyFlushbar.showFlushbar(context, 'Внимание.', 'Данные не заполнены.');
    }
  }
}
