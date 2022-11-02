import 'dart:convert';

import 'package:delivery/services/prefs_handler.dart';
import 'package:delivery/widgets/settings_card.dart';
import 'package:delivery/widgets/settings_switch.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:scale_button/scale_button.dart';
import 'package:image/image.dart' as img;

import '../services/constants.dart';
import '../services/network.dart';
import '../services/objects.dart';
import 'account_card.dart';
import 'group_card.dart';

class ChooseProductToChanged extends StatefulWidget {
  const ChooseProductToChanged(
      {Key? key,
        required this.shop,
        required this.quantity,
        required this.orderElement,
      })
      : super(key: key);

  final Shop shop;
  final int quantity;
  final OrderElement orderElement;

  @override
  _ChooseProductToChangedState createState() => _ChooseProductToChangedState();
}

class _ChooseProductToChangedState extends State<ChooseProductToChanged> {
  var _color = const Color.fromARGB(255, 255, 255, 255);

  List<Group> _allGroups = [];
  List<Group> _perrentGroups = [];

  List<Product> _products = [];

  Future<void> _update() async {
    var shop = widget.shop;
    var result = await NetHandler().getGroups(context);
    var products = await NetHandler().getProducts(context);

    _allGroups = result ?? [];

    for (var item in _allGroups) {
      if (item.shopId == shop.shopId && item.parentId == '0') {
        _perrentGroups.add(item);
      }
    }

    setState(() {
      _products = products ?? [];
    });
  }

  int _abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  void _getColor(Shop shop) {
    List<int> values = base64Decode(shop.shopLogo).buffer.asUint8List();
    var photo = img.decodeImage(values);

    if (photo == null) return;

    double px = 1.0;
    double py = 0.0;

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = _abgrToArgb(pixel32);

    setState(() {
      _color = Color(hex);
    });
  }


  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    if (_allGroups.isEmpty) {
      _update();
      _getColor(widget.shop);
    }
    return Scaffold(
      body: Stack(
        children: [
          if (_allGroups.isEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Align(
                alignment: Alignment.center,
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  color: _color,
                  size: 50,
                ),
              ),
            ),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                foregroundColor: _color,
                title: Text(
                  widget.shop.shopName,
                  style: GoogleFonts.rubik(
                      fontSize: 18, color: _color, fontWeight: FontWeight.w500),
                ),
                snap: false,
              ),
              if (_perrentGroups.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15),
                    child: Text(
                      'Категории',
                      style: GoogleFonts.rubik(
                          fontSize: 21, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              if (_allGroups.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 7.5,
                    right: 7.5,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        var group = _perrentGroups[index];
                        return GroupCard(
                          color: _color,
                          group: group,
                          orderElement: widget.orderElement,
                          quantity: widget.quantity,
                          allGroups: _allGroups,
                          index: index,
                          products: _products,
                          perrentGroups: _perrentGroups,
                        );
                      },
                      childCount: _perrentGroups.length,
                    ),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 120,
                ),
              ),
            ],
          ),
          if (_perrentGroups.isEmpty && !_allGroups.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/empty-cart.png',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(right: 40, left: 40),
                    child: Text(
                      'К сожалению категорий пока нет(',
                      style: GoogleFonts.rubik(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

}
