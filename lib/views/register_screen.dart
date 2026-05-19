// ============================================================
// VIEW: register_screen.dart
// Layar registrasi akun baru dengan validasi lengkap
// ============================================================
 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/common_widgets.dart';
 
class RegisterScreen extends StatefulWidget {
  final bool redirectAfterRegister;
  const RegisterScreen({super.key, this.redirectAfterRegister = false});
 
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
 
class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
 
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = false;
 
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
 
  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
    context.read<AuthController>().clearError();
  }
 
  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
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
 
                // ── HEADER ────────────────────────────────────
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      padding: EdgeInsets.zero,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Buat Akun Baru',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
 
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 46),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.storefront_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Bergabung dengan Marlo Marketplace',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
 
                const SizedBox(height: 28),
 
                // ── BONUS POIN BANNER ─────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.card_giftcard,
                          color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonus 100 Poin Loyalitas!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Untuk setiap anggota baru',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
 
                const SizedBox(height: 24),
 
                // ── FORM REGISTRASI ───────────────────────────
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Lengkap
                      _buildLabel('Nama Lengkap'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameCtrl,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Nama lengkap sesuai KTP',
                          prefixIcon: Icon(Icons.person_outline,
                              color: AppColors.textHint, size: 20),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Nama tidak boleh kosong';
                          if (v.trim().length < 3)
                            return 'Nama minimal 3 karakter';
                          return null;
                        },
                      ),
 
                      const SizedBox(height: 14),
 
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
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(v))
                            return 'Format email tidak valid';
                          return null;
                        },
                      ),
 
                      const SizedBox(height: 14),
 
                      // Nomor HP
                      _buildLabel('Nomor HP / WhatsApp'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: '081234567890',
                          prefixIcon: Icon(Icons.phone_outlined,
                              color: AppColors.textHint, size: 20),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Nomor HP tidak boleh kosong';
                          if (v.length < 10 || v.length > 13)
                            return 'Nomor HP tidak valid (10-13 digit)';
                          if (!RegExp(r'^[0-9]+$').hasMatch(v))
                            return 'Hanya boleh angka';
                          return null;
                        },
                      ),
 
                      const SizedBox(height: 14),
 
                      // Password
                      _buildLabel('Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Minimal 6 karakter',
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
                            onPressed: () => setState(
                                () => _obscurePass = !_obscurePass),
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
 
                      const SizedBox(height: 14),
 
                      // Konfirmasi Password
                      _buildLabel('Konfirmasi Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _confirmPassCtrl,
                        obscureText: _obscureConfirm,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _doRegister(),
                        decoration: InputDecoration(
                          hintText: 'Ulangi password',
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: AppColors.textHint, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textHint,
                              size: 20,
                            ),
                            onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Konfirmasi password tidak boleh kosong';
                          if (v != _passCtrl.text)
                            return 'Password tidak sama';
                          return null;
                        },
                      ),
 
                      const SizedBox(height: 16),
 
                      // Syarat & Ketentuan
                      GestureDetector(
                        onTap: () =>
                            setState(() => _agreeTerms = !_agreeTerms),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: _agreeTerms
                                    ? AppColors.primary
                                    : Colors.transparent,
                                border: Border.all(
                                  color: _agreeTerms
                                      ? AppColors.primary
                                      : AppColors.textHint,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: _agreeTerms
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 14)
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                  children: [
                                    TextSpan(text: 'Saya menyetujui '),
                                    TextSpan(
                                      text: 'Syarat & Ketentuan',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(text: ' dan '),
                                    TextSpan(
                                      text: 'Kebijakan Privasi',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                        text: ' Marlo Marketplace'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
 
                      const SizedBox(height: 20),
 
                      // Error message
                      Consumer<AuthController>(
                        builder: (_, auth, __) {
                          if (auth.errorMessage == null)
                            return const SizedBox.shrink();
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color:
                                      AppColors.error.withOpacity(0.3)),
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
 
                      // Tombol daftar
                      Consumer<AuthController>(
                        builder: (_, auth, __) => GradientButton(
                          text: 'Buat Akun',
                          isLoading: auth.isLoading,
                          onPressed: _doRegister,
                          icon: Icons.person_add_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
 
                const SizedBox(height: 24),
 
                // ── SUDAH PUNYA AKUN ──────────────────────────
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun? ',
                        style:
                            TextStyle(color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Masuk di sini',
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
 
  Future<void> _doRegister() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
 
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Harap setujui syarat & ketentuan terlebih dahulu'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
 
    final auth = context.read<AuthController>();
    final ok = await auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      phone: _phoneCtrl.text.trim(),
    );
 
    if (ok && mounted) {
      // Tampilkan pesan selamat datang
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Selamat datang, ${_nameCtrl.text.split(' ').first}! 🎉'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
 
      if (widget.redirectAfterRegister) {
        // Kembali 2 layar: register → login → checkout
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', (route) => false);
      }
    }
  }
}
 