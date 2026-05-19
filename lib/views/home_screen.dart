// ============================================================
// VIEW: home_screen.dart
// Layar beranda dengan banner, kategori, produk unggulan
// ============================================================
 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_theme.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/user_controller.dart';
import '../utils/formatter.dart';
import '../widgets/common_widgets.dart';
import 'product_detail_screen.dart';
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  int _bannerIndex = 0;
  late PageController _bannerController;
 
  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Flash Sale\nSpesial Hari Ini!',
      'subtitle': 'Diskon hingga 50%',
      'gradient': AppColors.primaryGradient,
      'icon': Icons.flash_on,
    },
    {
      'title': 'Belanja Gratis\nOngkos Kirim',
      'subtitle': 'Min. belanja Rp200.000',
      'gradient': const LinearGradient(
        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
      ),
      'icon': Icons.local_shipping,
    },
    {
      'title': 'Produk Lokal\nUnggulan',
      'subtitle': 'Dukung UMKM Indonesia',
      'gradient': const LinearGradient(
        colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
      ),
      'icon': Icons.store,
    },
  ];
 
  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().loadProducts();
      _startBannerTimer();
    });
  }
 
  void _startBannerTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _bannerController.hasClients) {
        final next = (_bannerIndex + 1) % _banners.length;
        _bannerController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startBannerTimer();
      }
    });
  }
 
  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── APP BAR ──────────────────────────────────────────
          _buildAppBar(),
 
          // ── KONTEN ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                _buildSearchBar(),
                // Banner
                _buildBanner(),
                // Kategori cepat
                _buildQuickCategories(),
                // Flash Sale
                _buildFlashSaleSection(),
                // Produk untuk Kamu
                _buildAllProductsSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
 
  // ── APP BAR ────────────────────────────────────────────────
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 70,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.storefront, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Marlo Marketplace',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Consumer<UserController>(
                builder: (_, user, __) => Text(
                  'Halo, ${user.user?.name.split(' ').first ?? "Pengguna"}! 👋',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Consumer<CartController>(
          builder: (_, cart, __) => Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textPrimary),
                onPressed: () {},
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
 
  // ── SEARCH BAR ─────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Consumer<ProductController>(
        builder: (_, ctrl, __) => TextField(
          controller: _searchController,
          onChanged: ctrl.setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Cari produk, merek, kategori...',
            prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      ctrl.setSearchQuery('');
                    },
                  )
                : const Icon(Icons.tune, color: AppColors.textHint, size: 20),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
 
  // ── BANNER ─────────────────────────────────────────────────
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _bannerController,
              itemCount: _banners.length,
              onPageChanged: (i) => setState(() => _bannerIndex = i),
              itemBuilder: (_, i) {
                final banner = _banners[i];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    gradient: banner['gradient'],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                banner['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  banner['subtitle'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          banner['icon'],
                          size: 70,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Indikator banner
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _bannerIndex == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _bannerIndex == i
                      ? AppColors.primary
                      : AppColors.textHint,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  // ── QUICK CATEGORIES ───────────────────────────────────────
  Widget _buildQuickCategories() {
    final cats = [
      {'icon': Icons.phone_android, 'label': 'Elektronik', 'color': const Color(0xFF3B82F6)},
      {'icon': Icons.checkroom, 'label': 'Fashion', 'color': const Color(0xFFEC4899)},
      {'icon': Icons.restaurant, 'label': 'Makanan', 'color': const Color(0xFF10B981)},
      {'icon': Icons.face, 'label': 'Kecantikan', 'color': const Color(0xFFF59E0B)},
      {'icon': Icons.fitness_center, 'label': 'Olahraga', 'color': const Color(0xFF8B5CF6)},
      {'icon': Icons.kitchen, 'label': 'Rumah', 'color': const Color(0xFFEF4444)},
    ];
 
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: cats.map((cat) {
              return Consumer<ProductController>(
                builder: (_, ctrl, __) => GestureDetector(
                  onTap: () => ctrl.setCategory(cat['label'] as String),
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: (cat['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          cat['icon'] as IconData,
                          color: cat['color'] as Color,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        cat['label'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
 
  // ── FLASH SALE ─────────────────────────────────────────────
  Widget _buildFlashSaleSection() {
    return Consumer2<ProductController, CartController>(
      builder: (_, prodCtrl, cartCtrl, __) {
        final saleProducts = prodCtrl.flashSaleProducts;
        if (saleProducts.isEmpty) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.flash_on, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Flash Sale',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Berakhir dalam',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  _buildCountdown(),
                ],
              ),
            ),
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: saleProducts.length,
                itemBuilder: (_, i) {
                  final product = saleProducts[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 160,
                      child: ProductCard(
                        product: product,
                        onTap: () => _navigateToDetail(product.id),
                        onToggleFavorite: () =>
                            prodCtrl.toggleFavorite(product.id),
                        onAddToCart: () {
                          cartCtrl.addToCart(product);
                          _showAddedToCart(context);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
 
  Widget _buildCountdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        '08:45:22',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
 
  // ── SEMUA PRODUK ───────────────────────────────────────────
  Widget _buildAllProductsSection() {
    return Consumer2<ProductController, CartController>(
      builder: (_, prodCtrl, cartCtrl, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header + filter
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Semua Produk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      // Dropdown sort
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.surfaceVariant),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: prodCtrl.sortBy,
                          underline: const SizedBox(),
                          isDense: true,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'popular', child: Text('Terpopuler')),
                            DropdownMenuItem(
                                value: 'rating', child: Text('Rating')),
                            DropdownMenuItem(
                                value: 'price_low',
                                child: Text('Harga Terendah')),
                            DropdownMenuItem(
                                value: 'price_high',
                                child: Text('Harga Tertinggi')),
                            DropdownMenuItem(
                                value: 'newest', child: Text('Terbaru')),
                          ],
                          onChanged: (val) {
                            if (val != null) prodCtrl.setSortBy(val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Filter kategori
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: prodCtrl.categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final cat = prodCtrl.categories[i];
                        return CategoryChip(
                          label: cat,
                          isSelected: prodCtrl.selectedCategory == cat,
                          onTap: () => prodCtrl.setCategory(cat),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
 
            // Grid produk / loading / kosong
            if (prodCtrl.isLoading)
              _buildLoadingGrid()
            else if (prodCtrl.products.isEmpty)
              const EmptyState(
                title: 'Produk Tidak Ditemukan',
                subtitle: 'Coba kata kunci lain atau ubah filter',
                icon: Icons.search_off,
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: prodCtrl.products.length,
                  itemBuilder: (_, i) {
                    final product = prodCtrl.products[i];
                    return ProductCard(
                      product: product,
                      onTap: () => _navigateToDetail(product.id),
                      onToggleFavorite: () =>
                          prodCtrl.toggleFavorite(product.id),
                      onAddToCart: () {
                        cartCtrl.addToCart(product);
                        _showAddedToCart(context);
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
 
  Widget _buildLoadingGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(
                width: double.infinity,
                height: 140,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: double.infinity, height: 14),
                    SizedBox(height: 6),
                    SkeletonBox(width: 100, height: 12),
                    SizedBox(height: 8),
                    SkeletonBox(width: 80, height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  void _navigateToDetail(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(productId: productId),
      ),
    );
  }
 
  void _showAddedToCart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Ditambahkan ke keranjang!'),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}