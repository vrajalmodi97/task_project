import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_project/core/blocs/services/shared_prefs.dart';
import 'package:task_project/core/blocs/user/user_bloc.dart';
import 'package:task_project/core/blocs/wallet/wallet_bloc.dart';
import 'package:task_project/core/blocs/wallet/wallet_event.dart';
import 'package:task_project/core/blocs/wallet/wallet_state.dart';
import 'package:task_project/core/models/user.dart';

class SendMoneyScreen extends StatefulWidget {
  final UserData recipient;
  SendMoneyScreen({required this.recipient});

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  void _sendMoney() {
    if (!_formKey.currentState!.validate()) return;
    //Fetch sender userid wallet balance
    double amount = double.parse(_amountController.text);
    EasyLoading.show(status: 'Transferring amount');

    BlocProvider.of<WalletBloc>(context)
        .getWalletBalance(SharedPrefs().userId)
        .then((apiResults) {
      if (isNumeric(apiResults)) {
        double senderBalance = double.tryParse(apiResults) ?? 0.0;

        if (amount > senderBalance) {
          EasyLoading.dismiss();
          _showMessageDialog("Error", "Insufficient balance");
          return;
        }

        //Fetch recipient userid wallet balance
        BlocProvider.of<WalletBloc>(context)
            .getWalletBalance(widget.recipient.id!)
            .then((apiResults) {
          if (isNumeric(apiResults)) {
            double recipientalance = double.tryParse(apiResults) ?? 0.0;
            recipientalance = recipientalance + amount;

            //update recipient userid wallet balance
            BlocProvider.of<UserBloc>(context)
                .updateWalletBalance(widget.recipient.id!, recipientalance)
                .then((apiResults) {
              if (apiResults == 'true') {
                senderBalance = senderBalance - amount;

                //update sender userid wallet balance
                BlocProvider.of<UserBloc>(context)
                    .updateWalletBalance(SharedPrefs().userId, senderBalance)
                    .then((apiResults) {
                  if (apiResults == 'true') {
                    //update in history
                    BlocProvider.of<WalletBloc>(context).add(
                      SendMoney(
                        SharedPrefs().userId,
                        widget.recipient.id!,
                        SharedPrefs().name,
                        widget.recipient.name!,
                        amount,
                      ),
                    );
                  } else {
                    EasyLoading.dismiss();
                    _showMessageDialog("Error", apiResults);
                  }
                });
              } else {
                EasyLoading.dismiss();
                _showMessageDialog("Error", apiResults);
              }
            });
          } else {
            EasyLoading.dismiss();
            _showMessageDialog("Error", apiResults);
          }
        });
      } else {
        EasyLoading.dismiss();
        _showMessageDialog("Error", apiResults);
      }
    });
  }

  void _showMessageDialog(String title, String message) {
    // Hide Keyboard Before Showing Dialog
    FocusScope.of(context).unfocus();
    _amountController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the bottom sheet full width
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        width: double.infinity, // Ensures full width
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Makes the button full width
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Money"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Back Button
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipient Information
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      widget.recipient.name![0].toUpperCase(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.recipient.name ?? "No Name",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(widget.recipient.email ?? "No Email",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Balance Display
            BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                if (state is WalletLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is WalletLoaded) {
                  return Text(
                    "Your Balance: PHP ${state.balance.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  );
                } else {
                  return Text("Error loading balance",
                      style: TextStyle(color: Colors.red));
                }
              },
            ),
            SizedBox(height: 20),

            Form(
              key: _formKey,
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Amount",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black87), // Border color when not focused
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Amount cannot be empty";
                  }
                  double? amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return "Enter a valid amount greater than zero";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20),

            // Send Money Button
            BlocConsumer<WalletBloc, WalletState>(
              listener: (context, state) {
                if (state is WalletTransactionSuccess) {
                  EasyLoading.dismiss();
                  _showMessageDialog("Success", "Money sent successfully!");
                } else if (state is WalletError) {
                  EasyLoading.dismiss();
                  _showMessageDialog("Error", "Transaction failed");
                }
              },
              builder: (context, state) {
                return Center(
                  child: ElevatedButton(
                    onPressed: _sendMoney,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Send Money",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
