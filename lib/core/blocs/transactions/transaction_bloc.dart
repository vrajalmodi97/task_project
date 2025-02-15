import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_project/core/blocs/transactions/transaction_event.dart';
import 'package:task_project/core/blocs/transactions/transaction_state.dart';
import 'package:task_project/core/repositories/transaction_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionBloc(this.transactionRepository) : super(TransactionLoading()) {
    on<LoadTransactions>((event, emit) async {
      try {
        final transactions = await transactionRepository.getTransactions(event.userId);
        emit(TransactionLoaded(transactions));
      } catch (_) {
        emit(TransactionError());
      }
    });
  }
}
