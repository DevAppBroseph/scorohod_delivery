import 'package:delivery/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/objects.dart';

class CategoryWidget extends StatefulWidget {
  final Group category;
  final int index;
  final List<Product> products;
  final Color color;
  final double width;
  final OrderElement orderElement;
  final int quantity;

  const CategoryWidget({
    Key? key,
    required this.category,
    required this.index,
    required this.products,
    required this.color,
    required this.width,
    required this.quantity,
    required this.orderElement,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.index != 0 &&
            widget.products
                .where((element) => element.groupId == widget.category.id)
                .isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 15),
            child: Text(
              widget.category.name,
              style: GoogleFonts.rubik(
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        const SizedBox(height: 12),
        elements(),
      ],
    );
  }

  Widget elements() {
    List<Widget> list = [];
    for (int i = 0;
    i <
        widget.products
            .where((element) => element.groupId == widget.category.id)
            .length;
    i = i + 2) {
      list.add(_twoElementsRow(i));
    }
    return Column(children: list);
  }

  Widget _twoElementsRow(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ProductCard(
          width: widget.width,
          item: widget.products
              .where((element) => element.groupId == widget.category.id)
              .toList()[index],
          color: widget.color,
          orderElement: widget.orderElement,
          quantity: widget.quantity,
        ),
        if (widget.products
            .where((element) => element.groupId == widget.category.id)
            .length >
            index + 1)
          ProductCard(
            width: widget.width,
            item: widget.products
                .where((element) => element.groupId == widget.category.id)
                .toList()[index + 1],
            color: widget.color,
            orderElement: widget.orderElement,
            quantity: widget.quantity,
          )
      ],
    );
  }
}
