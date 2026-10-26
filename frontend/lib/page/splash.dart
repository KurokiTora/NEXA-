import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/nexa_mark.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import 'dashboard.dart';
import 'login.dart';

/// Splash screen (~5 s), meant to mirror the reference video:
///   0%  - 12%  X mark pops in (scale + fade)
///   12% - 38%  X mark grows and its color floods the whole screen
///   38% - 52%  flood fades away -> background returns, NEXA wordmark appears
///   52% - 66%  tagline fades + slides up
///   50% - 92%  loading line fills left -> right
///   94% - 100% whole screen fades out
/// then navigates to Dashboard / Login.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _markScale; // pop in
  late final Animation<double> _markOpacity;
  late final Animation<double> _flood; // 0 -> 1 circle growth
  late final Animation<double> _floodFade; // 0 -> 1 flood disappears
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _loading;
  late final Animation<double> _screenFade;

  static const _duration = Duration(milliseconds: 5000);

  static const _logoWidth = 210.0;
  static const _logoHeight = _logoWidth * 237 / 774;
  static const _markSize = _logoHeight;

  static const _loadingWidth = 160.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);

    Animation<double> iv(double a, double b, Curve c) => CurvedAnimation(
          parent: _controller,
          curve: Interval(a, b, curve: c),
        );

    // 1) X mark pops in
    _markScale = Tween<double>(begin: 0.4, end: 1.0)
        .animate(iv(0.0, 0.12, Curves.easeOutBack));
    _markOpacity = iv(0.0, 0.08, Curves.easeOut);

    // 2) flood: color grows from the X until it covers the screen
    _flood = iv(0.12, 0.38, Curves.easeInOutCubic);

    // 3) flood fades out, wordmark appears
    _floodFade = iv(0.38, 0.52, Curves.easeOut);
    _logoOpacity = iv(0.42, 0.56, Curves.easeOut);
    _logoScale = Tween<double>(begin: 0.9, end: 1.0)
        .animate(iv(0.42, 0.56, Curves.easeOutCubic));

    // 4) tagline + loading line
    _taglineOpacity = iv(0.52, 0.66, Curves.easeOut);
    _taglineSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(iv(0.52, 0.66, Curves.easeOutCubic));
    _loading = iv(0.50, 0.92, Curves.easeInOut);

    // 5) leave
    _screenFade = iv(0.94, 1.0, Curves.easeInCubic);

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        final loggedIn = context.read<AuthState>().isLoggedIn;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                loggedIn ? const DashboardPage() : const LoginPage(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Circle big enough to cover the screen from the center.
    final maxDiameter = size.longestSide * 2.2;

    return Scaffold(
      backgroundColor: AppColor.Background,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final floodDiameter =
              _markSize * 0.6 + (maxDiameter - _markSize * 0.6) * _flood.value;
          final floodOpacity = (1 - _floodFade.value) *
              (_flood.value > 0 ? 1.0 : 0.0);

          return Opacity(
            opacity: 1 - _screenFade.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Flood circle (X color covering the screen)
                Opacity(
                  opacity: floodOpacity,
                  child: OverflowBox(
                    minWidth: 0,
                    minHeight: 0,
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    child: Container(
                      width: floodDiameter,
                      height: floodDiameter,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.Primary,
                      ),
                    ),
                  ),
                ),

                // X mark (hidden once the flood takes over)
                Opacity(
                  opacity: _markOpacity.value * (1 - _flood.value),
                  child: Transform.scale(
                    scale: _markScale.value * (1 + 2.0 * _flood.value),
                    child: NexaMark(size: _markSize),
                  ),
                ),

                // Wordmark + tagline + loading line
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Image.asset(
                          'asset/image/Nexa_Logo.png',
                          width: _logoWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Opacity(
                      opacity: _taglineOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0, _taglineSlide.value.dy * 20),
                        child: Text(
                          'Your Intelligent Academic Companion',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            color: AppColor.Primary.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Opacity(
                      opacity: _taglineOpacity.value,
                      child: Container(
                        width: _loadingWidth,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColor.Primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: _loadingWidth * _loading.value,
                          decoration: BoxDecoration(
                            color: AppColor.Primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}