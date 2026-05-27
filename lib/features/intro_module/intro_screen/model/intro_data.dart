import 'package:flutter/material.dart';

/// Onboarding data model matching Figma design structure
class IntroData {
  final Image image;
  final String title;
  final String? description;
  final String buttonText;

  IntroData({
    required this.image,
    required this.title,
    this.description,
    this.buttonText = "Next",
  });
}
