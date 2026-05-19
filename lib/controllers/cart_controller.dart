// ============================================================
// CONTROLLER: cart_controller.dart
// Mengelola logika keranjang belanja (tambah, hapus, hitung)
// ============================================================
 
import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
 
class CartController extends ChangeNotifier {
  // ── STATE ──────────────────────────────────────────────────
  final List<CartItemModel> _cartItems = [];
  String _voucherCode = '';
  double _voucherDiscount = 0;
 
  // ── GETTER ─────────────────────────────────────────────────
  List<CartItemModel> get cartItems => _cartItems;
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _cartItems.isEmpty;
  String get voucherCode => _voucherCode;
  double get voucherDiscount => _voucherDiscount;
 
  // Daftar item yang dipilih
  List<CartItemModel> get selectedItems =>
      _cartItems.where((item) => item.isSelected).toList();
 
  bool get allSelected =>
      _cartItems.isNotEmpty && _cartItems.every((item) => item.isSelected);
 
  // ── KALKULASI HARGA ────────────────────────────────────────
  // Subtotal hanya item yang dipilih
  double get subtotal {
    return selectedItems.fold(0, (sum, item) => sum + item.totalPrice);
  }
 
  // Ongkos kirim (gratis jika subtotal > 200.000)
  double get shippingFee {
    if (selectedItems.isEmpty) return 0;
    return subtotal >= 200000 ? 0 : 25000;
  }
 
  // Total setelah diskon dan ongkir
  double get total => subtotal + shippingFee - _voucherDiscount;
 
  // Hemat berapa dari diskon produk
  double get totalSavings {
    return selectedItems.fold(0, (sum, item) {
      final saved = (item.product.originalPrice - item.product.price) *
          item.quantity;
      return sum + (saved > 0 ? saved : 0);
    });
  }
 
  // ── OPERASI KERANJANG ──────────────────────────────────────
  // Tambah produk ke keranjang
  void addToCart(ProductModel product, {int quantity = 1}) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );
 
    if (existingIndex != -1) {
      // Produk sudah ada — tambah jumlahnya
      final existing = _cartItems[existingIndex];
      final newQty = existing.quantity + quantity;
      if (newQty <= product.stock) {
        _cartItems[existingIndex] = existing.copyWith(quantity: newQty);
      }
    } else {
      // Produk baru — tambahkan ke list
      _cartItems.add(CartItemModel(product: product, quantity: quantity));
    }
    notifyListeners();
  }
 
  // Hapus produk dari keranjang
  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }
 
  // Update jumlah item
  void updateQuantity(String productId, int quantity) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else if (quantity <= _cartItems[index].product.stock) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      }
    }
    notifyListeners();
  }
 
  // Toggle pilihan item
  void toggleItemSelection(String productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        isSelected: !_cartItems[index].isSelected,
      );
      notifyListeners();
    }
  }
 
  // Pilih/hapus semua
  void toggleSelectAll() {
    final shouldSelectAll = !allSelected;
    for (int i = 0; i < _cartItems.length; i++) {
      _cartItems[i] = _cartItems[i].copyWith(isSelected: shouldSelectAll);
    }
    notifyListeners();
  }
 
  // Cek apakah produk sudah ada di keranjang
  bool isInCart(String productId) {
    return _cartItems.any((item) => item.product.id == productId);
  }
 
  // Jumlah item produk tertentu di keranjang
  int getQuantityInCart(String productId) {
    final item = _cartItems.where((item) => item.product.id == productId);
    return item.isEmpty ? 0 : item.first.quantity;
  }
 
  // ── VOUCHER ────────────────────────────────────────────────
  bool applyVoucher(String code) {
    final vouchers = {
      'MARLO10': 0.10,  // diskon 10%
      'MARLO20': 0.20,  // diskon 20%
      'GRATIS': 1.0,    // gratis ongkir
    };
 
    if (vouchers.containsKey(code.toUpperCase())) {
      _voucherCode = code.toUpperCase();
      if (code.toUpperCase() == 'GRATIS') {
        _voucherDiscount = shippingFee;
      } else {
        _voucherDiscount = subtotal * vouchers[code.toUpperCase()]!;
      }
      notifyListeners();
      return true;
    }
    return false;
  }
 
  void removeVoucher() {
    _voucherCode = '';
    _voucherDiscount = 0;
    notifyListeners();
  }
 
  // ── BERSIHKAN KERANJANG ────────────────────────────────────
  void clearCart() {
    _cartItems.clear();
    _voucherCode = '';
    _voucherDiscount = 0;
    notifyListeners();
  }
 
  // Hapus hanya item yang sudah dibayar
  void clearSelectedItems() {
    _cartItems.removeWhere((item) => item.isSelected);
    _voucherCode = '';
    _voucherDiscount = 0;
    notifyListeners();
  }
}