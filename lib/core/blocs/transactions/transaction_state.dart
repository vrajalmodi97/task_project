import 'package:task_project/core/models/transaction.dart';

abstract class TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionData> transactions;
  TransactionLoaded(this.transactions);
}

class TransactionError extends TransactionState {}
