import 'package:flutter/material.dart';
import '../style/color_style.dart';
import '../style/text_style.dart';
import 'package:provider/provider.dart';
import '../core/app_config.dart';
import '../core/errors.dart';
import '../state/auth_state.dart';
import '../widgets/states/error_banner.dart';
import '../widgets/states/status_popup.dart';
import 'main_shell.dart';
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
        MaterialPageRoute(builder: (context) => const MainShell()),
      );
    } on AuthFailure {
      if (mounted) setState(() => _showLoginError = true);
    } on NetworkFailure {
      if (mounted) _showNetworkDialog();
    } on ServerFailure catch (error) {
      if (mounted) _showServerMismatchDialog(error.message);
    } catch (_) {
      if (mounted) showRefreshPageDialog(context, onRefresh: _submit);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Wi-Fi setup: the phone talks straight to the PC LAN address, so the
  /// backend can be reached without `adb reverse` over a USB cable.
  Future<void> _openServerDialog() async {
    final auth = context.read<AuthState>();
    if (!auth.canConfigureServer) return;

    final result = await showDialog<String>(
      context: context,
      builder: (_) => _ServerAddressDialog(initialHost: auth.serverBaseUrl),
    );
    if (!mounted || result == null) return;

    await auth.setServerBaseUrl(result.isEmpty ? null : result);
    if (!mounted) return;
    setState(() {});
  }

  void _showNetworkDialog() {
    final auth = context.read<AuthState>();
    final target = auth.serverBaseUrl;
    showDialog(
      context: context,
      builder: (ctx) => StatusPopup(
        title: 'Server tidak terjangkau',
        message: target == null
            ? 'Cek alamat server di menu Server, pastikan HP dan laptop '
                  'tersambung ke Wi-Fi yang sama.'
            : 'Tidak bisa menghubungi ${AppConfig.displayHost(target)}. '
                  'Pastikan backend jalan dan HP ada di Wi-Fi yang sama.',
        primaryLabel: 'Refresh',
        onPrimary: () {
          Navigator.pop(ctx);
          _submit();
        },
        secondaryLabel: auth.canConfigureServer ? 'Server' : null,
        onSecondary: auth.canConfigureServer
            ? () {
                Navigator.pop(ctx);
                _openServerDialog();
              }
            : null,
      ),
    );
  }

  void _showServerMismatchDialog(String message) {
    final auth = context.read<AuthState>();
    showDialog(
      context: context,
      builder: (ctx) => StatusPopup(
        title: 'Server tidak sesuai',
        message: message,
        primaryLabel: 'Server',
        onPrimary: () {
          Navigator.pop(ctx);
          _openServerDialog();
        },
        secondaryLabel: auth.canConfigureServer ? 'Refresh' : null,
        onSecondary: auth.canConfigureServer
            ? () {
                Navigator.pop(ctx);
                _submit();
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final savedServer = auth.serverBaseUrl;

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

                      // Server address (Wi-Fi, no USB cable needed). The
                      // address is remembered for the next launches.
                      if (auth.canConfigureServer) ...[
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _openServerDialog,
                          icon: const Icon(
                            Icons.dns_outlined,
                            size: 14,
                            color: Colors.black87,
                          ),
                          label: Text(
                            savedServer == null
                                ? 'Atur alamat server (Wi-Fi)'
                                : 'Server: ${AppConfig.displayHost(savedServer)}',
                            style: AppTextStyles.body.copyWith(
                              fontSize: 11,
                              color: Colors.black87,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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

/// Dev-only dialog that points the app at the backend running on the PC.
///
/// Returns the normalised address when saved, `''` when the user resets to the
/// built-in candidates, and `null` when cancelled.
class _ServerAddressDialog extends StatefulWidget {
  const _ServerAddressDialog({this.initialHost});

  final String? initialHost;

  @override
  State<_ServerAddressDialog> createState() => _ServerAddressDialogState();
}

class _ServerAddressDialogState extends State<_ServerAddressDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialHost == null
        ? ''
        : AppConfig.displayHost(widget.initialHost!),
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final normalized = AppConfig.normalizeBaseUrl(_controller.text);
    if (normalized == null) {
      setState(() => _error = 'Alamat tidak valid. Contoh: 192.168.1.10:3000');
      return;
    }
    Navigator.pop(context, normalized);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.Background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text(
        'Server Backend',
        style: AppTextStyles.subheading.copyWith(
          fontSize: 16,
          color: AppColor.TextPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masukkan IP komputer yang menjalankan backend. HP dan laptop '
            'harus tersambung ke Wi-Fi yang sama, jadi tidak perlu kabel USB.',
            style: AppTextStyles.body.copyWith(
              fontSize: 11,
              color: AppColor.TextBody.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            style: AppTextStyles.body.copyWith(fontSize: 13),
            decoration: InputDecoration(
              hintText: '192.168.1.10',
              helperText: 'Port 3000 otomatis dipakai kalau tidak ditulis.',
              errorText: _error,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (widget.initialHost != null)
          TextButton(
            onPressed: () => Navigator.pop(context, ''),
            child: const Text('Reset'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(backgroundColor: AppColor.Primary),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
