// ============================================================
// VIEW: product_detail_screen.dart
// Layar detail produk dengan gambar, info, dan tombol beli
// ============================================================
 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../models/product_model.dart';
import '../../utils/formatter.dart';
import '../widgets/common_widgets.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';
 
class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});
 
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}
 
class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isDescriptionExpanded = false;
 
  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProductController>().getProductById(widget.productId);
 
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Produk')),
        body: const Center(child: Text('Produk tidak ditemukan')),
      );
    }
 
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── GAMBAR PRODUK ─────────────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            actions: [
              Consumer<CartController>(
                builder: (_, cart, __) => Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const CartScreen())),
                    ),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${cart.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Consumer<ProductController>(
                builder: (_, ctrl, __) => IconButton(
                  icon: Icon(
                    product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: product.isFavorite ? AppColors.error : null,
                  ),
                  onPressed: () => ctrl.toggleFavorite(product.id),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.image_outlined,
                          size: 60, color: AppColors.textHint),
                    ),
                  ),
                  // Gradient bawah
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badge diskon
                  if (product.hasDiscount)
                    Positioned(
                      top: 80,
                      left: 16,
                      child: DiscountBadge(percent: product.discountPercent),
                    ),
                ],
              ),
            ),
          ),
 
          // ── KONTEN DETAIL ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama & Kategori
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.category,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
 
                        // Harga
                        Row(
                          children: [
                            Text(
                              Formatter.currency(product.price),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (product.hasDiscount) ...[
                              Text(
                                Formatter.currency(product.originalPrice),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textHint,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 8),
                              DiscountBadge(percent: product.discountPercent),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (product.hasDiscount)
                          Text(
                            'Hemat ${Formatter.currency(product.originalPrice - product.price)}',
                            style: const TextStyle(
                              color: AppColors.success,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
 
                        const SizedBox(height: 16),
                        const Divider(color: AppColors.surfaceVariant),
                        const SizedBox(height: 12),
 
                        // Rating & Terjual
                        Row(
                          children: [
                            _buildInfoChip(
                              Icons.star_rounded,
                              '${Formatter.rating(product.rating)} (${Formatter.number(product.reviewCount)} ulasan)',
                              AppColors.warning,
                            ),
                            const SizedBox(width: 16),
                            _buildInfoChip(
                              Icons.inventory_2_outlined,
                              'Stok: ${product.stock}',
                              AppColors.info,
                            ),
                          ],
                        ),
 
                        const SizedBox(height: 16),
 
                        // Penjual
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.store,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.seller,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const Text(
                                      'Penjual Resmi ✓',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  color: AppColors.textHint),
                            ],
                          ),
                        ),
 
                        const SizedBox(height: 20),
 
                        // Deskripsi
                        const Text(
                          'Deskripsi Produk',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedCrossFade(
                          firstChild: Text(
                            product.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                          secondChild: Text(
                            product.description,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                          crossFadeState: _isDescriptionExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                        TextButton(
                          onPressed: () => setState(() {
                            _isDescriptionExpanded = !_isDescriptionExpanded;
                          }),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero),
                          child: Text(
                            _isDescriptionExpanded
                                ? 'Tampilkan lebih sedikit'
                                : 'Selengkapnya',
                            style: const TextStyle(color: AppColors.primary),
                          ),
                        ),
 
                        // Tags
                        if (product.tags.isNotEmpty) ...[
                          Wrap(
                            spacing: 8,
                            children: product.tags
                                .map((tag) => Chip(
                                      label: Text(
                                        '#$tag',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      backgroundColor: AppColors.primaryLight,
                                      padding: EdgeInsets.zero,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ))
                                .toList(),
                          ),
                        ],
 
                        const SizedBox(height: 24),
 
                        // Pengiriman
                        _buildShippingInfo(),
 
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
 
      // ── BOTTOM BAR (TOMBOL BELI) ───────────────────────────
      bottomNavigationBar: _buildBottomBar(product),
    );
  }
 
  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
 
  Widget _buildShippingInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.surfaceVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildShippingRow(
              Icons.local_shipping_outlined, 'Pengiriman ke Palu, Sulawesi Tengah'),
          const SizedBox(height: 8),
          _buildShippingRow(
              Icons.check_circle_outline, 'Gratis ongkir min. Rp200.000'),
          const SizedBox(height: 8),
          _buildShippingRow(
              Icons.replay_outlined, 'Garansi pengembalian 7 hari'),
        ],
      ),
    );
  }
 
  Widget _buildShippingRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.success),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }
 
  Widget _buildBottomBar(ProductModel product) {
    return Consumer<CartController>(
      builder: (_, cart, __) => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
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
            // Kontrol jumlah
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.surfaceVariant),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                    icon: const Icon(Icons.remove, size: 18),
                    color: _quantity > 1
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                        minWidth: 36, minHeight: 36),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _quantity < product.stock
                        ? () => setState(() => _quantity++)
                        : null,
                    icon: const Icon(Icons.add, size: 18),
                    color: _quantity < product.stock
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                        minWidth: 36, minHeight: 36),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
 
            // Tombol keranjang
            OutlinedButton.icon(
              onPressed: () {
                cart.addToCart(product, quantity: _quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Ditambahkan $_quantity item ke keranjang'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined, size: 18),
              label: const Text('Keranjang'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(width: 8),
 
            // Tombol beli
            Expanded(
              child: GradientButton(
                text: 'Beli Sekarang',
                onPressed: () {
                  // Langsung ke checkout
                  cart.addToCart(product, quantity: _quantity);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CheckoutScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}