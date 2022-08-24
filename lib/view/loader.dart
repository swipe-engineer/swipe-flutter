import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final Color? color;

  const Loader({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      alignment: Alignment.center,
      child: _getIndicatorWidget(Theme.of(context).platform),
    );
  }

  Widget _getIndicatorWidget(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoActivityIndicator(
          color: color,
        );
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      default:
        return CircularProgressIndicator(
          color: color,
          strokeWidth: 2,
        );
    }
  }
}
