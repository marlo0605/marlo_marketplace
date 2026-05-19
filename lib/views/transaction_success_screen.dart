// ============================================================
// VIEW: transaction_success_screen.dart + order_screen.dart
// Layar sukses transaksi dan daftar pesanan
// ============================================================
 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';
import '../utils/formatter.dart';
import '../widgets/common_widgets.dart';
 
// ============================================================
// LAYAR SUKSES TRANSAKSI
// ============================================================
class TransactionSuccessScreen extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionSuccessScreen({super.key, required this.transaction});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
 
              // ── ANIMASI SUKSES ──────────────────────────────
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 64,
                ),
              ),
 
              const SizedBox(height: 28),
 
              const Text(
                'Pesanan Berhasil!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
 
              const SizedBox(height: 8),
 
              Text(
                'Pesananmu sedang diproses.\nTerima kasih sudah berbelanja di Marlo!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
 
              const SizedBox(height: 32),
 
              // ── DETAIL PESANAN ──────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailRow('No. Invoice',
                        transaction.invoiceNumber, isBold: true),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        'Tanggal', Formatter.dateTime(transaction.createdAt)),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        'Penerima', transaction.recipientName),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        'Alamat', transaction.shippingAddress,
                        isMultiLine: true),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        'Pembayaran', transaction.paymentMethodLabel),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: AppColors.surfaceVariant),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Dibayar',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          Formatter.currency(transaction.total),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Status badge
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.pending_outlined,
                              color: AppColors.primary, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            transaction.statusLabel,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
 
              const Spacer(),
 
              // ── TOMBOL AKSI ─────────────────────────────────
              GradientButton(
                text: 'Lihat Pesanan Saya',
                icon: Icons.shopping_bag_outlined,
                onPressed: () {
                  // Kembali ke halaman utama tab pesanan
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
 
              const SizedBox(height: 12),
 
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Lanjut Belanja',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildDetailRow(String label, String value,
      {bool isBold = false, bool isMultiLine = false}) {
    return Row(
      crossAxisAlignment: isMultiLine
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold ? AppColors.primary : AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
 
// ============================================================
// LAYAR DAFTAR PESANAN
// ============================================================
class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Pesanan Saya'),
      ),
      body: Consumer<TransactionController>(
        builder: (_, txCtrl, __) {
          if (txCtrl.transactions.isEmpty) {
            return const EmptyState(
              title: 'Belum Ada Pesanan',
              subtitle: 'Pesananmu akan muncul di sini setelah checkout',
              icon: Icons.shopping_bag_outlined,
            );
          }
 
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: txCtrl.transactions.length,
            itemBuilder: (_, i) {
              final tx = txCtrl.transactions[i];
              return _buildTransactionCard(context, tx, txCtrl);
            },
          );
        },
      ),
    );
  }
 
  Widget _buildTransactionCard(
    BuildContext context,
    TransactionModel tx,
    TransactionController txCtrl,
  ) {
    final statusColors = {
      TransactionStatus.pending: AppColors.warning,
      TransactionStatus.processing: AppColors.info,
      TransactionStatus.shipped: AppColors.primary,
      TransactionStatus.delivered: AppColors.success,
      TransactionStatus.cancelled: AppColors.error,
    };
 
    final color = statusColors[tx.status] ?? AppColors.textHint;
 
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tx.invoiceNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tx.statusLabel,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
 
            const SizedBox(height: 4),
            Text(
              Formatter.dateTime(tx.createdAt),
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textHint),
            ),
 
            const SizedBox(height: 12),
            const Divider(color: AppColors.surfaceVariant),
            const SizedBox(height: 12),
 
            // Item pertama
            if (tx.items.isNotEmpty) ...[
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      tx.items.first.product.imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: AppColors.surfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.items.first.product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'x${tx.items.first.quantity}',
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (tx.items.length > 1) ...[
                const SizedBox(height: 6),
                Text(
                  '+${tx.items.length - 1} produk lainnya',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ],
 
            const SizedBox(height: 12),
            const Divider(color: AppColors.surfaceVariant),
            const SizedBox(height: 8),
 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      Formatter.currency(tx.total),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                // Aksi berdasarkan status
                if (tx.status == TransactionStatus.shipped)
                  ElevatedButton(
                    onPressed: () => txCtrl.confirmReceived(tx.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Terima Pesanan',
                        style: TextStyle(fontSize: 12)),
                  )
                else if (tx.status == TransactionStatus.pending)
                  OutlinedButton(
                    onPressed: () => _showCancelDialog(context, tx, txCtrl),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child:
                        const Text('Batalkan', style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
 
            // Tracking number
            if (tx.trackingNumber != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'No. Resi: ${tx.trackingNumber}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
 
  void _showCancelDialog(
    BuildContext context,
    TransactionModel tx,
    TransactionController txCtrl,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Batalkan Pesanan?'),
        content: Text(
            'Yakin ingin membatalkan pesanan ${tx.invoiceNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            onPressed: () {
              txCtrl.cancelTransaction(tx.id);
              Navigator.pop(context);
            },
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }
}