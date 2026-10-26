import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import 'package:provider/provider.dart';
import '../core/errors.dart';
import '../state/auth_state.dart';
import '../widgets/states/error_banner.dart';
import '../widgets/states/status_popup.dart';
import 'dashboard.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _loading = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showLoginError = false;

  @override
  void initState() {
    super.initState();
    // "Remember me" is a plain setting (shared_preferences).
    _rememberMe = context.read<AuthState>().rememberMe;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nim = _usernameController.text.trim();
    final password = _passwordController.text;
    if (nim.isEmpty || password.isEmpty) {
      setState(() => _showLoginError = true);
      return;
    }

    setState(() {
      _loading = true;
      _showLoginError = false;
    });

    try {
      // Tokens go to flutter_secure_storage inside AuthState.login().
      await context.read<AuthState>().login(
            nim: nim,
            password: password,
            rememberMe: _rememberMe,
          );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } on AuthFailure {
      if (mounted) setState(() => _showLoginError = true);
    } on NetworkFailure {
      if (mounted) showServerBusyDialog(context, onRefresh: _submit);
    } catch (_) {
      if (mounted) showRefreshPageDialog(context, onRefresh: _submit);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // BACKGROUND HALAMAN
          Image.asset(
            'asset/image/bg_login.png',
            fit: BoxFit.cover,
          ),

          // CONTENT LOGIN
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      40,
                ),
                child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),

                      // LOGO
                      Image.asset(
                        'asset/image/Nexa_Logo.png',
                        width: 170,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 30),

                      if (_showLoginError)
                        ErrorBanner(
                          title: 'Login Failed',
                          message: 'Invalid Student ID or Password. Please try again.',
                        ),

                      // USERNAME
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'NIM / Username',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // USERNAME FIELD
                      TextField(
                        controller: _usernameController,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: AppColor.Primary,
                              width: 1.5,
                            ),
                          ),
                          suffixIcon: const Icon(
                            Icons.person_outline,
                            size: 18,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // PASSWORD
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // PASSWORD FIELD
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: AppColor.Primary,
                              width: 1.5,
                            ),
                          ),
                          suffixIcon: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 18,
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // REMEMBER + FORGOT PASSWORD
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  activeColor: AppColor.Primary,
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Remember me',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.Primary,
                            disabledBackgroundColor: AppColor.Primary,
                            foregroundColor: AppColor.TextSecondary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColor.TextSecondary,
                                  ),
                                )
                              : Text(
                                  'LOGIN',
                                  style: AppTextStyles.button.copyWith(
                                    fontSize: 15,
                                    color: AppColor.TextSecondary,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
