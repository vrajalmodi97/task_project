
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_project/core/utils/constants.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  static initSP() async =>
      _sharedPrefs ??= await SharedPreferences.getInstance();

  static clearSharedPref() async => await _sharedPrefs?.clear();

  set isLoggedIn(bool? value) =>
      _sharedPrefs?.setBool(kIsLoggedIn, value ?? false);

  bool get isLoggedIn => _sharedPrefs?.getBool(kIsLoggedIn) ?? false;

  set deviceId(String? value) =>
      _sharedPrefs?.setString(kDeviceId, value ?? "");

  String get deviceId => _sharedPrefs?.getString(kDeviceId) ?? "";

  set userId(String? value) => _sharedPrefs?.setString(kUserId, value ?? "");

  String get userId => _sharedPrefs?.getString(kUserId) ?? "";

  set name(String? value) =>
      _sharedPrefs?.setString(kName, value ?? "");

  String get name => _sharedPrefs?.getString(kName) ?? "";

  set firstName(String? value) =>
      _sharedPrefs?.setString(kFirstName, value ?? "");

  String get firstName => _sharedPrefs?.getString(kFirstName) ?? "";

  set lastName(String? value) =>
      _sharedPrefs?.setString(kLastName, value ?? "");

  String get lastName => _sharedPrefs?.getString(kLastName) ?? "";

  set emailId(String? value) => _sharedPrefs?.setString(kEmailId, value ?? "");

  String get emailId => _sharedPrefs?.getString(kEmailId) ?? "";

  set phoneNumber(String? value) =>
      _sharedPrefs?.setString(kPhoneNumber, value ?? "");

  String get phoneNumber => _sharedPrefs?.getString(kPhoneNumber) ?? "";

  set deviceInfo(String? value) =>
      _sharedPrefs?.setString(kDeviceInfo, value ?? "");

  String get deviceInfo => _sharedPrefs?.getString(kDeviceInfo) ?? "";

  set walletBalance(double? value) =>
      _sharedPrefs?.setDouble(kDeviceInfo, value ?? 0.0);

  double get walletBalance => _sharedPrefs?.getDouble(kDeviceInfo) ?? 0.0;
}
