abstract class UserEvent {}

class LoadUsers extends UserEvent {
  final String userId;
  LoadUsers(this.userId);
}

class UpdateWalletBalance extends UserEvent {
  final String userId;
  final double walletBalance;
  UpdateWalletBalance(this.userId, this.walletBalance);
}
