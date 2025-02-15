import 'package:task_project/core/blocs/services/shared_prefs.dart';

class TransactionData {
  String? id;
  double? amount;
  String? senderId;
  String? receiverId;
  String? senderName;
  String? receiverName;
  String? status;
  String? createdAt;

  TransactionData({
    this.id,
    this.amount,
    this.senderId,
    this.receiverId,
    this.senderName,
    this.receiverName,
    this.status,
    this.createdAt,
  });

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    amount = json['amount']?.toDouble();
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    senderName = json['senderName'];
    receiverName = json['receiverName'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  /// Use this JSON when adding a new transaction
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = DateTime.now().millisecondsSinceEpoch.toString();
    data['amount'] = amount;
    data['senderId'] = SharedPrefs().userId.toString();
    data['receiverId'] = receiverId;
    data['senderName'] = senderName;
    data['receiverName'] = receiverName;
    data['status'] = status ?? "pending";
    data['createdAt'] = DateTime.now().toString();
    return data;
  }
}
