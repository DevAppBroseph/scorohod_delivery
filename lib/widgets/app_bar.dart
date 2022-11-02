import 'package:flutter/material.dart';

class StandartAppBar extends StatelessWidget {
  const StandartAppBar({
    this.title,
    this.expandedHeight = 0,
    this.flexibleSpace,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.color,
    this.pinned,
  });

  final Widget? title;
  final Widget? flexibleSpace;
  final Widget? leading;
  final List<Widget>? actions;
  final double expandedHeight;
  final bool automaticallyImplyLeading;
  final Color? color;
  final bool? pinned;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: pinned == null ? true : false,
      centerTitle: true,
      leading: leading,
      expandedHeight: expandedHeight,
      backgroundColor: color,
      shadowColor: Colors.grey.withOpacity(0.15),
      title: title,
      flexibleSpace: flexibleSpace,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}
