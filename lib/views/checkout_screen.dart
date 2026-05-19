// // ============================================================
// // VIEW: checkout_screen.dart
// // Layar checkout: alamat, pembayaran, konfirmasi pesanan
// // ============================================================
 
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../constants/app_theme.dart';
// import '../controllers/cart_controller.dart';
// import '../controllers/transaction_controller.dart';
// import '../controllers/user_controller.dart';
// import '../models/transaction_model.dart';
// import '../models/user_model.dart';
// import '../utils/formatter.dart';
// import '../widgets/common_widgets.dart';
// import 'transaction_success_screen.dart';
 
// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});
 
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
 
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   PaymentMethod _selectedPayment = PaymentMethod.bankTransfer;
//   AddressModel? _selectedAddress;
 
//   final List<Map<String, dynamic>> _paymentMethods = [
//     {
//       'method': PaymentMethod.bankTransfer,
//       'label': 'Transfer Bank',
//       'sublabel': 'BCA, Mandiri, BNI, BRI',
//       'icon': Icons.account_balance,
//       'color': const Color(0xFF3B82F6),
//     },
//     {
//       'method': PaymentMethod.eWallet,
//       'label': 'E-Wallet',
//       'sublabel': 'GoPay, OVO, Dana, ShopeePay',
//       'icon': Icons.account_balance_wallet,
//       'color': const Color(0xFF10B981),
//     },
//     {
//       'method': PaymentMethod.creditCard,
//       'label': 'Kartu Kredit / Debit',
//       'sublabel': 'Visa, Mastercard, JCB',
//       'icon': Icons.credit_card,
//       'color': const Color(0xFF8B5CF6),
//     },
//     {
//       'method': PaymentMethod.cashOnDelivery,
//       'label': 'Bayar di Tempat (COD)',
//       'sublabel': 'Bayar saat paket tiba',
//       'icon': Icons.money,
//       'color': const Color(0xFFF59E0B),
//     },
//   ];
 
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final user = context.read<UserController>().user;
//       setState(() => _selectedAddress = user?.defaultAddress);
//     });
//   }
 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         centerTitle: true,
