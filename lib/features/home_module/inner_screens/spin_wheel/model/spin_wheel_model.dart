import 'package:flutter/material.dart';

/// Represents a single sector (segment) of the spin wheel.
class SpinWheelSector {
  final int value;
  final LinearGradient gradient;

  const SpinWheelSector({
    required this.value,
    required this.gradient,
  });
}
