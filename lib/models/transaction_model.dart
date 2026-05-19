// ============================================================
// MODEL: transaction_model.dart
// Bertanggung jawab menyimpan data transaksi / pesanan
// ============================================================
 
import 'cart_item_model.dart';
 
enum TransactionStatus {
  pending,      // Menunggu pembayaran
  processing,   // Sedang diproses
  shipped,      // Sedang dikirim
  delivered,    // Sudah diterima
  cancelled,    // Dibatalkan
}
 
enum PaymentMethod {
  bankTransfer,
  creditCard,
  eWallet,
  cashOnDelivery,
}
 
class TransactionModel {
  final String id;
  final String invoiceNumber;
  final List<CartItemModel> items;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;
  final TransactionStatus status;
  final PaymentMethod paymentMethod;
  final String shippingAddress;
  final String recipientName;
  final String recipientPhone;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? trackingNumber;
  final String? notes;
 
  TransactionModel({
    required this.id,
    required this.invoiceNumber,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    this.discount = 0,
    required this.total,
    this.status = TransactionStatus.pending,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.recipientName,
    required this.recipientPhone,
    required this.createdAt,
    this.updatedAt,
    this.trackingNumber,
    this.notes,
  });
 
  // Jumlah total item
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
 
  // Label status dalam Bahasa Indonesia
  String get statusLabel {
    switch (status) {
      case TransactionStatus.pending:
        return 'Menunggu Pembayaran';
      case TransactionStatus.processing:
        return 'Sedang Diproses';
      case TransactionStatus.shipped:
        return 'Sedang Dikirim';
      case TransactionStatus.delivered:
        return 'Pesanan Diterima';
      case TransactionStatus.cancelled:
        return 'Dibatalkan';
    }
  }
 
  // Label metode pembayaran
  String get paymentMethodLabel {
    switch (paymentMethod) {
      case PaymentMethod.bankTransfer:
        return 'Transfer Bank';
      case PaymentMethod.creditCard:
        return 'Kartu Kredit';
      case PaymentMethod.eWallet:
        return 'E-Wallet';
      case PaymentMethod.cashOnDelivery:
        return 'Bayar di Tempat';
    }
  }
 
  // Salin dengan perubahan status
  TransactionModel copyWith({
    TransactionStatus? status,
    String? trackingNumber,
    DateTime? updatedAt,
    String? notes,
  }) {
    return TransactionModel(
      id: id,
      invoiceNumber: invoiceNumber,
      items: items,
      subtotal: subtotal,
      shippingFee: shippingFee,
      discount: discount,
      total: total,
      status: status ?? this.status,
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      notes: notes ?? this.notes,
    );
  }
}