import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import '../widgets/states/error_banner.dart';

/// Handles the 3-step flow shown in the design:
/// step 0: enter email -> send verify
/// step 1: waiting for email verification (simulated)
/// step 2: set new password -> back to login
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  int _step = 0;
  bool _obscureNew = true;
  bool _obscureRewrite = true;
  bool _showEmailError = false;
  final _emailController = TextEditingController();

  Widget _logo() => Image.asset('asset/image/Nexa_Logo.png', width: 140, fit: BoxFit.contain);

  Widget _field(String label, {bool obscure = false, VoidCallback? toggle, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: AppTextStyles.body.copyWith(fontSize: 14),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColor.Primary, width: 1.5),
            ),
            suffixIcon: toggle == null
                ? null
                : IconButton(
                    onPressed: toggle,
                    icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _button(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.Primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(label, style: AppTextStyles.button.copyWith(color: Colors.white, fontSize: 14)),
      ),
    );
  }

  Widget _stepContent() {
    switch (_step) {
      case 0:
        return Column(
          key: const ValueKey(0),
          children: [
            _logo(),
            const SizedBox(height: 30),
            if (_showEmailError)
              ErrorBanner(
                title: 'Email Not Found',
                message: "We couldn't find an account associated with that email address.",
              ),
            _field('Email', controller: _emailController),
            const SizedBox(height: 20),
            _button('Send Email Verify', () {
              if (_emailController.text.trim().isEmpty) {
                setState(() => _showEmailError = true);
                return;
              }
              setState(() {
                _showEmailError = false;
                _step = 1;
              });
            }),
          ],
        );
      case 1:
        return Column(
          key: const ValueKey(1),
          children: [
            _logo(),
            const SizedBox(height: 30),
            const Icon(Icons.mark_email_read_outlined, size: 64, color: AppColor.Primary),
            const SizedBox(height: 16),
            Text(
              'Check your inbox and tap the verification link we sent you.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 20),
            _button('I\'ve Verified, Continue', () => setState(() => _step = 2)),
          ],
        );
      case 2:
      default:
        return Column(
          key: const ValueKey(2),
          children: [
            _logo(),
            const SizedBox(height: 30),
            _field('New Password', obscure: _obscureNew, toggle: () => setState(() => _obscureNew = !_obscureNew)),
            const SizedBox(height: 14),
            _field('Rewrite Password', obscure: _obscureRewrite, toggle: () => setState(() => _obscureRewrite = !_obscureRewrite)),
            const SizedBox(height: 20),
            _button('Back To Login', () => Navigator.pop(context)),
          ],
        );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        // BACKGROUND
        Image.asset(
          'asset/image/bg_login.png',
          fit: BoxFit.cover,
        ),

        // CONTENT
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      if (_step == 0) {
                        Navigator.pop(context);
                      } else {
                        setState(() => _step -= 1);
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColor.Primary,
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _stepContent(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}