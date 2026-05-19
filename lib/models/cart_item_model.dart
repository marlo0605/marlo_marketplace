// ============================================================
// MODEL: cart_item_model.dart
// Bertanggung jawab menyimpan data item di keranjang belanja
// ============================================================
 
import 'product_model.dart';
 
class CartItemModel {
  final ProductModel product;
  int quantity;
  bool isSelected;
 
  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
  });
 
  // Total harga untuk item ini
  double get totalPrice => product.price * quantity;
 
  // Salin objek dengan perubahan
  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
    bool? isSelected,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }
 
  // Konversi ke Map
  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'isSelected': isSelected,
    };
  }
 
  // Buat dari Map
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      product: ProductModel.fromMap(map['product']),
      quantity: map['quantity'] ?? 1,
      isSelected: map['isSelected'] ?? true,
    );
  }
}