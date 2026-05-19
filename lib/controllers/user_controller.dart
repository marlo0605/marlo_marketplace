// ============================================================
// CONTROLLER: user_controller.dart
// Mengelola data pengguna dan autentikasi
// ============================================================
 
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
 
class UserController extends ChangeNotifier {
  // ── STATE ──────────────────────────────────────────────────
  UserModel? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;
 
  // ── GETTER ─────────────────────────────────────────────────
  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
 
  // ── INISIALISASI (auto-login untuk demo) ───────────────────
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
 
    await Future.delayed(const Duration(milliseconds: 500));
 
    // Data pengguna demo — ganti dengan auth nyata
    _user = UserModel(
      id: 'U001',
      name: 'Budi Santoso',
      email: 'budi.santoso@email.com',
      phone: '081234567890',
      addresses: [
        AddressModel(
          id: 'A001',
          label: 'Rumah',
          recipientName: 'Budi Santoso',
          phone: '081234567890',
          address: 'Jl. Diponegoro No. 45, RT 03/RW 05',
          city: 'Palu',
          province: 'Sulawesi Tengah',
          postalCode: '94111',
          isDefault: true,
        ),
        AddressModel(
          id: 'A002',
          label: 'Kantor',
          recipientName: 'Budi Santoso',
          phone: '081234567890',
          address: 'Jl. Sudirman No. 12, Lt. 3',
          city: 'Palu',
          province: 'Sulawesi Tengah',
          postalCode: '94113',
          isDefault: false,
        ),
      ],
      loyaltyPoints: 1250,
    );
    _isLoggedIn = true;
 
    _isLoading = false;
    notifyListeners();
  }
 
  // ── UPDATE PROFIL ──────────────────────────────────────────
  Future<bool> updateProfile({
    String? name,
    String? phone,
  }) async {
    if (_user == null) return false;
 
    _isLoading = true;
    notifyListeners();
 
    await Future.delayed(const Duration(milliseconds: 500));
 
    _user = _user!.copyWith(name: name, phone: phone);
    _isLoading = false;
    notifyListeners();
    return true;
  }
 
  // ── TAMBAH ALAMAT ──────────────────────────────────────────
  void addAddress(AddressModel address) {
    if (_user == null) return;
    final updatedAddresses = [..._user!.addresses, address];
    _user = _user!.copyWith(addresses: updatedAddresses);
    notifyListeners();
  }
 
  // ── TAMBAH POIN ───────────────────────────────────────────
  void addLoyaltyPoints(int points) {
    if (_user == null) return;
    _user = _user!.copyWith(loyaltyPoints: _user!.loyaltyPoints + points);
    notifyListeners();
  }
 
  // ── LOGOUT ────────────────────────────────────────────────
  void logout() {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}

