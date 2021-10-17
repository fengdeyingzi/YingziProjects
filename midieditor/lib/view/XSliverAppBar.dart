import 'package:flutter/widgets.dart';
import 'dart:math' as math;
/*
class XSliverAppBar extends SliverPersistentHeaderDelegate {
  XSliverAppBar({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: maxHeight,
      alignment: Alignment.center,
      child: Text("测试"),
    );
  }

  @override
  bool shouldRebuild(XSliverAppBar oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}*/


class XSliverAppBar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _XSliverState();
  }

}


class _XSliverState extends State<XSliverAppBar> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      alignment: Alignment.center,
      child: Text("hgoiehg"),
    );
  }

}