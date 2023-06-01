import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimationActive;
  final Duration duration;
  final VoidCallback? onLiked;
  final bool isLiked;

  const LikeAnimation({
    super.key,
    required this.child,
    required this.isAnimationActive,
    this.duration = const Duration(milliseconds: 150),
    this.onLiked,
    this.isLiked = false,
  });

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );
    scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimationActive != oldWidget.isAnimationActive) {
      startAnimation();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void startAnimation() async {
    if (widget.isAnimationActive || widget.isLiked) {
      await _animationController.forward();
      await _animationController.reverse();

      await Future.delayed(const Duration(milliseconds: 200));

      if (widget.onLiked != null) {
        widget.onLiked!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: widget.child,
    );
  }
}
