import 'package:delivery/widgets/app_bar.dart';
import 'package:delivery/widgets/text_field.dart';
import 'package:flutter/material.dart';

import '../widgets/settings_card.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({Key? key}) : super(key: key);

  @override
  _ChangePassScreenState createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  TextEditingController _oldPassController = TextEditingController();
  TextEditingController _newPassController = TextEditingController();
  TextEditingController _secondNewPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        slivers: [
          const StandartAppBar(
            title: Text('Пароль'),
          ),
          SliverToBoxAdapter(
            child: TextFieldWidget(
              controller: _oldPassController,
              hint: 'Старый пароль',
            ),
          ),
          SliverToBoxAdapter(
            child: TextFieldWidget(
              controller: _newPassController,
              hint: 'Новый пароль',
              password: true,
            ),
          ),
          SliverToBoxAdapter(
            child: TextFieldWidget(
              controller: _secondNewPassController,
              hint: 'Новый пароль',
              password: true,
            ),
          ),
          SliverToBoxAdapter(
            child: SettingsCard(
              icon: null,
              text: 'Войти',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
