import 'package:dio/dio.dart';
import 'package:task_project/core/blocs/services/api_service.dart';
import 'package:task_project/core/models/transaction.dart';

class TransactionRepository {
  final ApiService _apiService = ApiService();

  Future<List<TransactionData>> getTransactions(String userId) async {
    try {
      Response response = await _apiService.postRequest("/mfind", {
        "dbname": "demo_wallet",
        "searchquery": {"senderId": userId},
      });

      if (response.statusCode == 200) {
        if (response.data["status"]) {
          List<dynamic> data = response.data["data"];
          return data.map((user) => TransactionData.fromJson(user)).toList();
        } else {
          throw Exception(
              response.data["message"] ?? "No Transcations Found...");
        }
      } else {
        throw Exception(response.data["message"] ?? "Transcations failed");
      }
    } catch (e) {
      throw Exception("Transcations failed: ${e.toString()}");
    }
  }
}
