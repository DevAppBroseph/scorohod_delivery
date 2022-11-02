import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scale_button/scale_button.dart';

import '../services/objects.dart';
import 'group_page.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    Key? key,
    required Color color,
    required this.orderElement,
    required this.quantity,
    required this.group,
    required List<Group> allGroups,
    required List<Product> products,
    required List<Group> perrentGroups,
    required this.index,
  })  : _color = color,
        _allGroups = allGroups,
        _products = products,
        _perrentGroups = perrentGroups,
        super(key: key);

  final Color _color;
  final Group group;
  final int index;
  final int quantity;
  final List<Group> _allGroups;
  final List<Product> _products;
  final List<Group> _perrentGroups;
  final OrderElement orderElement;

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      duration: const Duration(milliseconds: 150),
      bound: 0.05,
      onTap: () {
        print(123);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupPage(
              perrent: group,
              orderElement: orderElement,
              groups: _allGroups,
              products: _products,
              color: _color,
              quantity: quantity,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 7.5,
          horizontal: 7.5,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
                color: const Color.fromARGB(255, 214, 214, 214).withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 5)),
          ],
          color: Colors.white,
        ),
        height: 150.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              if (_perrentGroups[index].groupImage != '')
                Positioned(
                  bottom: -20.0,
                  left: -20.0,
                  // right: -15.0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      // left: 9,
                      // bottom: 9,
                      // right: 9,
                      // top: 9,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Opacity(
                        opacity: 0.8,
                        child: Image.memory(
                          base64Decode(
                            _perrentGroups[index].groupImage,
                          ),
                          fit: BoxFit.scaleDown,
                          width: 80,
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  top: 9,
                  right: 5,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    group.name,
                    style: GoogleFonts.rubik(
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.right,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
