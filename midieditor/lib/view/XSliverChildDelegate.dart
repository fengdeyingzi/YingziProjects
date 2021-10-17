import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class XSliverChildDelegate extends SliverPersistentHeaderDelegate{

  XSliverChildDelegate({
    @required this.minHeight=0,
    @required this.maxHeight=0,
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
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      dragStartBehavior:DragStartBehavior.down,
      child:child,
    );
  }

  @override
  bool shouldRebuild(XSliverChildDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight
    ;
    //child != oldDelegate.child
  }
}