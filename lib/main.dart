// // ============================================================
// // MAIN.DART
// // Entry point aplikasi Marlo Marketplace
// // ============================================================

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/date_symbol_data_local.dart';

// // CONTROLLERS
// import 'controllers/product_controller.dart';
// import 'controllers/cart_controller.dart';
// import 'controllers/user_controller.dart';
// import 'controllers/transaction_controller.dart';

// // SCREENS
// import 'views/home_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Inisialisasi locale Indonesia untuk formatter tanggal
//   await initializeDateFormatting('id_ID', null);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => ProductController(),
//         ),

//         ChangeNotifierProvider(
//           create: (_) => CartController(),
//         ),

//         ChangeNotifierProvider(
//           create: (_) => TransactionController(),
//         ),

//         ChangeNotifierProvider(
//           create: (_) {
//             final userController = UserController();
//             userController.initialize();
//             return userController;
//           },
//         ),
//       ],

//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Marlo Marketplace',

//         theme: ThemeData(
//           useMaterial3: true,
//           primarySwatch: Colors.blue,
//           scaffoldBackgroundColor: const Color(0xFFF5F7FA),

//           appBarTheme: const AppBarTheme(
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.black,
//             elevation: 0,
//             centerTitle: true,
//           ),
//         ),

//         home: const HomeScreen(),
//       ),
//     );
//   }
// }

// ============================================================
// MAIN.DART
// Entry point aplikasi Marlo Marketplace
// ============================================================

// ============================================================
// MAIN.DART
// Entry point aplikasi Marlo Marketplace
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

// CONTROLLERS
import 'controllers/auth_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/transaction_controller.dart';

// SCREENS
import 'views/login_screen.dart';
import 'views/main_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Locale Indonesia
  await initializeDateFormatting(
    'id_ID',
    null,
  );

  runApp(
    const MyApp(),
  );
}

// ============================================================
// MY APP
// ============================================================

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        // AUTH
        ChangeNotifierProvider(
          create: (_) {

            final auth = AuthController();

            auth.initialize();

            return auth;
          },
        ),

        // PRODUCT
        ChangeNotifierProvider(
          create: (_) => ProductController(),
        ),

        // CART
        ChangeNotifierProvider(
          create: (_) => CartController(),
        ),

        // TRANSACTION
        ChangeNotifierProvider(
          create: (_) => TransactionController(),
        ),

        // USER
        ChangeNotifierProvider(
          create: (_) {

            final userController =
                UserController();

            userController.initialize();

            return userController;
          },
        ),
      ],

      child: MaterialApp(

        debugShowCheckedModeBanner: false,

        title: 'Marlo Marketplace',

        theme: ThemeData(

          useMaterial3: true,

          primarySwatch: Colors.blue,

          scaffoldBackgroundColor:
              const Color(0xFFF5F7FA),

          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
          ),
        ),

        // HALAMAN AWAL
        home: const RootScreen(),
      ),
    );
  }
}

// ============================================================
// ROOT SCREEN
// Mengecek user login atau belum
// ============================================================

class RootScreen extends StatelessWidget {

  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<AuthController>(

      builder: (_, auth, __) {

        // LOADING
        if (auth.isLoading) {

          return const Scaffold(

            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // SUDAH LOGIN
        if (auth.isAuthenticated) {

          return const MainScreen();
        }

        // BELUM LOGIN
        return const LoginScreen();
      },
    );
  }
}