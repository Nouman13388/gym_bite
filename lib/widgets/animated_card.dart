import 'package:flutter/material.dart';
import '../models/meal_plan_model.dart';
import '../modules/meal_plans/views/client_meal_plan_view_embedded.dart';

class AnimatedMealPlanCard extends StatelessWidget {
  final MealPlanModel plan;
  final VoidCallback onTap;
  final int index;

  const AnimatedMealPlanCard({
    Key? key,
    required this.plan,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Staggered animation for cards
    return AnimatedSlideAndFade(
      delay: Duration(milliseconds: 50 * index),
      child: MealPlanCard(plan: plan, onTap: onTap),
    );
  }
}

class AnimatedSlideAndFade extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const AnimatedSlideAndFade({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  _AnimatedSlideAndFadeState createState() => _AnimatedSlideAndFadeState();
}

class _AnimatedSlideAndFadeState extends State<AnimatedSlideAndFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
