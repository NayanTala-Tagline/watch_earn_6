import 'package:flutter/material.dart';

/// Represents a single sector (segment) of the spin wheel.
class SpinDiscSector {
  final int value;
  final LinearGradient gradient;

  const SpinDiscSector({
    required this.value,
    required this.gradient,
  });
}
