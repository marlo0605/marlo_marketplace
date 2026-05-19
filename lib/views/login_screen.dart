// ============================================================
// VIEW: login_screen.dart
// Layar login dengan validasi form dan navigasi ke register
// ============================================================
 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/common_widgets.dart';
import 'register_screen.dart';
 
class LoginScreen extends StatefulWidget {
  /// Jika [redirectAfterLogin] true, setelah login kembali ke layar sebelumnya
  final bool redirectAfterLogin;
  const LoginScreen({super.key, this.redirectAfterLogin = false});
 
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
 
class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
 
  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
    context.read<AuthController>().clearError();
  }
 
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
 
                // ── TOMBOL KEMBALI ────────────────────────────
                if (widget.redirectAfterLogin)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    padding: EdgeInsets.zero,
                    color: AppColors.textPrimary,
                  ),
 
                const SizedBox(height: 20),
 
                // ── LOGO & JUDUL ─────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.storefront_rounded,
                            color: Colors.white, size: 44),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Marlo Marketplace',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Masuk ke akunmu',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
 
                const SizedBox(height: 36),
 
                // ── FORM LOGIN ────────────────────────────────
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email
                      _buildLabel('Email'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'contoh@email.com',
                          prefixIcon: Icon(Icons.email_outlined,
                              color: AppColors.textHint, size: 20),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Email tidak boleh kosong';
                          if (!v.contains('@') || !v.contains('.'))
                            return 'Format email tidak valid';
                          return null;
                        },
                      ),
 
                      const SizedBox(height: 16),
 
                      // Password
                      _buildLabel('Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _doLogin(),
                        decoration: InputDecoration(
                          hintText: 'Masukkan password',
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: AppColors.textHint, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePass
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textHint,
                              size: 20,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePass = !_obscurePass),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Password tidak boleh kosong';
                          if (v.length < 6)
                            return 'Password minimal 6 karakter';
                          return null;
                        },
                      ),
 
                      const SizedBox(height: 8),
 
                      // Lupa password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero),
                          child: const Text(
                            'Lupa Password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
 
                      const SizedBox(height: 8),
 
                      // Error message
                      Consumer<AuthController>(
                        builder: (_, auth, __) {
                          if (auth.errorMessage == null) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.error.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: AppColors.error, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    auth.errorMessage!,
                                    style: const TextStyle(
                                      color: AppColors.error,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
 
                      // Tombol login
                      Consumer<AuthController>(
                        builder: (_, auth, __) => GradientButton(
                          text: 'Masuk',
                          isLoading: auth.isLoading,
                          onPressed: _doLogin,
                          icon: Icons.login_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
 
                const SizedBox(height: 24),
 
                // ── DIVIDER ───────────────────────────────────
                Row(
                  children: [
                    const Expanded(
                        child: Divider(color: AppColors.surfaceVariant)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'atau',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Expanded(
                        child: Divider(color: AppColors.surfaceVariant)),
                  ],
                ),
 
                const SizedBox(height: 20),
 
                // ── DEMO AKUN ─────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: AppColors.primary, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Akun Demo (coba langsung)',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildDemoRow('Email', 'budi@email.com'),
                      const SizedBox(height: 4),
                      _buildDemoRow('Password', 'budi123'),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            _emailCtrl.text = 'budi@email.com';
                            _passCtrl.text = 'budi123';
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                                color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Isi Otomatis'),
                        ),
                      ),
                    ],
                  ),
                ),
 
                const SizedBox(height: 32),
 
                // ── DAFTAR ────────────────────────────────────
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegisterScreen(
                              redirectAfterRegister:
                                  widget.redirectAfterLogin,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
 
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
 
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
 
  Widget _buildDemoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
              fontSize: 12, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
 
  Future<void> _doLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
 
    final auth = context.read<AuthController>();
    final ok = await auth.login(_emailCtrl.text, _passCtrl.text);
 
    if (ok && mounted) {
      if (widget.redirectAfterLogin) {
        Navigator.pop(context); // Kembali ke halaman sebelumnya (checkout)
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }
}