// ============================================================
// CONTROLLER: transaction_controller.dart
// Mengelola logika pembuatan dan pelacakan transaksi
// ============================================================
 
import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../models/cart_item_model.dart';
import '../models/user_model.dart';
 
class TransactionController extends ChangeNotifier {
  // ── STATE ──────────────────────────────────────────────────
  final List<TransactionModel> _transactions = [];
  bool _isProcessing = false;
  String? _error;
 
  // ── GETTER ─────────────────────────────────────────────────
  List<TransactionModel> get transactions => _transactions;
  bool get isProcessing => _isProcessing;
  String? get error => _error;
 
  List<TransactionModel> get pendingTransactions => _transactions
      .where((t) => t.status == TransactionStatus.pending)
      .toList();
 
  List<TransactionModel> get activeTransactions => _transactions
      .where((t) =>
          t.status == TransactionStatus.processing ||
          t.status == TransactionStatus.shipped)
      .toList();
 
  List<TransactionModel> get completedTransactions => _transactions
      .where((t) => t.status == TransactionStatus.delivered)
      .toList();
 
  // Total belanja semua transaksi selesai
  double get totalSpending {
    return completedTransactions.fold(0, (sum, t) => sum + t.total);
  }
 
  // ── BUAT TRANSAKSI ─────────────────────────────────────────
  Future<TransactionModel?> createTransaction({
    required List<CartItemModel> items,
    required AddressModel address,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double shippingFee,
    required double discount,
    String? notes,
  }) async {
    _isProcessing = true;
    _error = null;
    notifyListeners();
 
    try {
      // Simulasi proses pembayaran (ganti dengan payment gateway nyata)
      await Future.delayed(const Duration(seconds: 2));
 
      final now = DateTime.now();
      final invoiceNumber = _generateInvoiceNumber(now);
 
      final transaction = TransactionModel(
        id: 'TRX${now.millisecondsSinceEpoch}',
        invoiceNumber: invoiceNumber,
        items: items,
        subtotal: subtotal,
        shippingFee: shippingFee,
        discount: discount,
        total: subtotal + shippingFee - discount,
        status: TransactionStatus.pending,
        paymentMethod: paymentMethod,
        shippingAddress: address.fullAddress,
        recipientName: address.recipientName,
        recipientPhone: address.phone,
        createdAt: now,
        notes: notes,
      );
 
      _transactions.insert(0, transaction);
 
      // Simulasi: setelah 3 detik status berubah ke processing
      _simulateStatusUpdate(transaction.id);
 
      return transaction;
    } catch (e) {
      _error = 'Gagal membuat transaksi: $e';
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
 
  // ── SIMULASI UPDATE STATUS ─────────────────────────────────
  void _simulateStatusUpdate(String transactionId) {
    // Simulasi alur status otomatis (di produksi gunakan webhook)
    Future.delayed(const Duration(seconds: 3), () {
      updateTransactionStatus(transactionId, TransactionStatus.processing);
    });
    Future.delayed(const Duration(seconds: 8), () {
      updateTransactionStatus(
        transactionId,
        TransactionStatus.shipped,
        trackingNumber: 'JNE${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      );
    });
  }
 
  // ── UPDATE STATUS ──────────────────────────────────────────
  void updateTransactionStatus(
    String transactionId,
    TransactionStatus newStatus, {
    String? trackingNumber,
  }) {
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index != -1) {
      _transactions[index] = _transactions[index].copyWith(
        status: newStatus,
        trackingNumber: trackingNumber,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }
 
  // Konfirmasi penerimaan pesanan
  void confirmReceived(String transactionId) {
    updateTransactionStatus(transactionId, TransactionStatus.delivered);
  }
 
  // Batalkan pesanan
  void cancelTransaction(String transactionId) {
    updateTransactionStatus(transactionId, TransactionStatus.cancelled);
  }
 
  // Cari transaksi berdasarkan ID
  TransactionModel? getTransactionById(String id) {
    try {
      return _transactions.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
 
  // ── GENERATE INVOICE ───────────────────────────────────────
  String _generateInvoiceNumber(DateTime date) {
    final year = date.year.toString().substring(2);
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final random = (date.millisecondsSinceEpoch % 10000).toString().padLeft(4, '0');
    return 'MLO/$year$month$day/$random';
  }
}
 