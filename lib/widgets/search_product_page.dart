import 'dart:async';

import 'package:delivery/widgets/product_card.dart';
import 'package:flutter/material.dart';

import '../services/objects.dart';
import 'category.dart';

class SearchProductsPage extends StatefulWidget {
  const SearchProductsPage({
    Key? key,
    required this.close,
    required this.products,
    required this.groups,
    required this.color,
    required this.orderElement,
    required this.quantity,
  }) : super(key: key);

  final Function() close;
  final List<Product> products;
  final List<Group> groups;
  final Color color;
  final OrderElement orderElement;
  final int quantity;

  @override
  _SearchProductsPageState createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  List<Product> _searchedProduct = [];
  final _searchController = TextEditingController();

  final StreamController<List<Product>> _streamController =
  StreamController<List<Product>>();

  void _searchProduct() async {
    if (_searchController.text.isNotEmpty) {
      _streamController.sink.add(widget.products
          .where((element) => element.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()))
          .toList());
    } else {
      _streamController.sink.add(widget.products);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchProduct);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 2 - 22.5;

    return Scaffold(
      body: Stack(
        children: [
          // if (_searchedProduct.isEmpty)
          //   const Center(
          //     child: Text('К сожаление пока нет такого товара('),
          //   ),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                title: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Укажите название",
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 16,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: widget.close,
                    icon: const Icon(
                      Icons.timelapse_sharp,
                      color: Colors.grey,
                      size: 20,
                    ),
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: StreamBuilder<List<Product>>(
                  stream: _streamController.stream,
                  initialData: widget.products,
                  builder: (context, snapshot) =>
                      elements(width, snapshot.data!),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom * 7,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget elements(width, List<Product> products) {
    List<Widget> list = [];
    for (int i = 0; i < products.length; i = i + 2) {
      list.add(_twoElementsRow(i, width, products));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(children: list),
    );
  }

  Widget _twoElementsRow(int index, width, List<Product> products) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ProductCard(
          item: products[index],
          color: widget.color,
          width: width,
          quantity: widget.quantity,
          orderElement: widget.orderElement,
        ),
        if (index + 1 < products.length)
          ProductCard(
            item: products[index + 1],
            color: widget.color,
            width: width,
            quantity: widget.quantity,
            orderElement: widget.orderElement,
          ),
      ],
    );
  }
}
