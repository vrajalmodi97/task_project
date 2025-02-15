import 'package:dio/dio.dart';
import 'package:task_project/core/blocs/services/api_service.dart';
import 'package:task_project/core/blocs/services/shared_prefs.dart';
import 'package:task_project/core/models/user.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  Future<List<UserData>> fetchUsers() async {
    try {
      Response response = await _apiService.postRequest("/mfind", {
        "dbname": "demo_user",
        "searchquery": {
          "_id": {"\$ne": SharedPrefs().userId.toString()}
        },
      });

      if (response.statusCode == 200) {
        if (response.data["status"]) {
          List<dynamic> data = response.data["data"];
          return data.map((user) => UserData.fromJson(user)).toList();
        } else {
          throw Exception(response.data["message"] ?? "No User Found...");
        }
      } else {
        throw Exception(response.data["message"] ?? "Login failed");
      }
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  Future<String> upadetWalletBalance(
    String userId,
    double amount,
  ) async {
    try {
      Response response = await _apiService.postRequest(
          "/adddata/demo_user", {"_id": userId, "walletBalance": amount});

      if (response.statusCode == 200) {
        if (response.data["status"]) {
          return response.data["status"].toString();
        } else {
          throw Exception(response.data["message"] ?? "No User Found...");
        }
      } else {
        throw Exception(response.data["message"] ?? "Login failed");
      }
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }
}