//       ),
//       body: Consumer3<CartController, UserController, TransactionController>(
//         builder: (_, cart, userCtrl, txCtrl, __) {
//           final selectedItems = cart.selectedItems;
//           if (selectedItems.isEmpty) {
//             return const Center(child: Text('Tidak ada item yang dipilih'));
//           }
 
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView(
//                   padding: const EdgeInsets.all(16),
//                   children: [
//                     // ── ALAMAT PENGIRIMAN ──────────────────────────
//                     _buildSectionTitle(
//                         'Alamat Pengiriman', Icons.location_on),
//                     const SizedBox(height: 10),
//                     _buildAddressSelector(userCtrl),
 
//                     const SizedBox(height: 16),
 
//                     // ── PRODUK YANG DIPESAN ────────────────────────
//                     _buildSectionTitle(
//                         'Produk Dipesan', Icons.shopping_bag_outlined),
//                     const SizedBox(height: 10),
//                     _buildOrderItems(selectedItems),
 
//                     const SizedBox(height: 16),
 
//                     // ── METODE PENGIRIMAN ──────────────────────────
//                     _buildSectionTitle(
//                         'Metode Pengiriman', Icons.local_shipping_outlined),
//                     const SizedBox(height: 10),
//                     _buildShippingMethod(cart),
 
//                     const SizedBox(height: 16),
 
//                     // ── METODE PEMBAYARAN ──────────────────────────
//                     _buildSectionTitle(
//                         'Metode Pembayaran', Icons.payment),
//                     const SizedBox(height: 10),
//                     ..._paymentMethods.map(
//                         (method) => _buildPaymentOption(method)),
 
//                     const SizedBox(height: 16),
 
//                     // ── RINGKASAN PEMBAYARAN ───────────────────────
//                     _buildSectionTitle(
//                         'Ringkasan Pembayaran', Icons.receipt_long_outlined),
//                     const SizedBox(height: 10),
//                     _buildPaymentSummary(cart),
 
//                     const SizedBox(height: 100),
//                   ],
//                 ),
//               ),
 
//               // ── TOMBOL BAYAR ────────────────────────────────────
//               _buildPayButton(cart, userCtrl, txCtrl),
//             ],
//           );
//         },
//       ),
//     );
//   }
 
//   Widget _buildSectionTitle(String title, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: AppColors.primary),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w700,
//             color: AppColors.textPrimary,
//           ),
//         ),
//       ],
//     );
//   }
 
//   // ── PILIH ALAMAT ──────────────────────────────────────────
//   Widget _buildAddressSelector(UserController userCtrl) {
//     final user = userCtrl.user;
//     final addresses = user?.addresses ?? [];
 
//     if (addresses.isEmpty) {
//       return _buildCard(
//         child: const Row(
//           children: [
//             Icon(Icons.add, color: AppColors.primary),
//             SizedBox(width: 8),
//             Text('Tambah Alamat Pengiriman'),
//           ],
//         ),
//       );
//     }
 
//     return _buildCard(
//       child: Column(
//         children: [
//           ...addresses.map((addr) => RadioListTile<AddressModel>(
//                 value: addr,
//                 groupValue: _selectedAddress,
//                 onChanged: (v) => setState(() => _selectedAddress = v),
//                 activeColor: AppColors.primary,
//                 contentPadding: EdgeInsets.zero,
//                 title: Row(
//                   children: [
//                     Text(
//                       addr.label,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     if (addr.isDefault) ...[
//                       const SizedBox(width: 6),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryLight,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: const Text(
//                           'Utama',
//                           style: TextStyle(
//                             color: AppColors.primary,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(addr.recipientName),
//                     Text(
//                       addr.fullAddress,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: AppColors.textHint,
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
 
//   // ── ITEM PESANAN ──────────────────────────────────────────
//   Widget _buildOrderItems(List selectedItems) {
//     return _buildCard(
//       child: Column(
//         children: selectedItems.map<Widget>((item) => Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   item.product.imageUrl,
//                   width: 60,
//                   height: 60,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     width: 60,
//                     height: 60,
//                     color: AppColors.surfaceVariant,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item.product.name,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 13,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'x${item.quantity}',
//                           style: const TextStyle(
//                             color: AppColors.textHint,
//                             fontSize: 12,
//                           ),
//                         ),
//                         Text(
//                           Formatter.currency(item.totalPrice),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         )).toList(),
//       ),
//     );
//   }
 
//   // ── METODE PENGIRIMAN ─────────────────────────────────────
//   Widget _buildShippingMethod(CartController cart) {
//     return _buildCard(
//       child: Column(
//         children: [
//           _buildShippingRow(
//               'JNE Regular', '3-5 hari', cart.shippingFee),
//           const Divider(),
//           _buildShippingRow('SiCepat', '2-3 hari', cart.shippingFee + 5000),
//           const Divider(),
//           _buildShippingRow('J&T Express', '3-4 hari', cart.shippingFee + 3000),
//         ],
//       ),
//     );
//   }
 
//   Widget _buildShippingRow(String name, String duration, double fee) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           const Icon(Icons.local_shipping_outlined,
//               size: 20, color: AppColors.textHint),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name,
//                     style: const TextStyle(fontWeight: FontWeight.w600)),
//                 Text(duration,
//                     style: const TextStyle(
//                         fontSize: 12, color: AppColors.textHint)),
//               ],
//             ),
//           ),
//           Text(
//             fee == 0 ? 'GRATIS' : Formatter.currency(fee),
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               color: fee == 0 ? AppColors.success : AppColors.textPrimary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
 
//   // ── OPSI PEMBAYARAN ───────────────────────────────────────
//   Widget _buildPaymentOption(Map<String, dynamic> method) {
//     final isSelected = _selectedPayment == method['method'];
//     return GestureDetector(
//       onTap: () => setState(() => _selectedPayment = method['method']),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.primaryLight : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppColors.primary : Colors.transparent,
//             width: 1.5,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: (method['color'] as Color).withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(method['icon'] as IconData,
//                   color: method['color'] as Color, size: 22),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     method['label'],
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: isSelected
//                           ? AppColors.primary
//                           : AppColors.textPrimary,
//                     ),
//                   ),
//                   Text(
//                     method['sublabel'],
//                     style: const TextStyle(
//                         fontSize: 12, color: AppColors.textHint),
//                   ),
//                 ],
//               ),
//             ),
//             if (isSelected)
//               const Icon(Icons.check_circle,
//                   color: AppColors.primary, size: 22),
//           ],
//         ),
//       ),
//     );
//   }
 
//   // ── RINGKASAN PEMBAYARAN ──────────────────────────────────
//   Widget _buildPaymentSummary(CartController cart) {
//     return _buildCard(
//       child: Column(
//         children: [
//           _buildSummaryRow('Subtotal', Formatter.currency(cart.subtotal)),
//           const SizedBox(height: 8),
//           _buildSummaryRow(
//             'Ongkos Kirim',
//             cart.shippingFee == 0
//                 ? 'GRATIS'
//                 : Formatter.currency(cart.shippingFee),
//             valueColor: cart.shippingFee == 0 ? AppColors.success : null,
//           ),
//           if (cart.voucherDiscount > 0) ...[
//             const SizedBox(height: 8),
//             _buildSummaryRow(
//               'Voucher',
//               '-${Formatter.currency(cart.voucherDiscount)}',
//               valueColor: AppColors.success,
//             ),
//           ],
//           const SizedBox(height: 12),
//           const Divider(),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Total Pembayaran',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16,
//                 ),
//               ),
//               Text(
//                 Formatter.currency(cart.total),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w800,
//                   fontSize: 20,
//                   color: AppColors.primary,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
 
//   Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label,
//             style: const TextStyle(color: AppColors.textSecondary)),
//         Text(
//           value,
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             color: valueColor ?? AppColors.textPrimary,
//           ),
//         ),
//       ],
//     );
//   }
 
//   Widget _buildCard({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
 
//   // ── TOMBOL BAYAR ──────────────────────────────────────────
//   Widget _buildPayButton(
//     CartController cart,
//     UserController userCtrl,
//     TransactionController txCtrl,
//   ) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 16,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Total yang dibayar:',
//                 style: TextStyle(color: AppColors.textSecondary),
//               ),
//               Text(
//                 Formatter.currency(cart.total),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w800,
//                   fontSize: 18,
//                   color: AppColors.primary,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           GradientButton(
//             text: 'Bayar Sekarang',
//             icon: Icons.lock_outline,
//             isLoading: txCtrl.isProcessing,
//             onPressed: () => _processPayment(cart, userCtrl, txCtrl),
//           ),
//         ],
//       ),
//     );
//   }
 
//   Future<void> _processPayment(
//     CartController cart,
//     UserController userCtrl,
//     TransactionController txCtrl,
//   ) async {
//     if (_selectedAddress == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Pilih alamat pengiriman terlebih dahulu'),
//           backgroundColor: AppColors.error,
//         ),
//       );
//       return;
//     }
 
//     final transaction = await txCtrl.createTransaction(
//       items: cart.selectedItems,
//       address: _selectedAddress!,
//       paymentMethod: _selectedPayment,
//       subtotal: cart.subtotal,
//       shippingFee: cart.shippingFee,
//       discount: cart.voucherDiscount,
//     );
 
//     if (transaction != null && mounted) {
//       // Tambah poin loyalitas (1 poin per Rp1000)
//       userCtrl.addLoyaltyPoints((cart.total / 1000).floor());
 
//       // Hapus item yang sudah dibayar dari keranjang
//       cart.clearSelectedItems();
 
//       // Navigasi ke halaman sukses
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) =>
//               TransactionSuccessScreen(transaction: transaction),
//         ),
//       );
//     }
//   }
// }

