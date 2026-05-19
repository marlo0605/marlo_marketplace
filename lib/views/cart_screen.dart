// ============================================================
// VIEW: cart_screen.dart
// Layar keranjang belanja dengan ringkasan harga
// ============================================================
 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../controllers/cart_controller.dart';
import '../../utils/formatter.dart';
import '../widgets/common_widgets.dart';
import 'checkout_screen.dart';
 
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
 
  @override
  State<CartScreen> createState() => _CartScreenState();
}
 
class _CartScreenState extends State<CartScreen> {
  final _voucherController = TextEditingController();
 
  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Consumer<CartController>(
          builder: (_, cart, __) => Text(
            'Keranjang (${cart.itemCount} item)',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          Consumer<CartController>(
            builder: (_, cart, __) => cart.isEmpty
                ? const SizedBox()
                : TextButton(
                    onPressed: () => _showClearDialog(context, cart),
                    child: const Text(
                      'Hapus Semua',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
          ),
        ],
      ),
      body: Consumer<CartController>(
        builder: (_, cart, __) {
          if (cart.isEmpty) {
            return const EmptyState(
              title: 'Keranjang Kosong',
              subtitle: 'Yuk mulai belanja dan temukan produk favoritmu!',
              icon: Icons.shopping_cart_outlined,
            );
          }
 
          return Column(
            children: [
              // ── LIST ITEM ─────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Pilih semua
                    _buildSelectAll(cart),
                    const SizedBox(height: 12),
 
                    // Item keranjang
                    ...cart.cartItems.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildCartItem(item, cart),
                        )),
 
                    // Voucher
                    _buildVoucherSection(cart),
                    const SizedBox(height: 12),
 
                    // Ringkasan harga
                    _buildPriceSummary(cart),
                  ],
                ),
              ),
 
              // ── BOTTOM CHECKOUT ───────────────────────────────
              _buildCheckoutBar(cart),
            ],
          );
        },
      ),
    );
  }
 
  // ── PILIH SEMUA ────────────────────────────────────────────
  Widget _buildSelectAll(CartController cart) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Checkbox(
            value: cart.allSelected,
            onChanged: (_) => cart.toggleSelectAll(),
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const Text(
            'Pilih Semua',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            '${cart.selectedItems.length} dari ${cart.cartItems.length} dipilih',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
 
  // ── ITEM KERANJANG ─────────────────────────────────────────
  Widget _buildCartItem(item, CartController cart) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Checkbox(
              value: item.isSelected,
              onChanged: (_) => cart.toggleItemSelection(item.product.id),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
 
            // Gambar produk
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.surfaceVariant,
                  child: const Icon(Icons.image_outlined,
                      color: AppColors.textHint),
                ),
              ),
            ),
            const SizedBox(width: 12),
 
            // Info produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.product.seller,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Harga & kontrol qty
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Formatter.currency(item.product.price),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            'Total: ${Formatter.currency(item.totalPrice)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                      // Kontrol jumlah
                      Row(
                        children: [
                          // Hapus item
                          GestureDetector(
                            onTap: () => cart.removeFromCart(item.product.id),
                            child: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: AppColors.error,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildQtyControl(item, cart),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildQtyControl(item, CartController cart) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.surfaceVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => cart.updateQuantity(
                item.product.id, item.quantity - 1),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.remove, size: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          InkWell(
            onTap: () => cart.updateQuantity(
                item.product.id, item.quantity + 1),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.add, size: 16),
            ),
          ),
        ],
      ),
    );
  }
 
  // ── VOUCHER ────────────────────────────────────────────────
  Widget _buildVoucherSection(CartController cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_offer, color: AppColors.primary, size: 18),
              SizedBox(width: 6),
              Text(
                'Voucher & Promo',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (cart.voucherCode.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.success, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${cart.voucherCode} — Hemat ${Formatter.currency(cart.voucherDiscount)}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: cart.removeVoucher,
                    child: const Icon(Icons.close,
                        size: 18, color: AppColors.error),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _voucherController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan kode voucher',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final ok = cart.applyVoucher(_voucherController.text);
                    if (ok) {
                      _voucherController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Kode voucher tidak valid'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                  child: const Text('Pakai'),
                ),
              ],
            ),
          const SizedBox(height: 6),
          const Text(
            'Coba: MARLO10, MARLO20, GRATIS',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
 
  // ── RINGKASAN HARGA ────────────────────────────────────────
  Widget _buildPriceSummary(CartController cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pembayaran',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildPriceRow('Subtotal', Formatter.currency(cart.subtotal)),
          const SizedBox(height: 6),
          _buildPriceRow(
            'Ongkos Kirim',
            cart.shippingFee == 0
                ? 'GRATIS'
                : Formatter.currency(cart.shippingFee),
            valueColor: cart.shippingFee == 0 ? AppColors.success : null,
          ),
          if (cart.totalSavings > 0) ...[
            const SizedBox(height: 6),
            _buildPriceRow(
              'Hemat dari Diskon',
              '-${Formatter.currency(cart.totalSavings)}',
              valueColor: AppColors.success,
            ),
          ],
          if (cart.voucherDiscount > 0) ...[
            const SizedBox(height: 6),
            _buildPriceRow(
              'Voucher (${cart.voucherCode})',
              '-${Formatter.currency(cart.voucherDiscount)}',
              valueColor: AppColors.success,
            ),
          ],
          const SizedBox(height: 12),
          const Divider(color: AppColors.surfaceVariant),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                Formatter.currency(cart.total),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
 
  Widget _buildPriceRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
 
  // ── BOTTOM CHECKOUT BAR ────────────────────────────────────
  Widget _buildCheckoutBar(CartController cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${cart.selectedItems.length} item dipilih',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                Formatter.currency(cart.total),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GradientButton(
              text: 'Checkout (${cart.selectedItems.length})',
              onPressed: cart.selectedItems.isEmpty
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pilih produk terlebih dahulu'),
                        ),
                      )
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CheckoutScreen()),
                      ),
              icon: Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }
 
  void _showClearDialog(BuildContext context, CartController cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Kosongkan Keranjang?'),
        content: const Text('Semua item akan dihapus dari keranjang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
            },
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
  }
}