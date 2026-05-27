import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../extension/ext_context.dart';
import '../loading_spinner.dart';
import 'loading_shade_controller.dart';

/// Loading overlay is a singleton class that can be used to show loading indicator on top of the screen.
class LoadingShade {
  /// Returns the singleton instance of [LoadingShade]
  factory LoadingShade.instance() => _singleton;

  LoadingShade._();

  static final LoadingShade _singleton = LoadingShade._();

  LoadingShadeController? _overlayController;

  /// flag to check if loader is on tree or not
  bool isShowing = false;

  /// Shows loading indicator on top of the screen.
  void show({required BuildContext context, String text = ''}) {
    if (_overlayController?.update(text) ?? false) {
      return;
    } else {
      _overlayController = _showOverlay(context: context, text: text);
    }
  }

  /// updates progress on overlay loading
  void progress(double? val) {
    _overlayController?.progress(val);
  }

  /// updates text shown on overlay loading
  void updateTitle(String text) {
    _overlayController?.update(text);
  }

  /// Hides loading indicator.
  void hide() {
    _overlayController?.close();
    _overlayController = null;
  }

  LoadingShadeController? _showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final titleStream = StreamController<String>()
      ..add(text); // default string in stream
    final progressStream = StreamController<double?>()
      ..add(null); // default string in stream

    // final renderBox = context.findRenderObject()! as RenderBox;
    // final screenSize = renderBox.size;

    showDialog<AlertDialog>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) {
        isShowing = true;
        return PopScope(
          canPop: false,
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                StreamBuilder<double?>(
                  stream: progressStream.stream,
                  builder: (context, snapshot) {
                    return LoadingSpinner(
                      progress: snapshot.data,
                      color: Colors.white,
                    );
                  },
                ),
                const SizedBox(height: 16),
                StreamBuilder(
                  stream: titleStream.stream,
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.hasData ? snapshot.requireData : '',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    return LoadingShadeController(
      close: () {
        if (context.mounted && context.canPop()) {
          // Changing context.pop() to Navigator.of(context).pop()
          // Issue : Loading overlay pop issue [community feed-> Community feed list -> hide]
          context.pop();
          isShowing = false;
        }
        titleStream.close();
        progressStream.close();
        return true;
      },
      update: (text) {
        titleStream.add(text);
        return true;
      },
      progress: (progress) {
        progressStream.add(progress);
        return true;
      },
    );
  }
}
