abstract class WalletEvent {}

class LoadWallet extends WalletEvent {
  final String userId;
  LoadWallet(this.userId);
}

class SendMoney extends WalletEvent {
  final String senderId;
  final String recipientId;
  final String senderName;
  final String recipientName;
  final double amount;

  SendMoney(this.senderId, this.recipientId, this.senderName,
      this.recipientName, this.amount);
}
