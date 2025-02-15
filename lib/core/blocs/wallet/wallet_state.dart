abstract class WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final double balance;
  WalletLoaded(this.balance);
}

class WalletError extends WalletState {
  final String error;
  WalletError(this.error);
}

class WalletTransactionSuccess extends WalletState {}
