abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent {
  final String userId;
  LoadTransactions(this.userId);
}
