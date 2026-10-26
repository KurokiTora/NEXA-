import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import 'dashboard.dart';
import 'login.dart';

/// Splash screen (~1.6 s, tap to skip).
///   0%  - 20%  NEXA logo scale + fade in, glow pulse
///   20% - 50%  shimmer sweep
///   42% - 66%  accent line grows + tagline fades/slides up
///   66% - 82%  hold
///   82% - 100% screen fades out -> fade transition to next page
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _glowPulse;
  late final Animation<double> _logoCrossOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _shimmerProgress;
  late final Animation<double> _lineWidth;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _taglineSlide;
  late final Animation<double> _screenFade;

  static const _duration = Duration(milliseconds: 1600);
  static const _logoWidth = 210.0;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);

    _glowPulse = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 20),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.55)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25),
      TweenSequenceItem(
          tween: Tween(begin: 0.55, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 30),
    ]).animate(CurvedAnimation(
        parent: _controller, curve: const Interval(0.0, 0.70)));

    _logoCrossOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.20, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.92, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.20, curve: Curves.easeOutCubic)));

    _shimmerProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.20, 0.50, curve: Curves.easeInOut),
    );

    _lineWidth = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.42, 0.62, curve: Curves.easeOutCubic),
    );

    _taglineOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.46, 0.66, curve: Curves.easeOut),
    );
    _taglineSlide = Tween<double>(begin: 12, end: 0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.46, 0.66, curve: Curves.easeOutCubic)));

    _screenFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.82, 1.0, curve: Curves.easeInCubic),
    );

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _goNext();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('asset/image/Nexa_Logo.png'), context);
  }

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;
    final loggedIn = context.read<AuthState>().isLoggedIn;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, _, _) =>
            loggedIn ? const DashboardPage() : const LoginPage(),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _glow(double size, double alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColor.Primary.withValues(alpha: alpha),
            AppColor.Primary.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.Background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _goNext, // tap to skip
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final glow = _glowPulse.value;
            return Opacity(
              opacity: 1 - _screenFade.value,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 280,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // outer soft glow
                          Opacity(
                              opacity: glow.clamp(0.0, 1.0),
                              child: _glow(260, 0.12 * glow)),
                          // inner stronger glow
                          Opacity(
                              opacity: glow.clamp(0.0, 1.0),
                              child: _glow(150, 0.25 * glow)),

                          // logo + shimmer
                          Opacity(
                            opacity: _logoCrossOpacity.value,
                            child: Transform.scale(
                              scale: _logoScale.value,
                              child: ShaderMask(
                                blendMode: BlendMode.srcATop,
                                shaderCallback: (bounds) {
                                  final dx =
                                      -1.5 + 4.0 * _shimmerProgress.value;
                                  return LinearGradient(
                                    begin: Alignment(-1 + dx, -0.4),
                                    end: Alignment(0 + dx, 0.4),
                                    colors: [
                                      AppColor.Primary,
                                      Colors.white.withValues(alpha: 0.9),
                                      AppColor.Primary,
                                    ],
                                    stops: const [0.35, 0.5, 0.65],
                                  ).createShader(bounds);
                                },
                                child: Image.asset(
                                  'asset/image/Nexa_Logo.png',
                                  width: _logoWidth,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // accent line
                    Container(
                      width: 48 * _lineWidth.value,
                      height: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(colors: [
                          AppColor.Primary.withValues(alpha: 0.0),
                          AppColor.Primary,
                          AppColor.Primary.withValues(alpha: 0.0),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // tagline
                    Opacity(
                      opacity: _taglineOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0, _taglineSlide.value),
                        child: Text(
                          'Your Intelligent Academic Companion',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            letterSpacing: 1.2,
                            color: AppColor.Primary.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}