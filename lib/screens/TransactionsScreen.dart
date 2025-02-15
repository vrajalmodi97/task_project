import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "Unknown Date";

    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return "Invalid Date";
    }
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
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final TransactionData transaction = state.transactions[index];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sender → Receiver
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${transaction.senderName} → ${transaction.receiverName}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              transaction.status == "SUCCESS"
                                  ? Icons.check_circle
                                  : Icons.error,
                              color: transaction.status == "SUCCESS"
                                  ? Colors.green
                                  : Colors.red,
                              size: 24,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Amount + Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PHP ${transaction.amount?.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            Text(
                              transaction.status.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: transaction.status == "SUCCESS"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Formatted Date
                        Text(
                          'Date: ${formatDate(transaction.createdAt)}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'No transactions found!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }
        },
      ),
    );
  }
}
