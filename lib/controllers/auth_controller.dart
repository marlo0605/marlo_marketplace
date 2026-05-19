// // ============================================================
// // CONTROLLER: auth_controller.dart
// // Mengelola autentikasi: login, register, logout
// // ============================================================
 
// import 'package:flutter/foundation.dart';
// import '../models/user_model.dart';
 
// enum AuthStatus { initial, loading, authenticated, unauthenticated, error }
 
// class AuthController extends ChangeNotifier {
//   // ── STATE ──────────────────────────────────────────────────
//   AuthStatus _status = AuthStatus.initial;
//   UserModel? _user;
//   String? _errorMessage;
 
//   // Database pengguna simulasi (ganti dengan backend nyata)
//   final List<Map<String, dynamic>> _registeredUsers = [
//     {
//       'id': 'U001',
//       'name': 'Budi Santoso',
//       'email': 'budi@email.com',
//       'password': 'budi123',
//       'phone': '081234567890',
//       'addresses': <Map<String, dynamic>>[
//         {
//           'id': 'A001',
//           'label': 'Rumah',
//           'recipientName': 'Budi Santoso',
//           'phone': '081234567890',
//           'address': 'Jl. Diponegoro No. 45, RT 03/RW 05',
//           'city': 'Palu',
//           'province': 'Sulawesi Tengah',
//           'postalCode': '94111',
//           'isDefault': true,
//         }
//       ],
//       'loyaltyPoints': 1250,
//     }
//   ];
 
//   // ── GETTER ─────────────────────────────────────────────────
//   AuthStatus get status => _status;
//   UserModel? get user => _user;
//   bool get isAuthenticated => _status == AuthStatus.authenticated;
//   bool get isLoading => _status == AuthStatus.loading;
//   String? get errorMessage => _errorMessage;
 
//   // ── INISIALISASI ───────────────────────────────────────────
//   Future<void> initialize() async {
//     _status = AuthStatus.loading;
//     notifyListeners();
//     await Future.delayed(const Duration(milliseconds: 600));
//     // Di sini bisa cek token tersimpan (shared_preferences)
//     // Untuk demo, mulai sebagai tamu
//     _status = AuthStatus.unauthenticated;
//     notifyListeners();
//   }
 
//   // ── LOGIN ──────────────────────────────────────────────────
//   Future<bool> login(String email, String password) async {
//     _status = AuthStatus.loading;
//     _errorMessage = null;
//     notifyListeners();
 
//     await Future.delayed(const Duration(milliseconds: 1200));
 
//     try {
//       // Validasi input
//       if (email.trim().isEmpty || password.trim().isEmpty) {
//         _errorMessage = 'Email dan password tidak boleh kosong';
//         _status = AuthStatus.unauthenticated;
//         notifyListeners();
//         return false;
//       }
 
//       // Cari pengguna di database simulasi
//       final userData = _registeredUsers.firstWhere(
//         (u) =>
//             u['email'].toString().toLowerCase() ==
//                 email.trim().toLowerCase() &&
//             u['password'] == password,
//         orElse: () => {},
//       );
 
//       if (userData.isEmpty) {
//         _errorMessage = 'Email atau password salah';
//         _status = AuthStatus.unauthenticated;
//         notifyListeners();
//         return false;
//       }
 
//       // Bangun model pengguna
//       _user = _buildUserFromMap(userData);
//       _status = AuthStatus.authenticated;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _errorMessage = 'Terjadi kesalahan. Coba lagi.';
//       _status = AuthStatus.unauthenticated;
//       notifyListeners();
//       return false;
//     }
//   }
 
//   // ── REGISTER ───────────────────────────────────────────────
//   Future<bool> register({
//     required String name,
//     required String email,
//     required String password,
//     required String phone,
//   }) async {
//     _status = AuthStatus.loading;
//     _errorMessage = null;
//     notifyListeners();
 
