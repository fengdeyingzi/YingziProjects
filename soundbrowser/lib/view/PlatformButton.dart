import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BasePlatformWidget.dart';

/**

Button
*/
class PlatformButton extends BasePlatformWidget<FlatButton, CupertinoButton> {
final VoidCallback onPressed;
final Widget child;

PlatformButton({this.onPressed, this.child});

@override
FlatButton createAndroidWidget(BuildContext context) {
return new FlatButton(onPressed: onPressed, child: child);
}

@override
CupertinoButton createIosWidget(BuildContext context) {
return new CupertinoButton(child: child, onPressed: onPressed);
}
}