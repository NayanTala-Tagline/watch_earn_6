import 'package:flutter/cupertino.dart';

class BrowseSiteData {
  final String title;
  final Widget icon;
  final int reward;
  final Color startColor;
  final Color endColor;

  BrowseSiteData({
    required this.title,
    required this.icon,
    required this.reward,
    required this.startColor,
    required this.endColor,
  });
}