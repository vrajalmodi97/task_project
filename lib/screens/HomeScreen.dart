import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/core/blocs/services/shared_prefs.dart';
import 'package:task_project/core/blocs/wallet/wallet_bloc.dart';
import 'package:task_project/core/blocs/wallet/wallet_event.dart';
import 'package:task_project/core/blocs/wallet/wallet_state.dart';
import 'package:task_project/screens/LoginScreen.dart';
import 'package:task_project/screens/TransactionsScreen.dart';
import 'package:task_project/screens/UserSelectionScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showBalance = true;

  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(LoadWallet(SharedPrefs().userId));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              SharedPrefs.clearSharedPref();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userName = SharedPrefs().name;

    return Scaffold(
      // appBar: AppBar(title: Text('Wallet')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Welcome,\n $userName 👋",
                  maxLines: 2,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.logout, size: 28, color: Colors.red),
                    onPressed: () => _showLogoutDialog(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Manage your transactions seamlessly!",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 30),

            /// Wallet Balance Section
            BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                if (state is WalletLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is WalletLoaded) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text("Your Wallet Balance",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _showBalance
                                    ? 'PHP ${state.balance.toStringAsFixed(2)}'
                                    : 'PHP ******',
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(
                                  _showBalance
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showBalance = !_showBalance;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is WalletError) {
                  return Center(child: Text(state.error));
                } else {
                  return Center(child: Text('Error loading wallet balance'));
                }
              },
            ),

            SizedBox(height: 30),

            /// Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.send,
                  label: "Send Money",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserSelectionScreen()));
                  },
                ),
                _buildActionButton(
                  icon: Icons.history,
                  label: "Transactions",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionsScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Function to create action buttons
  Widget _buildActionButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