//     await Future.delayed(const Duration(milliseconds: 1400));
 
//     try {
//       // Cek email sudah terdaftar
//       final alreadyExists = _registeredUsers.any(
//         (u) =>
//             u['email'].toString().toLowerCase() == email.trim().toLowerCase(),
//       );
 
//       if (alreadyExists) {
//         _errorMessage = 'Email sudah terdaftar. Silakan login.';
//         _status = AuthStatus.unauthenticated;
//         notifyListeners();
//         return false;
//       }
 
//       // Buat akun baru
//       final newUser = {
//         'id': 'U${DateTime.now().millisecondsSinceEpoch}',
//         'name': name.trim(),
//         'email': email.trim().toLowerCase(),
//         'password': password,
//         'phone': phone.trim(),
//         'addresses': <Map<String, dynamic>>[],
//         'loyaltyPoints': 100, // Bonus poin pendaftaran
//       };
 
//       _registeredUsers.add(newUser);
//       _user = _buildUserFromMap(newUser);
//       _status = AuthStatus.authenticated;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _errorMessage = 'Gagal membuat akun. Coba lagi.';
//       _status = AuthStatus.unauthenticated;
//       notifyListeners();
//       return false;
//     }
//   }
 
//   // ── TAMBAH ALAMAT ──────────────────────────────────────────
//   Future<bool> addAddress(AddressModel address) async {
//     if (_user == null) return false;
 
//     // Jika ini alamat pertama, jadikan default
//     final isFirst = _user!.addresses.isEmpty;
//     final newAddress = isFirst
//         ? AddressModel(
//             id: address.id,
//             label: address.label,
//             recipientName: address.recipientName,
//             phone: address.phone,
//             address: address.address,
//             city: address.city,
//             province: address.province,
//             postalCode: address.postalCode,
//             isDefault: true,
//           )
//         : address;
 
//     final updatedAddresses = [..._user!.addresses, newAddress];
//     _user = _user!.copyWith(addresses: updatedAddresses);
 
//     // Update di database simulasi
//     final idx = _registeredUsers.indexWhere((u) => u['id'] == _user!.id);
//     if (idx != -1) {
//       _registeredUsers[idx]['addresses'] =
//           updatedAddresses.map((a) => a.toMap()).toList();
//     }
 
//     notifyListeners();
//     return true;
//   }
 
//   // Jadikan alamat sebagai default
//   Future<void> setDefaultAddress(String addressId) async {
//     if (_user == null) return;
//     final updated = _user!.addresses.map((a) {
//       return AddressModel(
//         id: a.id,
//         label: a.label,
//         recipientName: a.recipientName,
//         phone: a.phone,
//         address: a.address,
//         city: a.city,
//         province: a.province,
//         postalCode: a.postalCode,
//         isDefault: a.id == addressId,
//       );
//     }).toList();
//     _user = _user!.copyWith(addresses: updated);
//     notifyListeners();
//   }
 
//   // Hapus alamat
//   void removeAddress(String addressId) {
//     if (_user == null) return;
//     final updated =
//         _user!.addresses.where((a) => a.id != addressId).toList();
//     _user = _user!.copyWith(addresses: updated);
//     notifyListeners();
//   }
 
//   // ── TAMBAH POIN LOYALITAS ──────────────────────────────────
//   void addLoyaltyPoints(int points) {
//     if (_user == null) return;
//     _user = _user!.copyWith(loyaltyPoints: _user!.loyaltyPoints + points);
//     notifyListeners();
//   }
 
//   // ── LOGOUT ─────────────────────────────────────────────────
//   void logout() {
//     _user = null;
//     _status = AuthStatus.unauthenticated;
//     _errorMessage = null;
//     notifyListeners();
//   }
 
//   // ── HELPER ────────────────────────────────────────────────
//   UserModel _buildUserFromMap(Map<String, dynamic> data) {
//     final rawAddresses = data['addresses'] as List? ?? [];
//     final addresses = rawAddresses
//         .map((a) => AddressModel.fromMap(Map<String, dynamic>.from(a)))
//         .toList();
 
