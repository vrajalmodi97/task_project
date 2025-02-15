import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/core/blocs/services/shared_prefs.dart';
import 'package:task_project/core/blocs/wallet/wallet_bloc.dart';
import 'package:task_project/core/blocs/wallet/wallet_event.dart';
import 'package:task_project/core/blocs/wallet/wallet_state.dart';
import 'package:task_project/screens/TransactionsScreen.dart';
import 'package:task_project/screens/UserSelectionScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showBalance = true;
  // double balance = 500.00;

  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(LoadWallet(SharedPrefs().userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wallet')),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is WalletLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WalletLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        _showBalance
                            ? 'PHP ${state.balance.toStringAsFixed(2)}'
                            : '******',
                        style: TextStyle(fontSize: 24)),
                    IconButton(
                      icon: Icon(_showBalance
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _showBalance = !_showBalance;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserSelectionScreen()));
                    },
                    child: Text('Send Money')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionsScreen()));
                    },
                    child: Text('View Transactions')),
              ],
            );
          } else if (state is WalletError) {
            return Center(child: Text(state.error));
          } else {
            return Center(child: Text('Error loading transactions'));
          }
        },
      ),
    );
  }
}
