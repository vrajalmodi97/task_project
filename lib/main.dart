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
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
