import 'package:dio/dio.dart';
import 'package:task_project/core/blocs/services/api_service.dart';
import 'package:task_project/core/blocs/services/shared_prefs.dart';
import 'package:task_project/core/models/user.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<UserData> login(String email, String password) async {
    try {
      Response response = await _apiService.postRequest("/mfind", {
        "dbname": "demo_user",
        "searchquery": {"email": email, "password": password},
      });

      if (response.statusCode == 200) {
        if (response.data["status"]) {
          return UserData.fromJson(response.data["data"][0]);
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

  Future<String> register(
      String name, String email, String phoneNumber, String password) async {
    try {
      String userId = DateTime.now().millisecondsSinceEpoch.toString();
      Response response = await _apiService.postRequest("/adddata/demo_user", {
        "_id": userId,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "walletBalance": 500.0,
        "role": "user",
        "token": "",
        "status": "active",
        "createdAt": DateTime.now().toString(),
      });

      if (response.statusCode == 200) {
        if (response.data["status"]) {
          SharedPrefs().userId = userId;
          SharedPrefs().name = name;
          SharedPrefs().emailId = email;
          SharedPrefs().phoneNumber = phoneNumber;
          SharedPrefs().walletBalance = 500.0;
          return response.data["message"].toString();
        } else {
          throw Exception(response.data["message"] ?? "Registration failed");
        }
      } else {
        throw Exception(response.data["message"] ?? "Registration failed");
      }
    } catch (e) {
      throw Exception("Registration failed: ${e.toString()}");
    }
  }
}