// ============================================================
// VIEW: checkout_screen.dart  (UPDATED — wajib login)
// Redirect ke login jika belum autentikasi
// ============================================================
 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction_model.dart';
import '../../models/user_model.dart';
import '../../utils/formatter.dart';
import '../widgets/common_widgets.dart';
import 'add_address_screen.dart';
import 'login_screen.dart';
import 'transaction_success_screen.dart';
 
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
 
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}
 
class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedPayment = PaymentMethod.bankTransfer;
  AddressModel? _selectedAddress;
  String _selectedShipping = 'JNE Regular';
 
  final Map<String, double> _shippingOptions = {
    'JNE Regular': 0,
    'SiCepat': 5000,
    'J&T Express': 3000,
    'AnterAja': 2000,
  };
 
  final List<Map<String, dynamic>> _paymentMethods = [
    {'method': PaymentMethod.bankTransfer, 'label': 'Transfer Bank', 'sublabel': 'BCA, Mandiri, BNI, BRI', 'icon': Icons.account_balance, 'color': Color(0xFF3B82F6)},
    {'method': PaymentMethod.eWallet, 'label': 'E-Wallet', 'sublabel': 'GoPay, OVO, Dana, ShopeePay', 'icon': Icons.account_balance_wallet, 'color': Color(0xFF10B981)},
    {'method': PaymentMethod.creditCard, 'label': 'Kartu Kredit / Debit', 'sublabel': 'Visa, Mastercard, JCB', 'icon': Icons.credit_card, 'color': Color(0xFF8B5CF6)},
    {'method': PaymentMethod.cashOnDelivery, 'label': 'Bayar di Tempat (COD)', 'sublabel': 'Bayar saat paket tiba', 'icon': Icons.money, 'color': Color(0xFFF59E0B)},
  ];
 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthController>();
      if (auth.isAuthenticated && auth.user?.defaultAddress != null) {
        setState(() => _selectedAddress = auth.user!.defaultAddress);
      }
    });
  }
 
  double _calcShipping(double subtotal) {
    final base = subtotal >= 200000 ? 0.0 : 25000.0;
    return base + (_shippingOptions[_selectedShipping] ?? 0);
  }
 
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (_, auth, __) {
        if (!auth.isAuthenticated) return _buildLoginRequired();
        return _buildCheckoutView(auth);
      },
    );
  }
 
  // ── WAJIB LOGIN ────────────────────────────────────────────
  Widget _buildLoginRequired() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))],
              ),
              child: const Icon(Icons.lock_person_rounded, color: Colors.white, size: 64),
            ),
            const SizedBox(height: 28),
            const Text('Login Dulu, Yuk!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            const Text(
              'Kamu perlu masuk ke akun untuk melanjutkan checkout dan melacak pesananmu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 28),
            ...[
              [Icons.local_shipping_outlined, 'Lacak status pengirimanmu'],
              [Icons.history, 'Lihat riwayat pesanan'],
              [Icons.stars_rounded, 'Kumpulkan poin loyalitas'],
              [Icons.location_on_outlined, 'Simpan alamat pengiriman'],
            ].map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                  child: Icon(b[0] as IconData, color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 12),
                Text(b[1] as String, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
              ]),
            )),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Masuk ke Akun',
              icon: Icons.login_rounded,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen(redirectAfterLogin: true))),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen(redirectAfterLogin: true))),
                icon: const Icon(Icons.person_add_outlined, color: AppColors.primary, size: 20),
                label: const Text('Buat Akun Baru', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  // ── TAMPILAN CHECKOUT UTAMA ────────────────────────────────
  Widget _buildCheckoutView(AuthController auth) {
    return Consumer2<CartController, TransactionController>(
      builder: (_, cart, txCtrl, __) {
        final items = cart.selectedItems;
        if (items.isEmpty) return Scaffold(appBar: AppBar(title: const Text('Checkout')), body: const Center(child: Text('Keranjang kosong')));
 
        final subtotal = cart.subtotal;
        final shipping = _calcShipping(subtotal);
        final total = subtotal + shipping - cart.voucherDiscount;
 
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildProgress(),
                    const SizedBox(height: 16),
                    _buildTitle('Alamat Pengiriman', Icons.location_on),
                    const SizedBox(height: 10),
                    _buildAddressSection(auth),
                    const SizedBox(height: 16),
                    _buildTitle('Produk Dipesan (${items.length})', Icons.shopping_bag_outlined),
                    const SizedBox(height: 10),
                    _buildCard(child: Column(children: items.map<Widget>((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children: [
                        ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(item.product.imageUrl, width: 56, height: 56, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: AppColors.surfaceVariant))),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item.product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          Text('x${item.quantity} · ${item.product.seller}', style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                        ])),
                        Text(Formatter.currency(item.totalPrice), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 13)),
                      ]),
                    )).toList())),
                    const SizedBox(height: 16),
                    _buildTitle('Metode Pengiriman', Icons.local_shipping_outlined),
                    const SizedBox(height: 10),
                    _buildShippingOptions(subtotal),
                    const SizedBox(height: 16),
                    _buildTitle('Metode Pembayaran', Icons.payment),
                    const SizedBox(height: 10),
                    ..._paymentMethods.map(_buildPaymentOption),
                    const SizedBox(height: 16),
                    _buildTitle('Ringkasan Pembayaran', Icons.receipt_long_outlined),
                    const SizedBox(height: 10),
                    _buildSummary(cart, subtotal, shipping, total),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              _buildPayButton(cart, auth, txCtrl, total, shipping),
            ],
          ),
        );
      },
    );
  }
 
  Widget _buildProgress() {
    final steps = [('Keranjang', Icons.shopping_cart, true), ('Checkout', Icons.receipt, true), ('Bayar', Icons.payment, false), ('Selesai', Icons.check_circle, false)];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(children: steps.asMap().entries.expand((e) {
        final isLast = e.key == steps.length - 1;
        return [
          Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 28, height: 28, decoration: BoxDecoration(gradient: e.value.$3 ? AppColors.primaryGradient : null, color: e.value.$3 ? null : AppColors.surfaceVariant, shape: BoxShape.circle),
              child: Icon(e.value.$2, color: e.value.$3 ? Colors.white : AppColors.textHint, size: 14)),
            const SizedBox(height: 4),
            Text(e.value.$1, style: TextStyle(fontSize: 9, color: e.value.$3 ? AppColors.primary : AppColors.textHint, fontWeight: e.value.$3 ? FontWeight.w600 : FontWeight.w400)),
          ]),
          if (!isLast) Expanded(child: Container(height: 2, margin: const EdgeInsets.only(bottom: 16), color: e.value.$3 ? AppColors.primary : AppColors.surfaceVariant)),
        ];
      }).toList()),
    );
  }
 
  Widget _buildAddressSection(AuthController auth) {
    final addresses = auth.user?.addresses ?? [];
    if (addresses.isEmpty) {
      return _buildCard(child: Column(children: [
        const Row(children: [Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20), SizedBox(width: 8), Expanded(child: Text('Belum ada alamat pengiriman', style: TextStyle(fontWeight: FontWeight.w600)))]),
        const SizedBox(height: 12),
        GradientButton(text: 'Tambah Alamat', icon: Icons.add_location_alt_outlined, onPressed: () async {
          final r = await Navigator.push<AddressModel>(context, MaterialPageRoute(builder: (_) => const AddAddressScreen()));
          if (r != null) setState(() => _selectedAddress = r);
        }),
      ]));
    }
    return _buildCard(child: Column(children: [
      ...addresses.map((addr) => GestureDetector(
        onTap: () => setState(() => _selectedAddress = addr),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _selectedAddress?.id == addr.id ? AppColors.primaryLight : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _selectedAddress?.id == addr.id ? AppColors.primary : Colors.transparent, width: 1.5),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(_selectedAddress?.id == addr.id ? Icons.radio_button_checked : Icons.radio_button_off, color: _selectedAddress?.id == addr.id ? AppColors.primary : AppColors.textHint, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(addr.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                if (addr.isDefault) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)), child: const Text('Utama', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)))],
              ]),
              Text('${addr.recipientName} · ${addr.phone}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text(addr.fullAddress, style: const TextStyle(fontSize: 12, color: AppColors.textHint, height: 1.4)),
            ])),
          ]),
        ),
      )),
      GestureDetector(
        onTap: () async {
          final r = await Navigator.push<AddressModel>(context, MaterialPageRoute(builder: (_) => const AddAddressScreen()));
          if (r != null) setState(() => _selectedAddress = r);
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.add_location_alt_outlined, color: AppColors.primary, size: 18),
            SizedBox(width: 6),
            Text('Tambah Alamat Lain', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
          ]),
        ),
      ),
    ]));
  }
 
  Widget _buildShippingOptions(double subtotal) {
    final base = subtotal >= 200000 ? 0.0 : 25000.0;
    return _buildCard(child: Column(children: _shippingOptions.entries.map((e) {
      final cost = base + e.value;
      final isSel = _selectedShipping == e.key;
      return GestureDetector(
        onTap: () => setState(() => _selectedShipping = e.key),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: isSel ? AppColors.primaryLight : AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10), border: Border.all(color: isSel ? AppColors.primary : Colors.transparent)),
          child: Row(children: [
            Icon(isSel ? Icons.radio_button_checked : Icons.radio_button_off, color: isSel ? AppColors.primary : AppColors.textHint, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.key, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const Text('2-4 hari kerja', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
            ])),
            Text(cost == 0 ? 'GRATIS' : Formatter.currency(cost), style: TextStyle(fontWeight: FontWeight.w700, color: cost == 0 ? AppColors.success : AppColors.textPrimary, fontSize: 13)),
          ]),
        ),
      );
    }).toList()));
  }
 
  Widget _buildPaymentOption(Map<String, dynamic> m) {
    final isSel = _selectedPayment == m['method'];
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = m['method']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: isSel ? AppColors.primaryLight : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSel ? AppColors.primary : AppColors.surfaceVariant, width: isSel ? 1.5 : 1)),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: (m['color'] as Color).withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Icon(m['icon'] as IconData, color: m['color'] as Color, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m['label'], style: TextStyle(fontWeight: FontWeight.w600, color: isSel ? AppColors.primary : AppColors.textPrimary)),
            Text(m['sublabel'], style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
          ])),
          if (isSel) const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
        ]),
      ),
    );
  }
 
  Widget _buildSummary(CartController cart, double subtotal, double shipping, double total) {
    return _buildCard(child: Column(children: [
      _buildRow('Subtotal', Formatter.currency(subtotal)),
      const SizedBox(height: 8),
      _buildRow('Ongkos Kirim ($_selectedShipping)', shipping == 0 ? 'GRATIS' : Formatter.currency(shipping), valueColor: shipping == 0 ? AppColors.success : null),
      if (cart.voucherDiscount > 0) ...[const SizedBox(height: 8), _buildRow('Voucher', '-${Formatter.currency(cart.voucherDiscount)}', valueColor: AppColors.success)],
      const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: AppColors.surfaceVariant)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        Text(Formatter.currency(total), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: AppColors.primary)),
      ]),
    ]));
  }
 
  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary, fontSize: 13)),
    ]);
  }
 
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: child,
    );
  }
 
  Widget _buildTitle(String t, IconData i) => Row(children: [
    Icon(i, size: 18, color: AppColors.primary), const SizedBox(width: 8),
    Text(t, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
  ]);
 
  Widget _buildPayButton(CartController cart, AuthController auth, TransactionController txCtrl, double total, double shipping) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))]),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Total:', style: TextStyle(color: AppColors.textSecondary)),
          Text(Formatter.currency(total), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppColors.primary)),
        ]),
        const SizedBox(height: 10),
        GradientButton(
          text: 'Bayar Sekarang', icon: Icons.lock_outline, isLoading: txCtrl.isProcessing,
          onPressed: () => _processPayment(cart, auth, txCtrl, total, shipping),
        ),
      ]),
    );
  }
 
  Future<void> _processPayment(CartController cart, AuthController auth, TransactionController txCtrl, double total, double shipping) async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Row(children: [Icon(Icons.error_outline, color: Colors.white, size: 18), SizedBox(width: 8), Text('Pilih alamat pengiriman terlebih dahulu')]),
        backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }
    final tx = await txCtrl.createTransaction(
      items: cart.selectedItems, address: _selectedAddress!, paymentMethod: _selectedPayment,
      subtotal: cart.subtotal, shippingFee: shipping, discount: cart.voucherDiscount,
    );
    if (tx != null && mounted) {
      auth.addLoyaltyPoints((total / 1000).floor());
      cart.clearSelectedItems();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TransactionSuccessScreen(transaction: tx)));
    }
  }
}

