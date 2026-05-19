// ============================================================
// VIEW: add_address_screen.dart
// Layar tambah & kelola alamat pengiriman
// ============================================================
 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../widgets/common_widgets.dart';
 
class AddAddressScreen extends StatefulWidget {
  final AddressModel? existingAddress; // null = tambah baru
  const AddAddressScreen({super.key, this.existingAddress});
 
  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}
 
class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelCtrl = TextEditingController();
  final _recipientCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _provinceCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();
  bool _isDefault = false;
  bool _isSaving = false;
 
  // Daftar provinsi Indonesia
  final List<String> _provinces = [
    'Aceh', 'Sumatera Utara', 'Sumatera Barat', 'Riau', 'Kepulauan Riau',
    'Jambi', 'Bengkulu', 'Sumatera Selatan', 'Kepulauan Bangka Belitung',
    'Lampung', 'DKI Jakarta', 'Jawa Barat', 'Banten', 'Jawa Tengah',
    'DI Yogyakarta', 'Jawa Timur', 'Bali', 'Nusa Tenggara Barat',
    'Nusa Tenggara Timur', 'Kalimantan Barat', 'Kalimantan Tengah',
    'Kalimantan Selatan', 'Kalimantan Timur', 'Kalimantan Utara',
    'Sulawesi Utara', 'Sulawesi Tengah', 'Gorontalo', 'Sulawesi Selatan',
    'Sulawesi Barat', 'Sulawesi Tenggara', 'Maluku', 'Maluku Utara',
    'Papua Barat', 'Papua',
  ];
 
  String _selectedProvince = 'Sulawesi Tengah';
 
  @override
  void initState() {
    super.initState();
    // Isi form jika sedang edit
    if (widget.existingAddress != null) {
      final addr = widget.existingAddress!;
      _labelCtrl.text = addr.label;
      _recipientCtrl.text = addr.recipientName;
      _phoneCtrl.text = addr.phone;
      _addressCtrl.text = addr.address;
      _cityCtrl.text = addr.city;
      _selectedProvince = addr.province;
      _postalCtrl.text = addr.postalCode;
      _isDefault = addr.isDefault;
    }
  }
 
  @override
  void dispose() {
    _labelCtrl.dispose();
    _recipientCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _provinceCtrl.dispose();
    _postalCtrl.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingAddress != null;
 
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Alamat' : 'Tambah Alamat Baru'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── IDENTITAS PENERIMA ────────────────────────
              _buildSectionCard(
                title: 'Identitas Penerima',
                icon: Icons.person_outline,
                children: [
                  // Label alamat
                  _buildLabel('Label Alamat'),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: ['Rumah', 'Kantor', 'Kos', 'Lainnya']
                        .map((label) => GestureDetector(
                              onTap: () =>
                                  setState(() => _labelCtrl.text = label),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: _labelCtrl.text == label
                                      ? AppColors.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _labelCtrl.text == label
                                        ? AppColors.primary
                                        : AppColors.surfaceVariant,
                                  ),
                                ),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    color: _labelCtrl.text == label
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  // Atau ketik label sendiri
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _labelCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Atau ketik label lain...',
                      prefixIcon: Icon(Icons.label_outline,
                          color: AppColors.textHint, size: 20),
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? 'Label alamat tidak boleh kosong'
                        : null,
                  ),
 
                  const SizedBox(height: 14),
 
                  // Nama penerima
                  _buildLabel('Nama Penerima'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _recipientCtrl,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'Nama lengkap penerima',
                      prefixIcon: Icon(Icons.person_outline,
                          color: AppColors.textHint, size: 20),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Nama penerima tidak boleh kosong'
                        : null,
                  ),
 
                  const SizedBox(height: 14),
 
                  // Nomor HP
                  _buildLabel('Nomor HP Penerima'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: '08xxxxxxxxxx',
                      prefixIcon: Icon(Icons.phone_outlined,
                          color: AppColors.textHint, size: 20),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Nomor HP tidak boleh kosong';
                      if (v.length < 10) return 'Nomor HP tidak valid';
                      return null;
                    },
                  ),
                ],
              ),
 
              const SizedBox(height: 16),
 
              // ── DETAIL ALAMAT ─────────────────────────────
              _buildSectionCard(
                title: 'Detail Alamat',
                icon: Icons.location_on_outlined,
                children: [
                  // Provinsi
                  _buildLabel('Provinsi'),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedProvince,
                        isExpanded: true,
                        items: _provinces
                            .map((p) => DropdownMenuItem(
                                value: p, child: Text(p)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null)
                            setState(() => _selectedProvince = v);
                        },
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
 
                  const SizedBox(height: 14),
 
                  // Kota/Kabupaten
                  _buildLabel('Kota / Kabupaten'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _cityCtrl,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'Nama kota atau kabupaten',
                      prefixIcon: Icon(Icons.location_city_outlined,
                          color: AppColors.textHint, size: 20),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Kota/Kabupaten tidak boleh kosong'
                        : null,
                  ),
 
                  const SizedBox(height: 14),
 
                  // Alamat Lengkap
                  _buildLabel('Alamat Lengkap'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _addressCtrl,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText:
                          'Nama jalan, nomor rumah, RT/RW, kelurahan, kecamatan',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 48),
                        child: Icon(Icons.home_outlined,
                            color: AppColors.textHint, size: 20),
                      ),
                      alignLabelWithHint: true,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Alamat lengkap tidak boleh kosong';
                      if (v.trim().length < 10)
                        return 'Alamat terlalu singkat';
                      return null;
                    },
                  ),
 
                  const SizedBox(height: 14),
 
                  // Kode Pos
                  _buildLabel('Kode Pos'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _postalCtrl,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: '00000',
                      prefixIcon: Icon(Icons.markunread_mailbox_outlined,
                          color: AppColors.textHint, size: 20),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Kode pos tidak boleh kosong';
                      if (v.length != 5) return 'Kode pos harus 5 digit';
                      return null;
                    },
                  ),
                ],
              ),
 
              const SizedBox(height: 16),
 
              // ── JADIKAN DEFAULT ───────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_outline,
                        color: AppColors.warning, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jadikan Alamat Utama',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Alamat ini akan dipilih otomatis saat checkout',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isDefault,
                      onChanged: (v) => setState(() => _isDefault = v),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
 
              const SizedBox(height: 24),
 
              // ── TOMBOL SIMPAN ─────────────────────────────
              GradientButton(
                text: isEditing ? 'Simpan Perubahan' : 'Simpan Alamat',
                icon: Icons.save_outlined,
                isLoading: _isSaving,
                onPressed: _saveAddress,
              ),
 
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
 
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
 
  Future<void> _saveAddress() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
 
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 500));
 
    final newAddress = AddressModel(
      id: widget.existingAddress?.id ??
          'A${DateTime.now().millisecondsSinceEpoch}',
      label: _labelCtrl.text.trim(),
      recipientName: _recipientCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      province: _selectedProvince,
      postalCode: _postalCtrl.text.trim(),
      isDefault: _isDefault,
    );
 
    final auth = context.read<AuthController>();
    final ok = await auth.addAddress(newAddress);
 
    setState(() => _isSaving = false);
 
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Alamat berhasil disimpan!'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pop(context, newAddress);
    }
  }
}