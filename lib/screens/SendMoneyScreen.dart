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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Money")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Recipient: ${widget.recipient.name}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                if (state is WalletLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is WalletLoaded) {
                  return Text(
                      "Your Balance: PHP ${state.balance.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 16));
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
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(labelText: "Enter Amount"),
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
            BlocConsumer<WalletBloc, WalletState>(
              listener: (context, state) {
                if (state is WalletTransactionSuccess) {
                  _showMessageDialog("Success", "Money sent successfully!");
                } else if (state is WalletError) {
                  _showMessageDialog("Error", "Transaction failed");
                }
              },
              builder: (context, state) {
                return Center(
                  child: ElevatedButton(
                    onPressed: _sendMoney,
                    child: Text("Send Money"),
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
