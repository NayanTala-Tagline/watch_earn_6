import 'package:flutter/material.dart';

/// Onboarding data model matching Figma design structure
class OnboardingData {
  final Image image;
  final String title;
  final String? description;
  final String buttonText;

  OnboardingData({
    required this.image,
    required this.title,
    this.description,
    this.buttonText = "Next",
  });
}
