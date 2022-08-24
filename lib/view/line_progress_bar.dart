import 'package:flutter/material.dart';

const double _kLineProgressBarHeight = 4.0;

class LineProgressBar extends SizedBox implements PreferredSizeWidget {
  final double progressValue;
  LineProgressBar({Key? key, this.progressValue = 0.0})
      : super(
          key: key,
          height: _kLineProgressBarHeight,
          child: LinearProgressIndicator(
            value: progressValue,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );

  @override
  Size get preferredSize =>
      const Size(double.infinity, _kLineProgressBarHeight);
}
