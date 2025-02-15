import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/core/blocs/services/shared_prefs.dart';
import 'package:task_project/core/blocs/transactions/transaction_bloc.dart';
import 'package:task_project/core/blocs/transactions/transaction_event.dart';
import 'package:task_project/core/blocs/transactions/transaction_state.dart';
import 'package:task_project/core/models/transaction.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadTransactions(SharedPrefs().userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction History')),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            return ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final TransactionData transaction = state.transactions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: CircleAvatar(
                      backgroundColor: transaction.status == "SUCCESS"
                          ? Colors.green
                          : Colors.red,
                      child: Icon(
                        transaction.status == "SUCCESS"
                            ? Icons.check
                            : Icons.error,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      '${transaction.senderName} → ${transaction.receiverName}',
                      softWrap: true,
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${transaction.status}',
                            style: TextStyle(
                                color: transaction.status == "SUCCESS"
                                    ? Colors.green
                                    : Colors.red)),
                        Text(
                            'Amount: PHP ${transaction.amount?.toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Error loading transactions'));
          }
        },
      ),
    );
  }
}
