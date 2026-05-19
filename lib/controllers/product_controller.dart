// ============================================================
// CONTROLLER: product_controller.dart
// Mengelola logika bisnis produk (filter, search, favorit)
// ============================================================
 
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
 
class ProductController extends ChangeNotifier {
  // ── STATE ──────────────────────────────────────────────────
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  String _sortBy = 'popular';
  bool _isLoading = false;
  String? _error;
 
  // ── GETTER ─────────────────────────────────────────────────
  List<ProductModel> get products => _filteredProducts;
  List<ProductModel> get allProducts => _allProducts;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  bool get isLoading => _isLoading;
  String? get error => _error;
 
  List<String> get categories {
    final cats = _allProducts.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['Semua', ...cats];
  }
 
  List<ProductModel> get favoriteProducts =>
      _allProducts.where((p) => p.isFavorite).toList();
 
  List<ProductModel> get featuredProducts =>
      _allProducts.where((p) => p.rating >= 4.5).take(6).toList();
 
  List<ProductModel> get flashSaleProducts =>
      _allProducts.where((p) => p.hasDiscount).toList();
 
  // ── INISIALISASI DATA ──────────────────────────────────────
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
 
    // Simulasi loading dari API (ganti dengan API nyata)
    await Future.delayed(const Duration(milliseconds: 800));
 
