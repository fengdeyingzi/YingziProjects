
import 'package:flutter/material.dart';
import '../base/StartWidget.dart';
import '../BaseConfig.dart';


class XBottomNavigationBar extends StatefulWidget {
  ValueChanged<int> onTap;
  int currentIndex;
  Color backgroundColor;
  Color unselectedItemColor;
  TextStyle selectedLabelStyle;
  TextStyle unselectedLabelStyle;
  Color selectedItemColor;
  List<XBottomNavigationBarItem> items;
  double elevation;


  XBottomNavigationBar({this.onTap,this.currentIndex,this.backgroundColor,this.unselectedItemColor,this.selectedLabelStyle,this.unselectedLabelStyle,this.selectedItemColor,this.items,this.elevation});

  @override
  State<StatefulWidget> createState() {
    return _XBottomNavigationBarState();
  }

}


class _XBottomNavigationBarState extends State<XBottomNavigationBar> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double bottom_size = MediaQuery.of(context).systemGestureInsets.bottom;
    double bottom_size = 0;
    return Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(0, 0, 0, bottom_size),
        height: 52,
        child: Row( mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.items.map((item){
            var index = widget.items.indexOf(item);
            return _buildBottomItem(icon: item.icon,activeIcon: item.activeIcon,label: item.label,index: index,isRed: item.isRed??false, onTap: (){

//            setState(() {
//              widget.currentIndex = index;
//            });
              if(widget.onTap != null)
              widget.onTap(index);
            });
          }).toList(),
        ),
      );
  }

  // 封装的BottomItem，选中颜色为primaryColor，未选中grey。点击波纹效果InkResponse
  Widget _buildBottomItem({Widget icon, Widget activeIcon, String label, int index,bool isRed=false,VoidCallback onTap}) {
    Widget item_widget = widget.currentIndex == index ? activeIcon : icon;
    TextStyle item_textstyle = widget.currentIndex == index ? widget.selectedLabelStyle : widget.unselectedLabelStyle;
    return Expanded(
        child: Container(
          height: 52,
          child:
          InkResponse(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      alignment: const FractionalOffset(0.9, 0),
                      children: <Widget>[

                        Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child:item_widget
//                          Image.asset(image, color:currentIndex==index?Colors.white: color , width: 22.0, height: 22.0),
                        ),
                        (isRed)? Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                        ) :SizedBox()
                      ],
                    ),
SizedBox(width: 5,height: 3.5,),
                    Text(label,  maxLines: 1,
                        style: item_textstyle ?? TextStyle(color: widget.currentIndex==index ?Colors.white: BaseConfig.colorAccent, fontSize: BaseConfig.font_h5))
                  ]),
              onTap:onTap?? () {
              }

          ),



        ));
  }

  @override
  void didUpdateWidget(covariant XBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("tabbar  数据更新");
  }
}

class XBottomNavigationBarItem {
  /// Creates an item that is used with [BottomNavigationBar.items].
  ///
  /// The argument [icon] should not be null and the argument [title] should not be null when used in a Material Design's [BottomNavigationBar].
   XBottomNavigationBarItem({
    @required this.icon,
    @Deprecated(
        'Use "label" instead, as it allows for an improved text-scaling experience. '
            'This feature was deprecated after v1.19.0.'
    )
    this.title,
    this.label,
    this.isRed,
    Widget activeIcon,
    this.backgroundColor,
  }) : activeIcon = activeIcon ?? icon,
        assert(label == null || title == null),
        assert(icon != null);

  /// The icon of the item.
  ///
  /// Typically the icon is an [Icon] or an [ImageIcon] widget. If another type
  /// of widget is provided then it should configure itself to match the current
  /// [IconTheme] size and color.
  ///
  /// If [activeIcon] is provided, this will only be displayed when the item is
  /// not selected.
  ///
  /// To make the bottom navigation bar more accessible, consider choosing an
  /// icon with a stroked and filled version, such as [Icons.cloud] and
  /// [Icons.cloud_queue]. [icon] should be set to the stroked version and
  /// [activeIcon] to the filled version.
  ///
  /// If a particular icon doesn't have a stroked or filled version, then don't
  /// pair unrelated icons. Instead, make sure to use a
  /// [BottomNavigationBarType.shifting].
  final Widget icon;

  /// An alternative icon displayed when this bottom navigation item is
  /// selected.
  ///
  /// If this icon is not provided, the bottom navigation bar will display
  /// [icon] in either state.
  ///
  /// See also:
  ///
  ///  * [BottomNavigationBarItem.icon], for a description of how to pair icons.
  final Widget activeIcon;

  /// The title of the item. If the title is not provided only the icon will be shown when not used in a Material Design [BottomNavigationBar].
  ///
  /// This field is deprecated, use [label] instead.
  @Deprecated(
      'Use "label" instead, as it allows for an improved text-scaling experience. '
          'This feature was deprecated after v1.19.0.'
  )
  final Widget title;

  /// The text label for this [BottomNavigationBarItem].
  ///
  /// This will be used to create a [Text] widget to put in the bottom navigation bar,
  /// and in Material Design [BottomNavigationBar]s, this will be used to display
  /// a tooltip on long press of an item in the [BottomNavigationBar].
  final String label;

  /// The color of the background radial animation for material [BottomNavigationBar].
  ///
  /// If the navigation bar's type is [BottomNavigationBarType.shifting], then
  /// the entire bar is flooded with the [backgroundColor] when this item is
  /// tapped. This will override [BottomNavigationBar.backgroundColor].
  ///
  /// Not used for [CupertinoTabBar]. Control the invariant bar color directly
  /// via [CupertinoTabBar.backgroundColor].
  ///
  /// See also:
  ///
  ///  * [Icon.color] and [ImageIcon.color] to control the foreground color of
  ///    the icons themselves.
  final Color backgroundColor;
  bool isRed;
}