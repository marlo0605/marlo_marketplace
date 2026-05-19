// // ============================================================
// // VIEW: profile_screen.dart
// // Layar profil, kelola alamat, dan logout
// // ============================================================
 
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../constants/app_theme.dart';
// import '../../controllers/auth_controller.dart';
// import '../../controllers/transaction_controller.dart';
// import '../../utils/formatter.dart';
// import '../widgets/common_widgets.dart';
// import 'add_address_screen.dart';
// import 'login_screen.dart';
 
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
 
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthController>(
//       builder: (_, auth, __) {
//         if (!auth.isAuthenticated) {
//           return _buildGuestView(context);
//         }
//         return _buildProfileView(context, auth);
//       },
//     );
//   }
 
//   // ── TAMPILAN TAMU (BELUM LOGIN) ────────────────────────────
//   Widget _buildGuestView(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Profil'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryLight,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.person_outline,
//                     size: 50, color: AppColors.primary),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Kamu Belum Masuk',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Masuk untuk melihat profil, pesanan, dan kelola alamat pengirimanmu',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: AppColors.textSecondary,
//                   height: 1.5,
//                 ),
//               ),
//               const SizedBox(height: 32),
//               GradientButton(
//                 text: 'Masuk Sekarang',
//                 icon: Icons.login_rounded,
//                 onPressed: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const LoginScreen()),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
 
//   // ── TAMPILAN PROFIL (SUDAH LOGIN) ──────────────────────────
//   Widget _buildProfileView(BuildContext context, AuthController auth) {
//     final user = auth.user!;
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: CustomScrollView(
//         slivers: [
//           // ── HEADER PROFIL ───────────────────────────────────
//           SliverAppBar(
//             expandedHeight: 200,
//             pinned: true,
//             automaticallyImplyLeading: false,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 decoration: const BoxDecoration(
//                   gradient: AppColors.primaryGradient,
//                 ),
//                 child: SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Row(
//                           children: [
//                             // Avatar
//                             Container(
//                               width: 64,
//                               height: 64,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.2),
//                                     blurRadius: 10,
//                                   )
//                                 ],
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   user.name.isNotEmpty
//                                       ? user.name[0].toUpperCase()
//                                       : '?',
//                                   style: const TextStyle(
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.w800,
//                                     color: AppColors.primary,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     user.name,
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     user.email,
//                                     style: const TextStyle(
//                                       color: Colors.white70,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     user.phone,
//                                     style: const TextStyle(
//                                       color: Colors.white70,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         // Poin Loyalitas
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 14, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.stars_rounded,
//                                   color: AppColors.accent, size: 18),
//                               const SizedBox(width: 6),
//                               Text(
//                                 '${Formatter.number(user.loyaltyPoints)} Poin Loyalitas',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
 
//           // ── KONTEN ─────────────────────────────────────────
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ── STATISTIK ─────────────────────────────
//                   Consumer<TransactionController>(
//                     builder: (_, txCtrl, __) => Row(
//                       children: [
//                         _buildStatCard(
//                           '${txCtrl.transactions.length}',
//                           'Total Pesanan',
//                           Icons.shopping_bag_outlined,
//                           AppColors.primary,
//                         ),
//                         const SizedBox(width: 10),
//                         _buildStatCard(
//                           '${txCtrl.completedTransactions.length}',
//                           'Selesai',
//                           Icons.check_circle_outline,
//                           AppColors.success,
//                         ),
//                         const SizedBox(width: 10),
//                         _buildStatCard(
//                           Formatter.currencyShort(txCtrl.totalSpending),
//                           'Total Belanja',
//                           Icons.wallet_outlined,
//                           AppColors.info,
//                         ),
//                       ],
//                     ),
//                   ),
 
//                   const SizedBox(height: 20),
 
//                   // ── ALAMAT PENGIRIMAN ─────────────────────
//                   _buildSectionTitle('Alamat Pengiriman'),
//                   const SizedBox(height: 10),
//                   _buildAddressSection(context, auth),
 
//                   const SizedBox(height: 20),
 
//                   // ── MENU LAINNYA ──────────────────────────
//                   _buildSectionTitle('Pengaturan'),
//                   const SizedBox(height: 10),
//                   _buildMenuCard([
//                     _buildMenuItem(Icons.notifications_outlined,
//                         'Notifikasi', 'Atur preferensi notifikasi', null),
//                     _buildMenuItem(Icons.security_outlined,
//                         'Keamanan Akun', 'Ubah password & PIN', null),
//                     _buildMenuItem(Icons.help_outline,
//                         'Bantuan & FAQ', 'Pusat bantuan Marlo', null),
//                     _buildMenuItem(Icons.info_outline,
//                         'Tentang Aplikasi', 'Versi 1.0.0', null),
//                   ]),
 
//                   const SizedBox(height: 16),
 
//                   // ── LOGOUT ────────────────────────────────
//                   GestureDetector(
//                     onTap: () => _showLogoutDialog(context, auth),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                             color: AppColors.error.withOpacity(0.3)),
//                       ),
//                       child: const Row(
//                         children: [
//                           Icon(Icons.logout_rounded,
//                               color: AppColors.error, size: 22),
//                           SizedBox(width: 12),
//                           Text(
//                             'Keluar dari Akun',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.error,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
 
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
 
//   // ── STATISTIK CARD ─────────────────────────────────────────
//   Widget _buildStatCard(
//       String value, String label, IconData icon, Color color) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 22),
//             const SizedBox(height: 6),
//             Text(
//               value,
//               style: TextStyle(
//                 fontWeight: FontWeight.w800,
//                 fontSize: 16,
//                 color: color,
//               ),
//             ),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 11,
//                 color: AppColors.textHint,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
 
//   // ── SECTION ALAMAT ─────────────────────────────────────────
//   Widget _buildAddressSection(BuildContext context, AuthController auth) {
//     final addresses = auth.user?.addresses ?? [];
//     return Column(
//       children: [
//         ...addresses.map((addr) => Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(
//                   color: addr.isDefault
//                       ? AppColors.primary.withOpacity(0.4)
//                       : Colors.transparent,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryLight,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(Icons.location_on,
//                         color: AppColors.primary, size: 20),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               addr.label,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             if (addr.isDefault) ...[
//                               const SizedBox(width: 6),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 6, vertical: 2),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.primary,
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: const Text(
//                                   'Utama',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           addr.recipientName,
//                           style: const TextStyle(
//                             color: AppColors.textSecondary,
//                             fontSize: 13,
//                           ),
//                         ),
//                         Text(
//                           addr.phone,
//                           style: const TextStyle(
//                             color: AppColors.textSecondary,
//                             fontSize: 13,
//                           ),
//                         ),
//                         Text(
//                           addr.fullAddress,
//                           style: const TextStyle(
//                             color: AppColors.textHint,
//                             fontSize: 12,
//                             height: 1.4,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             if (!addr.isDefault)
//                               GestureDetector(
//                                 onTap: () =>
//                                     auth.setDefaultAddress(addr.id),
//                                 child: const Text(
//                                   'Jadikan Utama',
//                                   style: TextStyle(
//                                     color: AppColors.primary,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             if (!addr.isDefault) const SizedBox(width: 12),
//                             GestureDetector(
//                               onTap: () => auth.removeAddress(addr.id),
//                               child: const Text(
//                                 'Hapus',
//                                 style: TextStyle(
//                                   color: AppColors.error,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )),
 
//         // Tombol tambah alamat
//         GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => const AddAddressScreen()),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(
//                 color: AppColors.primary.withOpacity(0.3),
//                 style: BorderStyle.solid,
//               ),
//             ),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.add_location_alt_outlined,
//                     color: AppColors.primary, size: 20),
//                 SizedBox(width: 8),
//                 Text(
//                   'Tambah Alamat Baru',
//                   style: TextStyle(
//                     color: AppColors.primary,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
 
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 15,
//         fontWeight: FontWeight.w700,
//         color: AppColors.textPrimary,
//       ),
//     );
//   }
 
//   Widget _buildMenuCard(List<Widget> items) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(children: items),
//     );
//   }
 
//   Widget _buildMenuItem(
//       IconData icon, String title, String subtitle, VoidCallback? onTap) {
//     return ListTile(
//       leading: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: AppColors.surfaceVariant,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(icon, color: AppColors.textSecondary, size: 20),
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 14,
//           color: AppColors.textPrimary,
//         ),
//       ),
//       subtitle: Text(
//         subtitle,
//         style:
//             const TextStyle(fontSize: 12, color: AppColors.textHint),
//       ),
//       trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
//       onTap: onTap,
//     );
//   }
 
//   void _showLogoutDialog(BuildContext context, AuthController auth) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text('Keluar dari Akun?'),
//         content:
//             const Text('Kamu akan keluar dari Marlo Marketplace.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Batal'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.error,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//             ),
//             onPressed: () {
//               auth.logout();
//               Navigator.pop(context);
//             },
//             child: const Text('Keluar'),
//           ),
//         ],
//       ),
//     );
//   }
// }



// ============================================================
// VIEW: profile_screen.dart
// Layar profil pengguna, alamat, statistik, dan logout
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/transaction_controller.dart';
import '../../utils/formatter.dart';

import '../widgets/common_widgets.dart';

import 'login_screen.dart';
import 'add_address_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (_, auth, __) {

        // Jika belum login
        if (!auth.isAuthenticated) {
          return _buildGuestView(context);
        }

        // Jika sudah login
        return _buildProfileView(context, auth);
      },
    );
  }

  // ============================================================
  // GUEST VIEW
  // ============================================================

  Widget _buildGuestView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profil'),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              // ICON
              Container(
                width: 100,
                height: 100,

                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.person_outline,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 20),

              // TITLE
              const Text(
                'Kamu Belum Login',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              // SUBTITLE
              const Text(
                'Masuk untuk melihat profil, alamat, dan pesananmu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // BUTTON LOGIN
              GradientButton(
                text: 'Masuk Sekarang',
                icon: Icons.login_rounded,

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE VIEW
  // ============================================================

  Widget _buildProfileView(
    BuildContext context,
    AuthController auth,
  ) {

    final user = auth.user!;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: CustomScrollView(
        slivers: [

          // ====================================================
          // HEADER
          // ====================================================

          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            automaticallyImplyLeading: false,

            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),

                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      mainAxisAlignment:
                          MainAxisAlignment.end,

                      children: [

                        // USER INFO
                        Row(
                          children: [

                            // AVATAR
                            Container(
                              width: 70,
                              height: 70,

                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.2),

                                    blurRadius: 10,
                                  ),
                                ],
                              ),

                              child: Center(
                                child: Text(
                                  user.name.isNotEmpty
                                      ? user.name[0]
                                          .toUpperCase()
                                      : '?',

                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight:
                                        FontWeight.w800,
                                    color:
                                        AppColors.primary,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // USER DATA
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  Text(
                                    user.name,

                                    style:
                                        const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    user.email,

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(height: 2),

                                  Text(
                                    user.phone,

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // LOYALTY POINT
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),

                          decoration: BoxDecoration(
                            color:
                                Colors.white.withOpacity(0.2),

                            borderRadius:
                                BorderRadius.circular(20),
                          ),

                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [

                              const Icon(
                                Icons.stars_rounded,
                                color: AppColors.accent,
                                size: 18,
                              ),

                              const SizedBox(width: 6),

                              Text(
                                '${Formatter.number(user.loyaltyPoints)} Poin',

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ====================================================
          // CONTENT
          // ====================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // =================================================
                  // STATISTIC
                  // =================================================

                  Consumer<TransactionController>(
                    builder: (_, tx, __) {

                      return Row(
                        children: [

                          _buildStatCard(
                            '${tx.transactions.length}',
                            'Pesanan',
                            Icons.shopping_bag_outlined,
                            AppColors.primary,
                          ),

                          const SizedBox(width: 10),

                          _buildStatCard(
                            '${tx.completedTransactions.length}',
                            'Selesai',
                            Icons.check_circle_outline,
                            AppColors.success,
                          ),

                          const SizedBox(width: 10),

                          _buildStatCard(
                            Formatter.currencyShort(
                              tx.totalSpending,
                            ),
                            'Belanja',
                            Icons.wallet_outlined,
                            AppColors.info,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // ADDRESS
                  // =================================================

                  _buildSectionTitle(
                    'Alamat Pengiriman',
                  ),

                  const SizedBox(height: 10),

                  _buildAddressSection(
                    context,
                    auth,
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // SETTINGS
                  // =================================================

                  _buildSectionTitle('Pengaturan'),

                  const SizedBox(height: 10),

                  _buildMenuCard([

                    _buildMenuItem(
                      Icons.person_outline,
                      'Edit Profil',
                      'Ubah nama dan nomor telepon',
                      () {},
                    ),

                    _buildMenuItem(
                      Icons.notifications_outlined,
                      'Notifikasi',
                      'Pengaturan notifikasi',
                      () {},
                    ),

                    _buildMenuItem(
                      Icons.security_outlined,
                      'Keamanan Akun',
                      'Password dan keamanan',
                      () {},
                    ),

                    _buildMenuItem(
                      Icons.help_outline,
                      'Bantuan',
                      'Pusat bantuan aplikasi',
                      () {},
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // =================================================
                  // LOGOUT
                  // =================================================

                  GestureDetector(
                    onTap: () {
                      _showLogoutDialog(
                        context,
                        auth,
                      );
                    },

                    child: Container(
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(16),

                        border: Border.all(
                          color: AppColors.error
                              .withOpacity(0.3),
                        ),
                      ),

                      child: const Row(
                        children: [

                          Icon(
                            Icons.logout_rounded,
                            color: AppColors.error,
                          ),

                          SizedBox(width: 12),

                          Text(
                            'Keluar dari Akun',

                            style: TextStyle(
                              color: AppColors.error,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(14),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
            ),
          ],
        ),

        child: Column(
          children: [

            Icon(
              icon,
              color: color,
            ),

            const SizedBox(height: 8),

            Text(
              value,

              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: color,
              ),
            ),

            Text(
              label,

              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ADDRESS SECTION
  // ============================================================

  Widget _buildAddressSection(
    BuildContext context,
    AuthController auth,
  ) {

    final addresses =
        auth.user?.addresses ?? [];

    return Column(
      children: [

        // JIKA KOSONG
        if (addresses.isEmpty)

          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(14),
            ),

            child: const Column(
              children: [

                Icon(
                  Icons.location_off_outlined,
                  size: 40,
                  color: AppColors.textHint,
                ),

                SizedBox(height: 10),

                Text(
                  'Belum ada alamat',
                ),
              ],
            ),
          ),

        // LIST ADDRESS
        ...addresses.map((addr) {

          return Container(
            margin:
                const EdgeInsets.only(bottom: 10),

            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(14),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  addr.label,

                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(addr.recipientName),

                Text(addr.phone),

                Text(addr.fullAddress),

                const SizedBox(height: 10),

                Row(
                  children: [

                    if (!addr.isDefault)

                      GestureDetector(
                        onTap: () {
                          auth.setDefaultAddress(
                            addr.id,
                          );
                        },

                        child: const Text(
                          'Jadikan Utama',

                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),

                    const SizedBox(width: 16),

                    GestureDetector(
                      onTap: () {
                        auth.removeAddress(
                          addr.id,
                        );
                      },

                      child: const Text(
                        'Hapus',

                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),

        // BUTTON TAMBAH ALAMAT
        GestureDetector(
          onTap: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const AddAddressScreen(),
              ),
            );
          },

          child: Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(14),

              border: Border.all(
                color: AppColors.primary
                    .withOpacity(0.3),
              ),
            ),

            child: const Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Icon(
                  Icons.add_location_alt_outlined,
                  color: AppColors.primary,
                ),

                SizedBox(width: 8),

                Text(
                  'Tambah Alamat Baru',

                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title) {

    return Text(
      title,

      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ============================================================
  // MENU CARD
  // ============================================================

  Widget _buildMenuCard(
    List<Widget> items,
  ) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        children: items,
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap,
  ) {

    return ListTile(

      leading: Icon(icon),

      title: Text(
        title,
      ),

      subtitle: Text(
        subtitle,
      ),

      trailing: const Icon(
        Icons.chevron_right,
      ),

      onTap: onTap,
    );
  }

  // ============================================================
  // LOGOUT DIALOG
  // ============================================================

  void _showLogoutDialog(
    BuildContext context,
    AuthController auth,
  ) {

    showDialog(
      context: context,

      builder: (_) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          title: const Text(
            'Keluar dari akun?',
          ),

          content: const Text(
            'Kamu akan logout dari aplikasi.',
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Batal'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.error,
              ),

              onPressed: () {

                auth.logout();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const LoginScreen(),
                  ),
                  (route) => false,
                );
              },

              child: const Text(
                'Keluar',
              ),
            ),
          ],
        );
      },
    );
  }
}

