import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/color_style.dart';
import '../style/text_style.dart';

/// Shared bottom navigation bar for the 5 main tabs.
/// index: 0 = Home, 1 = Grade, 2 = Chatbot, 3 = Feedback, 4 = Attend
///
/// Visual style: a single floating ball is parked in the circular notch cut
/// into the bar under the active tab. When the selection changes the ball
/// jumps to the new tab instead of the bar swapping its active item in place.
///
/// The jump is a ~550ms timeline:
///  * take-off: squash then stretch,
///  * flight: spring-driven horizontal travel with a distance-based parabola,
///  * notch: the old notch shrinks/fades while the new one pops in near landing,
///  * landing: squash then a small spring overshoot, plus a light haptic,
///  * icon: cross-fade with a slight scale/rotate.
///
/// The bar only reports taps; [MainShell] owns the selected index and swaps
/// the visible tab in place so no page transition is played.
class AppBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onSelected;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav>
    with SingleTickerProviderStateMixin {
  static const _items = <_NavItemData>[
    _NavItemData(icon: Icons.home_outlined, label: 'Home'),
    _NavItemData(icon: Icons.workspace_premium_outlined, label: 'Grade'),
    _NavItemData(icon: Icons.auto_awesome, label: 'Chatbot'),
    _NavItemData(icon: Icons.chat_outlined, label: 'Feedback'),
    _NavItemData(icon: Icons.account_box_outlined, label: 'Attend'),
  ];

  static const _barHeight = 70.0;
  static const _ballSize = 54.0;
  static const _notchSize = 62.0;

  // Where the ball rests relative to the bar's top edge. Negative = floating
  // slightly above the bar, with its bottom sitting inside the notch.
  static const _restCenterY = -3.0;

  // Timeline thresholds (fractions of the controller).
  static const _flightStart = 0.12;
  static const _flightEnd = 0.82;
  static const _landingStart = 0.78;
  static const _notchInStart = 0.66;
  static const _iconSwapStart = 0.32;
  static const _iconSwapEnd = 0.80;
  static const _hapticAt = 0.79;

  late final AnimationController _controller;

  int _fromIndex = 0;
  int _toIndex = 0;
  double? _fromXOverride;
  double _ballX = 0;
  bool _landed = false;

  bool get _transitioning => _controller.isAnimating && _fromIndex != _toIndex;

  @override
  void initState() {
    super.initState();
    _fromIndex = widget.currentIndex;
    _toIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..value = 1;

    _controller.addListener(_handleTick);
    _controller.addStatusListener(_handleStatus);
  }

  @override
  void didUpdateWidget(AppBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex == oldWidget.currentIndex) return;

    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _landed = true;
      _fromXOverride = null;
      _controller.value = 1;
      _fromIndex = widget.currentIndex;
      _toIndex = widget.currentIndex;
      return;
    }

    // If a jump is interrupted, continue from wherever the ball currently is
    // instead of snapping back to the previous tab's center.
    _fromXOverride = _controller.isAnimating ? _ballX : null;
    _fromIndex = oldWidget.currentIndex;
    _toIndex = widget.currentIndex;
    _landed = false;
    _controller.forward(from: 0);
  }

  void _handleTick() {
    if (_landed || !_controller.isAnimating) return;
    if (_controller.value >= _hapticAt) {
      _landed = true;
      // Light tap right as the ball settles into the new notch.
      HapticFeedback.lightImpact();
    }
  }

  void _handleStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    if (!mounted) return;
    setState(() {
      _fromIndex = _toIndex;
      _fromXOverride = null;
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleTick)
      ..removeStatusListener(_handleStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extra top padding so the floating ball has room to sit above the bar
    // without getting clipped by whatever is above it on the page.
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 20),
      child: SizedBox(
        height: _barHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final slot = width / _items.length;
            final centers = List<double>.generate(
              _items.length,
              (i) => slot * (i + 0.5),
            );

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => _buildBar(centers, width),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBar(List<double> centers, double width) {
    final t = _controller.value;
    final transitioning = _transitioning;
    final fromX = _fromXOverride ?? centers[_fromIndex];
    final toX = centers[_toIndex];
    final targetIndex = transitioning ? _toIndex : widget.currentIndex;

    // Horizontal travel: a real damped spring (damping 14, stiffness 140).
    // The spring starts just after take-off so the ball visibly leaves the
    // notch instead of sliding out from under itself.
    final springT = ((t - 0.04) / 0.96).clamp(0.0, 1.0);
    final travel = _springProgress(springT);
    final ballX = fromX + (toX - fromX) * travel;
    _ballX = ballX;

    // Vertical travel: a parabola whose height grows with the tab distance.
    final distance = (toX - fromX).abs() / width;
    final jumpHeight = 24 + 34 * distance.clamp(0.0, 1.0);
    final flightT = ((t - _flightStart) / (_flightEnd - _flightStart)).clamp(
      0.0,
      1.0,
    );
    final lift = -jumpHeight * math.sin(math.pi * flightT);

    final squash = _squashFor(t);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // The bar itself.
        Container(
          height: _barHeight,
          decoration: BoxDecoration(
            color: AppColor.Primary,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColor.Primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),

        // Tab hit targets, base icons and labels.
        Positioned.fill(
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _TabTarget(
                    item: _items[i],
                    active: i == targetIndex,
                    labelOpacity: _labelOpacity(i, t, transitioning),
                    iconOpacity: _baseIconOpacity(i, t, transitioning),
                    onTap: () {
                      if (i != widget.currentIndex) widget.onSelected(i);
                    },
                  ),
                ),
            ],
          ),
        ),

        // Notches are drawn above the bar so they read as scoops cut into its
        // top edge. The old one heals away, the new one pops in on landing.
        if (transitioning) ...[
          _buildNotch(centers[_fromIndex], _oldNotchProgress(t)),
          _buildNotch(centers[_toIndex], _newNotchProgress(t)),
        ] else
          _buildNotch(centers[targetIndex], 1),

        // The floating ball.
        _buildBall(
          x: ballX,
          y: _restCenterY + lift,
          iconIndex: targetIndex,
          squash: squash,
          t: t,
          transitioning: transitioning,
          lift: -lift,
        ),
      ],
    );
  }

  Widget _buildNotch(double centerX, double progress) {
    final opacity = progress.clamp(0.0, 1.0);
    final scale = progress <= 0 ? 0.0 : progress;
    return Positioned(
      left: centerX - _notchSize / 2,
      top: -_notchSize / 2,
      width: _notchSize,
      height: _notchSize,
      child: IgnorePointer(
        child: Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColor.Background,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBall({
    required double x,
    required double y,
    required int iconIndex,
    required _Squash squash,
    required double t,
    required bool transitioning,
    required double lift,
  }) {
    const radius = _ballSize / 2;
    final fromIcon = _items[_fromIndex].icon;
    final toIcon = _items[_toIndex].icon;

    final swapT = ((t - _iconSwapStart) / (_iconSwapEnd - _iconSwapStart))
        .clamp(0.0, 1.0);
    final oldIconOpacity = transitioning
        ? (1 - Curves.easeIn.transform(swapT)).clamp(0.0, 1.0)
        : 0.0;
    final newIconOpacity = transitioning
        ? Curves.easeOut.transform(((swapT - 0.25) / 0.75).clamp(0.0, 1.0))
        : 1.0;
    final oldIconScale = transitioning ? 1 - 0.45 * swapT : 1.0;
    final newIconScale = transitioning ? 0.55 + 0.45 * swapT : 1.0;
    final oldIconRotation = transitioning ? -0.45 * swapT : 0.0;
    final newIconRotation = transitioning ? 0.45 * (1 - swapT) : 0.0;

    // A higher ball casts a softer, further shadow.
    final shadowLift = lift.clamp(0.0, 70.0);

    return Positioned(
      left: x - radius,
      top: y - radius,
      width: _ballSize,
      height: _ballSize,
      child: IgnorePointer(
        child: Transform.scale(
          scaleX: squash.x,
          scaleY: squash.y,
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.Background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 10 + shadowLift * 0.35,
                  offset: Offset(0, 4 + shadowLift * 0.22),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (transitioning)
                  Opacity(
                    opacity: oldIconOpacity,
                    child: Transform.rotate(
                      angle: oldIconRotation,
                      child: Transform.scale(
                        scale: oldIconScale,
                        child: Icon(
                          fromIcon,
                          size: 28,
                          color: AppColor.Primary,
                        ),
                      ),
                    ),
                  ),
                Opacity(
                  opacity: newIconOpacity,
                  child: Transform.rotate(
                    angle: newIconRotation,
                    child: Transform.scale(
                      scale: newIconScale,
                      child: Icon(
                        transitioning ? toIcon : _items[iconIndex].icon,
                        size: 28,
                        color: AppColor.Primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _labelOpacity(int index, double t, bool transitioning) {
    if (!transitioning) return index == widget.currentIndex ? 1 : 0;
    if (index == _fromIndex) {
      return (1 - (t / 0.22)).clamp(0.0, 1.0);
    }
    if (index == _toIndex) {
      return ((t - _notchInStart) / (1 - _notchInStart)).clamp(0.0, 1.0);
    }
    return 0;
  }

  double _baseIconOpacity(int index, double t, bool transitioning) {
    if (!transitioning) return index == widget.currentIndex ? 0 : 1;
    if (index == _toIndex) return 0;
    if (index == _fromIndex) {
      // The old tab's icon fades back in once the ball has flown away.
      return ((t - 0.3) / 0.3).clamp(0.0, 1.0);
    }
    return 1;
  }

  double _oldNotchProgress(double t) {
    final p = (t / 0.24).clamp(0.0, 1.0);
    return 1 - Curves.easeIn.transform(p);
  }

  double _newNotchProgress(double t) {
    final p = ((t - _notchInStart) / (1 - _notchInStart)).clamp(0.0, 1.0);
    if (p == 0) return 0;
    return Curves.easeOutBack.transform(p).clamp(0.0, 1.2);
  }

  _Squash _squashFor(double t) {
    if (t <= 0.1) {
      // Anticipation: squash down.
      final p = t / 0.1;
      return _Squash(x: 1 + 0.12 * p, y: 1 - 0.15 * p);
    }
    if (t <= 0.28) {
      // Stretch as the ball leaves the notch.
      final p = (t - 0.1) / 0.18;
      return _Squash(x: 1.12 - 0.22 * p, y: 0.85 + 0.30 * p);
    }
    if (t <= 0.34) {
      // Settle back to a round shape during the ascent.
      final p = (t - 0.28) / 0.06;
      return _Squash(x: 0.90 + 0.10 * p, y: 1.15 - 0.15 * p);
    }
    if (t <= _landingStart) {
      return const _Squash(x: 1, y: 1);
    }

    // Landing: quick squash, then a springy overshoot back to round.
    final p = ((t - _landingStart) / (1 - _landingStart)).clamp(0.0, 1.0);
    if (p <= 0.18) {
      final q = p / 0.18;
      return _Squash(x: 1 + 0.15 * q, y: 1 - 0.20 * q);
    }
    final q = ((p - 0.18) / 0.82).clamp(0.0, 1.0);
    final spring = Curves.elasticOut.transform(q);
    return _Squash(x: 1.15 - 0.15 * spring, y: 0.80 + 0.20 * spring);
  }

  /// Unit step response of a damped spring, so the horizontal travel feels
  /// like `withSpring(damping: 14, stiffness: 140)`.
  double _springProgress(double t) {
    if (t <= 0) return 0;
    if (t >= 1) return 1;

    const mass = 1.0;
    const damping = 14.0;
    const stiffness = 140.0;

    final omega0 = math.sqrt(stiffness / mass);
    final zeta = damping / (2 * math.sqrt(stiffness * mass));
    final omegaD = omega0 * math.sqrt(1 - zeta * zeta);
    final seconds = t * 0.55;
    final envelope = math.exp(-zeta * omega0 * seconds);

    return 1 -
        envelope *
            (math.cos(omegaD * seconds) +
                (zeta * omega0 / omegaD) * math.sin(omegaD * seconds));
  }
}

class _TabTarget extends StatelessWidget {
  const _TabTarget({
    required this.item,
    required this.active,
    required this.labelOpacity,
    required this.iconOpacity,
    required this.onTap,
  });

  final _NavItemData item;
  final bool active;
  final double labelOpacity;
  final double iconOpacity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox.expand(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Inactive icon. The active tab hides it because the ball carries
              // the icon instead.
              Align(
                alignment: const Alignment(0, -0.25),
                child: Opacity(
                  opacity: iconOpacity,
                  child: Icon(
                    item.icon,
                    size: 26,
                    color: AppColor.TextSecondary.withValues(alpha: 0.55),
                  ),
                ),
              ),
              // Active label, sitting under the notch.
              Align(
                alignment: const Alignment(0, 0.55),
                child: Opacity(
                  opacity: labelOpacity,
                  child: Text(
                    item.label,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.button.copyWith(
                      color: AppColor.Background,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Squash {
  final double x;
  final double y;
  const _Squash({required this.x, required this.y});
}

class _NavItemData {
  final IconData icon;
  final String label;
  const _NavItemData({required this.icon, required this.label});
}
