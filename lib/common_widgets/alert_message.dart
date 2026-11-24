import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:async';

class AlertMessage {
  static showError(String message, BuildContext context,
      {Duration? duration}) {
    ToastUtils.showCustomToast(
      context,
      message,
      const Icon(Icons.error, color: Colors.white, size: 40),
      AppColors.error,
      duration: duration,
    );
  }

  static showSuccess(String message, BuildContext context,
      {Duration? duration}) {
    ToastUtils.showCustomToast(
      context,
      message,
      const Icon(Icons.check_circle_outline,
          color: Colors.white, size: 40),
      AppColors.success,
      duration: duration,
    );
  }

  static showWarning(String message, BuildContext context,
      {Duration? duration}) {
    ToastUtils.showCustomToast(
      context,
      message,
      const Icon(Icons.error, color: Colors.white, size: 40),
      AppColors.warning,
      duration: duration,
    );
  }
}

class ToastUtils {
  static Timer? toastTimer;
  static OverlayEntry? _overlayEntry;

  static void showCustomToast(
      BuildContext context,
      String message,
      Icon icon,
      Color color, {
        Duration? duration,
      }) {
    final toastDuration = duration ?? const Duration(seconds: 5);

    // Remove existing toast if showing
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      toastTimer?.cancel();
      _overlayEntry = null;
    }

    _overlayEntry =
        createOverlayEntry(context, message, icon, color, toastDuration);

    Overlay.of(context).insert(_overlayEntry!);

    toastTimer = Timer(toastDuration, () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  static OverlayEntry createOverlayEntry(
      BuildContext context,
      String message,
      Icon icon,
      Color color,
      Duration duration,
      ) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top,
        width: AppSizes.deviceWidth,
        child: SlideInToastMessageAnimation(
          duration: duration,
          child: Material(
            child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(color: color),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 8),
                  SizedBox(
                    width: AppSizes.deviceWidth - 75,
                    child: Text(
                      message,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SlideInToastMessageAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const SlideInToastMessageAnimation({
    super.key,
    required this.child,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final stayDuration =
        duration - const Duration(milliseconds: 500);

    final tween = MultiTween<AnimationType>()
      ..add(
        AnimationType.translateY,
        Tween(begin: -100.0, end: 0.0),
        const Duration(milliseconds: 250),
        Curves.easeOut,
      )
      ..add(
        AnimationType.translateY,
        Tween(begin: 0.0, end: 0.0),
        stayDuration,
      )
      ..add(
        AnimationType.translateY,
        Tween(begin: 0.0, end: -100.0),
        const Duration(milliseconds: 250),
        Curves.easeIn,
      )
      ..add(
        AnimationType.opacity,
        Tween(begin: 0.0, end: 1.0),
        const Duration(milliseconds: 250),
      )
      ..add(
        AnimationType.opacity,
        Tween(begin: 1.0, end: 1.0),
        stayDuration,
      )
      ..add(
        AnimationType.opacity,
        Tween(begin: 1.0, end: 0.0),
        const Duration(milliseconds: 250),
      );

    return PlayAnimation<MultiTweenValues<AnimationType>>(
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) {
        return Opacity(
          opacity: animation.get(AnimationType.opacity),
          child: Transform.translate(
            offset:
            Offset(0, animation.get(AnimationType.translateY)!),
            child: child,
          ),
        );
      },
    );
  }
}

enum AnimationType { opacity, translateY }
