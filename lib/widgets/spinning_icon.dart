import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// Rotating icon widget in z axis used in the home page
class SpinningIcon extends StatefulWidget {
  /// Default constructor
  const SpinningIcon({
    super.key,
    required this.icon,
    this.isSpinning = true, // 👈 Added flag to control rotation
  });

  final Widget icon;
  final bool isSpinning;

  @override
  State<SpinningIcon> createState() => _SpinningIconState();
}

class _SpinningIconState extends State<SpinningIcon> with TickerProviderStateMixin {
  late AnimationController _animController;
  late CurvedAnimation _curvedAnim;
  Timer? _loopTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _curvedAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticInOut,
    );

    if (widget.isSpinning) {
      _startRotation();
    }
  }

  void _startRotation() {
    _animController.forward();
    _loopTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      _animController.forward(from: 0);
    });
  }

  void _stopRotation() {
    _loopTimer?.cancel();
    _animController.stop();
  }

  @override
  void didUpdateWidget(covariant SpinningIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If rotation state changes dynamically
    if (oldWidget.isSpinning != widget.isSpinning) {
      if (widget.isSpinning) {
        _startRotation();
      } else {
        _stopRotation();
      }
    }
  }

  @override
  void dispose() {
    _loopTimer?.cancel();
    _animController.dispose();
    _curvedAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If rotation is disabled → show static icon
    if (!widget.isSpinning) {
      return widget.icon;
    }

    return MatrixTransition(
      animation: _curvedAnim,
      child: widget.icon,
      onTransform: (double value) {
        return Matrix4.identity()
          ..setEntry(3, 2, 0.004)
          ..rotateY(pi * 8.0 * value);
      },
    );
  }
}
