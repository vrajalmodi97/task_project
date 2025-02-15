import 'package:dio/dio.dart';
import 'package:task_project/core/blocs/services/api_service.dart';
import 'package:task_project/core/blocs/services/shared_prefs.dart';
import 'package:task_project/core/models/user.dart';

class WalletRepository {
  final ApiService _apiService = ApiService();

  Future<double> getBalance(String userId) async {
    try {
      Response response = await _apiService.postRequest("/mfind", {
        "dbname": "demo_user",
        "searchquery": {"_id": userId},
      });

      if (response.statusCode == 200) {
        if (response.data["status"]) {
          final user = UserData.fromJson(response.data["data"][0]);
          if (SharedPrefs().userId == userId) {
            SharedPrefs().walletBalance = user.walletBalance ?? 0.0;
          }
          return user.walletBalance ?? 0.0;
        } else {
          throw Exception(response.data["message"] ?? "Server Error");
        }
      } else {
        throw Exception(response.data["message"] ?? "Login failed");
      }
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  Future<void> sendMoney(String senderId, String receiverId, String senderName,
      String receiverName, double amount) async {
    try {
      await _apiService.postRequest("/adddata/demo_wallet", {
        "_id": DateTime.now().millisecondsSinceEpoch.toString(),
        "senderId": senderId,
        "receiverId": receiverId,
        "senderName": senderName,
        "receiverName": receiverName,
        "amount": amount,
        "status": "SUCCESS",
        "createdAt":  DateTime.now().toString(),
      });
    } catch (e) {
      throw Exception("Failed to send money");
    }
  }
}
