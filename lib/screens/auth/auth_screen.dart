import 'package:delivery/screens/web.dart';
import 'package:delivery/widgets/app_bar.dart';
import 'package:delivery/services/enums.dart';
import 'package:delivery/services/router.dart';
import 'package:flutter/material.dart';

import '../../widgets/settings_card.dart';
import 'login_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        slivers: [
          const StandartAppBar(
            title: Text('Авторизация'),
          ),
          SliverToBoxAdapter(
            child: Container(
                margin: const EdgeInsets.only(top: 60),
                height: 100,
                width: 100,
                child: Image.asset('lib/assets/logo.png')),
          ),
          const SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  'Привет! Это Скороход Про.',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SettingsCard(
                icon: null,
                text: 'Войти, как курьер.',
                onTap: () {
                  const Navigator().nextPage(
                      context, const LoginScreen(account: Account.driver));
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SettingsCard(
              icon: null,
              text: 'Войти, как менеджер.',
              onTap: () {
                const Navigator().nextPage(
                    context, const LoginScreen(account: Account.manager));
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebPage(
                          title: 'Политика конфиденциальности',
                          url: 'https://scorohod.shop/delivery_policy/',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Политика конфиденциальности',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