//     return UserModel(
//       id: data['id'],
//       name: data['name'],
//       email: data['email'],
//       phone: data['phone'],
//       addresses: addresses,
//       loyaltyPoints: data['loyaltyPoints'] ?? 0,
//     );
//   }
 
//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
// }


// ============================================================
// CONTROLLER: auth_controller.dart
// Mengelola autentikasi login, register, logout,
// alamat pengguna, dan session user
// ============================================================

import 'package:flutter/material.dart';
import '../models/user_model.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthController extends ChangeNotifier {

  // ============================================================
  // STATE
  // ============================================================

  AuthStatus _status = AuthStatus.initial;

  UserModel? _user;

  String? _errorMessage;

  // ============================================================
  // DATABASE SIMULASI
  // ============================================================

  final List<Map<String, dynamic>> _registeredUsers = [
    {
      'id': 'U001',
      'name': 'Budi Santoso',
      'email': 'budi@email.com',
      'password': 'budi123',
      'phone': '081234567890',

      'addresses': [
        {
          'id': 'A001',
          'label': 'Rumah',
          'recipientName': 'Budi Santoso',
          'phone': '081234567890',
          'address': 'Jl. Diponegoro No. 45',
          'city': 'Palu',
          'province': 'Sulawesi Tengah',
          'postalCode': '94111',
          'isDefault': true,
        }
      ],

      'loyaltyPoints': 1250,
    }
  ];

  // ============================================================
  // GETTER
  // ============================================================

  AuthStatus get status => _status;

  UserModel? get user => _user;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == AuthStatus.loading;

  bool get isAuthenticated =>
      _status == AuthStatus.authenticated;

  // Tambahan agar tidak error di RootScreen
  bool get isLoggedIn =>
      _status == AuthStatus.authenticated;

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> initialize() async {
    _status = AuthStatus.loading;

    notifyListeners();

    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    // nanti bisa cek token login di sini

    _status = AuthStatus.unauthenticated;

    notifyListeners();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<bool> login(
    String email,
    String password,
  ) async {

    _status = AuthStatus.loading;

    _errorMessage = null;

    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 1),
    );

    try {

      // VALIDASI
      if (email.trim().isEmpty ||
          password.trim().isEmpty) {

        _errorMessage =
            'Email dan password wajib diisi';

        _status = AuthStatus.unauthenticated;

        notifyListeners();

        return false;
      }

      // CARI USER
      final userData = _registeredUsers.firstWhere(
        (user) =>
            user['email']
                    .toString()
                    .toLowerCase() ==
                email.trim().toLowerCase() &&
            user['password'] == password,
        orElse: () => {},
      );

      // USER TIDAK DITEMUKAN
      if (userData.isEmpty) {

        _errorMessage =
            'Email atau password salah';

        _status = AuthStatus.unauthenticated;

        notifyListeners();

        return false;
      }

      // LOGIN BERHASIL
      _user = _buildUserFromMap(userData);

      _status = AuthStatus.authenticated;

      notifyListeners();

      return true;

    } catch (e) {

      _errorMessage =
          'Terjadi kesalahan saat login';

      _status = AuthStatus.error;

      notifyListeners();

      return false;
    }
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {

    _status = AuthStatus.loading;

    _errorMessage = null;

    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 1),
    );

    try {

      // VALIDASI
      if (name.trim().isEmpty ||
          email.trim().isEmpty ||
          password.trim().isEmpty ||
          phone.trim().isEmpty) {

        _errorMessage =
            'Semua data wajib diisi';

        _status = AuthStatus.unauthenticated;

        notifyListeners();

        return false;
      }

      // EMAIL SUDAH ADA
      final emailExists = _registeredUsers.any(
        (user) =>
            user['email']
                    .toString()
                    .toLowerCase() ==
                email.trim().toLowerCase(),
      );

      if (emailExists) {

        _errorMessage =
            'Email sudah terdaftar';

        _status = AuthStatus.unauthenticated;

        notifyListeners();

        return false;
      }

      // DATA USER BARU
      final newUser = {
        'id':
            'U${DateTime.now().millisecondsSinceEpoch}',

        'name': name.trim(),

        'email':
            email.trim().toLowerCase(),

        'password': password,

        'phone': phone.trim(),

        'addresses': <Map<String, dynamic>>[],

        'loyaltyPoints': 100,
      };

      // SIMPAN USER
      _registeredUsers.add(newUser);

      // LOGIN OTOMATIS
      _user = _buildUserFromMap(newUser);

      _status = AuthStatus.authenticated;

      notifyListeners();

      return true;

    } catch (e) {

      _errorMessage =
          'Gagal membuat akun';

      _status = AuthStatus.error;

      notifyListeners();

      return false;
    }
  }

  // ============================================================
  // TAMBAH ALAMAT
  // ============================================================

  Future<bool> addAddress(
    AddressModel address,
  ) async {

    if (_user == null) return false;

    final isFirstAddress =
        _user!.addresses.isEmpty;

    final newAddress = AddressModel(
      id: address.id,
      label: address.label,
      recipientName: address.recipientName,
      phone: address.phone,
      address: address.address,
      city: address.city,
      province: address.province,
      postalCode: address.postalCode,
      isDefault: isFirstAddress
          ? true
          : address.isDefault,
    );

    final updatedAddresses = [
      ..._user!.addresses,
      newAddress,
    ];

    _user = _user!.copyWith(
      addresses: updatedAddresses,
    );

    notifyListeners();

    return true;
  }

  // ============================================================
  // SET DEFAULT ADDRESS
  // ============================================================

  Future<void> setDefaultAddress(
    String addressId,
  ) async {

    if (_user == null) return;

    final updatedAddresses =
        _user!.addresses.map((address) {

      return AddressModel(
        id: address.id,
        label: address.label,
        recipientName: address.recipientName,
        phone: address.phone,
        address: address.address,
        city: address.city,
        province: address.province,
        postalCode: address.postalCode,
        isDefault:
            address.id == addressId,
      );

    }).toList();

    _user = _user!.copyWith(
      addresses: updatedAddresses,
    );

    notifyListeners();
  }

  // ============================================================
  // HAPUS ALAMAT
  // ============================================================

  void removeAddress(
    String addressId,
  ) {

    if (_user == null) return;

    final updatedAddresses =
        _user!.addresses
            .where((address) =>
                address.id != addressId)
            .toList();

    _user = _user!.copyWith(
      addresses: updatedAddresses,
    );

    notifyListeners();
  }

  // ============================================================
  // TAMBAH LOYALTY POINT
  // ============================================================

  void addLoyaltyPoints(int points) {

    if (_user == null) return;

    _user = _user!.copyWith(
      loyaltyPoints:
          _user!.loyaltyPoints + points,
    );

    notifyListeners();
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void logout() {

    _user = null;

    _status = AuthStatus.unauthenticated;

    _errorMessage = null;

    notifyListeners();
  }

  // ============================================================
  // CLEAR ERROR
  // ============================================================

  void clearError() {

    _errorMessage = null;

    notifyListeners();
  }

  // ============================================================
  // HELPER BUILD USER
  // ============================================================

  UserModel _buildUserFromMap(
    Map<String, dynamic> data,
  ) {

    final rawAddresses =
        data['addresses'] as List? ?? [];

    final addresses = rawAddresses
        .map(
          (address) => AddressModel.fromMap(
            Map<String, dynamic>.from(address),
          ),
        )
        .toList();

    return UserModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      addresses: addresses,
      loyaltyPoints:
          data['loyaltyPoints'] ?? 0,
    );
  }
}