    try {
      _allProducts = _generateSampleProducts();
      _applyFilters();
    } catch (e) {
      _error = 'Gagal memuat produk: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
 
  // ── FILTER & SEARCH ────────────────────────────────────────
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }
 
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }
 
  void setSortBy(String sort) {
    _sortBy = sort;
    _applyFilters();
  }
 
  void _applyFilters() {
    List<ProductModel> result = [..._allProducts];
 
    // Filter kategori
    if (_selectedCategory != 'Semua') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }
 
    // Filter pencarian
    if (_searchQuery.isNotEmpty) {
      result = result.where((p) {
        return p.name.toLowerCase().contains(_searchQuery) ||
            p.description.toLowerCase().contains(_searchQuery) ||
            p.category.toLowerCase().contains(_searchQuery) ||
            p.tags.any((t) => t.toLowerCase().contains(_searchQuery));
      }).toList();
    }
 
    // Urutkan
    switch (_sortBy) {
      case 'price_low':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'newest':
        result = result.reversed.toList();
        break;
      default: // popular
        result.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }
 
    _filteredProducts = result;
    notifyListeners();
  }
 
  // ── TOGGLE FAVORIT ─────────────────────────────────────────
  void toggleFavorite(String productId) {
    final index = _allProducts.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _allProducts[index] = _allProducts[index].copyWith(
        isFavorite: !_allProducts[index].isFavorite,
      );
      _applyFilters();
    }
  }
 
  // Cari produk berdasarkan ID
  ProductModel? getProductById(String id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
 
  // Produk terkait berdasarkan kategori
  List<ProductModel> getRelatedProducts(String productId, String category) {
    return _allProducts
        .where((p) => p.category == category && p.id != productId)
        .take(6)
        .toList();
  }
 
  // ── DATA SAMPLE ────────────────────────────────────────────
  List<ProductModel> _generateSampleProducts() {
    return [
      // ── ELEKTRONIK ──────────────────────────────────────────
      ProductModel(
        id: 'P001',
        name: 'iPhone 15 Pro Max 256GB',
        description:
            'Smartphone flagship Apple dengan chip A17 Pro, kamera 48MP titanium, layar Super Retina XDR 6.7 inci. Performa luar biasa untuk kreator konten dan profesional.',
        price: 18999000,
        originalPrice: 21999000,
        imageUrl: 'https://i.ebayimg.com/images/g/L40AAOSwaiVmBIX9/s-l1600.webp',
        category: 'Elektronik',
        rating: 4.9,
        reviewCount: 2847,
        stock: 15,
        tags: ['apple', 'smartphone', 'flagship', 'ios'],
        seller: 'iStore Official',
      ),
      ProductModel(
        id: 'P002',
        name: 'Samsung Galaxy S24 Ultra',
        description:
            'Ponsel Android premium dengan S Pen, kamera 200MP, layar Dynamic AMOLED 6.8 inci. Cocok untuk produktivitas tinggi.',
        price: 17499000,
        originalPrice: 19999000,
        imageUrl: 'assets/images/marlo.jpeg',
        category: 'Elektronik',
        rating: 4.8,
        reviewCount: 1923,
        stock: 22,
        tags: ['samsung', 'android', 'flagship', 's-pen'],
        seller: 'Samsung Official Store',
      ),
      ProductModel(
        id: 'P003',
        name: 'MacBook Air M3 13" 8GB/256GB',
        description:
            'Laptop tipis & ringan dengan chip Apple M3. Baterai hingga 18 jam, layar Liquid Retina 13.6 inci, performa profesional.',
        price: 16499000,
        originalPrice: 16499000,
        imageUrl: 'https://picsum.photos/seed/macbookm3/400/400',
        category: 'Elektronik',
        rating: 4.9,
        reviewCount: 1456,
        stock: 8,
        tags: ['apple', 'laptop', 'macbook', 'm3'],
        seller: 'iStore Official',
      ),
      ProductModel(
        id: 'P004',
        name: 'Sony WH-1000XM5 Headphone',
        description:
            'Headphone over-ear dengan ANC terbaik di kelasnya. Suara Hi-Res Audio, baterai 30 jam, nyaman dipakai seharian.',
        price: 3899000,
        originalPrice: 4999000,
        imageUrl: 'https://picsum.photos/seed/sonywh/400/400',
        category: 'Elektronik',
        rating: 4.8,
        reviewCount: 3211,
        stock: 30,
        tags: ['sony', 'headphone', 'anc', 'audio'],
        seller: 'Sony Center',
      ),
      ProductModel(
        id: 'P005',
        name: 'Xiaomi Smart TV 55" QLED',
        description:
            'Smart TV 4K QLED dengan Google TV, Dolby Vision, Dolby Atmos. 55 inci layar lebar untuk pengalaman sinema di rumah.',
        price: 5499000,
        originalPrice: 7299000,
        imageUrl: 'https://picsum.photos/seed/xiaomitv/400/400',
        category: 'Elektronik',
        rating: 4.5,
        reviewCount: 876,
        stock: 12,
        tags: ['xiaomi', 'tv', 'smarttv', '4k', 'qled'],
        seller: 'Xiaomi Official',
      ),
 
      // ── FASHION ─────────────────────────────────────────────
      ProductModel(
        id: 'P006',
        name: 'Sepatu Nike Air Max 270',
        description:
            'Sepatu sneaker ikonik Nike dengan bantalan Air Max di tumit. Nyaman, stylish, cocok untuk aktivitas sehari-hari maupun olahraga ringan.',
        price: 1899000,
        originalPrice: 2499000,
        imageUrl: 'https://picsum.photos/seed/nikeam270/400/400',
        category: 'Fashion',
        rating: 4.7,
        reviewCount: 5632,
        stock: 45,
        tags: ['nike', 'sepatu', 'sneaker', 'airmax'],
        seller: 'Nike Indonesia',
      ),
      ProductModel(
        id: 'P007',
        name: 'Kemeja Batik Premium Sutra',
        description:
            'Kemeja batik tulis premium berbahan sutra alami. Motif kontemporer, cocok untuk acara formal maupun kasual. Tersedia berbagai ukuran.',
        price: 459000,
        originalPrice: 650000,
        imageUrl: 'https://picsum.photos/seed/batiksutra/400/400',
        category: 'Fashion',
        rating: 4.6,
        reviewCount: 892,
        stock: 60,
        tags: ['batik', 'kemeja', 'premium', 'sutra', 'lokal'],
        seller: 'Batik Nusantara',
      ),
      ProductModel(
        id: 'P008',
        name: 'Tas Ransel Laptop Waterproof',
        description:
            'Tas ransel multifungsi anti air dengan kompartemen laptop 15.6 inci, port USB charging, dan desain ergonomis. Kapasitas 30L.',
        price: 329000,
        originalPrice: 499000,
        imageUrl: 'https://picsum.photos/seed/tasransel/400/400',
        category: 'Fashion',
        rating: 4.5,
        reviewCount: 2134,
        stock: 78,
        tags: ['tas', 'ransel', 'laptop', 'waterproof'],
        seller: 'Urban Gear',
      ),
      ProductModel(
        id: 'P009',
        name: 'Jam Tangan Casio G-Shock GA-2100',
        description:
            'Jam tangan pria tahan banting G-Shock dengan desain octagonal tipis. Anti air 200m, shock resistant, tampilan analog-digital.',
        price: 1299000,
        originalPrice: 1599000,
        imageUrl: 'https://picsum.photos/seed/casio/400/400',
        category: 'Fashion',
        rating: 4.8,
        reviewCount: 4521,
        stock: 25,
        tags: ['casio', 'jam', 'gshock', 'pria'],
        seller: 'Casio Indonesia',
      ),
 
      // ── MAKANAN & MINUMAN ───────────────────────────────────
      ProductModel(
        id: 'P010',
        name: 'Kopi Arabika Toraja Premium 250g',
        description:
            'Biji kopi arabika single origin dari pegunungan Toraja, Sulawesi Selatan. Diproses dengan metode wet-hulled, rasa fruity dengan sentuhan coklat.',
        price: 85000,
        originalPrice: 110000,
        imageUrl: 'https://picsum.photos/seed/kopitoraja/400/400',
        category: 'Makanan',
        rating: 4.9,
        reviewCount: 1876,
        stock: 100,
        tags: ['kopi', 'arabika', 'toraja', 'sulawesi', 'premium'],
        seller: 'Kopiku Nusantara',
      ),
      ProductModel(
        id: 'P011',
        name: 'Coklat Artisan Dark 72% Kakao',
        description:
            'Coklat premium handmade dengan biji kakao pilihan dari Sulawesi Tengah. Dark chocolate 72% untuk pecinta coklat sejati.',
        price: 65000,
        originalPrice: 85000,
        imageUrl: 'https://picsum.photos/seed/coklat/400/400',
        category: 'Makanan',
        rating: 4.7,
        reviewCount: 643,
        stock: 50,
        tags: ['coklat', 'dark', 'artisan', 'kakao', 'sulawesi'],
        seller: 'Choco Artisan',
      ),
      ProductModel(
        id: 'P012',
        name: 'Madu Hutan Asli Kalimantan 500ml',
        description:
            'Madu hutan murni tanpa campuran dari lebah liar hutan Kalimantan. Kaya antioksidan, enzim alami, vitamin dan mineral.',
        price: 125000,
        originalPrice: 165000,
        imageUrl: 'https://picsum.photos/seed/maduhutan/400/400',
        category: 'Makanan',
        rating: 4.8,
        reviewCount: 2109,
        stock: 35,
        tags: ['madu', 'hutan', 'organik', 'kalimantan', 'alami'],
        seller: 'Madu Alam',
      ),
 
      // ── KECANTIKAN ──────────────────────────────────────────
      ProductModel(
        id: 'P013',
        name: 'Serum Vitamin C 20% Brightening',
        description:
            'Serum wajah vitamin C konsentrasi tinggi untuk mencerahkan dan meratakan warna kulit. Formula stabil, cocok untuk kulit sensitif.',
        price: 189000,
        originalPrice: 279000,
        imageUrl: 'https://picsum.photos/seed/serumvitc/400/400',
        category: 'Kecantikan',
        rating: 4.6,
        reviewCount: 3897,
        stock: 65,
        tags: ['serum', 'vitamin c', 'skincare', 'brightening'],
        seller: 'Glow Lab',
      ),
      ProductModel(
        id: 'P014',
        name: 'Sunscreen SPF 50+ PA++++ 50ml',
        description:
            'Tabir surya ringan dengan SPF 50+ PA++++. Tekstur gel, tidak lengket, cocok untuk kulit berminyak. Melindungi dari UVA & UVB.',
        price: 99000,
        originalPrice: 149000,
        imageUrl: 'https://picsum.photos/seed/sunscreen/400/400',
        category: 'Kecantikan',
        rating: 4.7,
        reviewCount: 6234,
        stock: 120,
        tags: ['sunscreen', 'spf', 'skincare', 'uv'],
        seller: 'Skin Protect Co.',
      ),
 
      // ── OLAHRAGA ────────────────────────────────────────────
      ProductModel(
        id: 'P015',
        name: 'Matras Yoga Premium 6mm TPE',
        description:
            'Matras yoga anti-slip berbahan TPE ramah lingkungan. Tebal 6mm untuk kenyamanan sendi, ukuran 183x61cm, ringan dan mudah digulung.',
        price: 299000,
        originalPrice: 450000,
        imageUrl: 'https://picsum.photos/seed/matrasyo/400/400',
        category: 'Olahraga',
        rating: 4.5,
        reviewCount: 1234,
        stock: 40,
        tags: ['yoga', 'matras', 'fitness', 'olahraga'],
        seller: 'Fit Life Store',
      ),
      ProductModel(
        id: 'P016',
        name: 'Dumbbell Set Adjustable 5-30kg',
        description:
            'Set dumbbell adjustable dengan 15 level beban 5-30kg. Hemat tempat, sistem dial cepat, bahan premium anti karat. Lengkap dengan rack.',
        price: 1899000,
        originalPrice: 2799000,
        imageUrl: 'https://picsum.photos/seed/dumbbell/400/400',
        category: 'Olahraga',
        rating: 4.7,
        reviewCount: 987,
        stock: 18,
        tags: ['dumbbell', 'gym', 'fitness', 'beban'],
        seller: 'Gym Equipment Pro',
      ),
 
      // ── RUMAH & DAPUR ────────────────────────────────────────
      ProductModel(
        id: 'P017',
        name: 'Air Fryer Digital 4L Touchscreen',
        description:
            'Air fryer digital layar sentuh dengan kapasitas 4L. 12 preset masakan, suhu 80-200°C, hemat minyak hingga 90%. Mudah dibersihkan.',
        price: 499000,
        originalPrice: 749000,
        imageUrl: 'https://picsum.photos/seed/airfryer/400/400',
        category: 'Rumah & Dapur',
        rating: 4.6,
        reviewCount: 2891,
        stock: 33,
        tags: ['airfryer', 'dapur', 'masak', 'digital'],
        seller: 'Kitchen Master',
      ),
      ProductModel(
        id: 'P018',
        name: 'Blender Portable USB Rechargeable',
        description:
            'Blender mini portabel dengan pengisian USB-C. Kapasitas 380ml, 6 pisau baja, motor 3000mAh, cocok untuk smoothie dan jus.',
        price: 149000,
        originalPrice: 229000,
        imageUrl: 'https://picsum.photos/seed/blender/400/400',
        category: 'Rumah & Dapur',
        rating: 4.4,
        reviewCount: 4123,
        stock: 85,
        tags: ['blender', 'portable', 'dapur', 'smoothie'],
        seller: 'Kitchen Master',
      ),
    ];
  }
}

