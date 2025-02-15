import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_project/core/blocs/auth/auth_bloc.dart';
import 'package:task_project/core/blocs/services/shared_prefs.dart';
import 'package:task_project/core/blocs/transactions/transaction_bloc.dart';
import 'package:task_project/core/blocs/user/user_bloc.dart';
import 'package:task_project/core/blocs/wallet/wallet_bloc.dart';
import 'package:task_project/core/repositories/auth_repository.dart';
import 'package:task_project/core/repositories/transaction_repository.dart';
import 'package:task_project/core/repositories/user_repository.dart';
import 'package:task_project/core/repositories/wallet_repository.dart';
import 'package:task_project/screens/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.initSP();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepository())),
        BlocProvider(create: (context) => UserBloc(UserRepository())),
        BlocProvider(create: (context) => WalletBloc(WalletRepository())),
        BlocProvider(
            create: (context) => TransactionBloc(TransactionRepository())),
      ],
      child: MaterialApp(
        title: 'Send Money App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blueAccent, // Set primary color to blueAccent
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue, // Ensures a blue-themed UI
          ).copyWith(
            secondary: Colors.blueAccent, // Accent color
          ),
          // appBarTheme: AppBarTheme(
          //   backgroundColor:
          //       Colors.blueAccent, // Set AppBar color to blueAccent
          //   foregroundColor: Colors.white, // Ensure text/icons are visible
          // ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Button color
              foregroundColor: Colors.white, // Text color
            ),
          ),
        ),
        home: SplashScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
