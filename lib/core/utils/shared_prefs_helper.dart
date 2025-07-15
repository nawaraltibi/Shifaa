import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifaa/core/models/user_model_local.dart';

class SharedPrefsHelper {
  static const String _keyAlreadyLaunched = 'alreadyLaunched';
  static const String _keyToken = 'token';

  // Singleton
  SharedPrefsHelper._();
  static final SharedPrefsHelper instance = SharedPrefsHelper._();

  // ✅ تحقق إنو أول مرة تشغيل
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyLaunched = prefs.getBool(_keyAlreadyLaunched) ?? false;
    return !alreadyLaunched;
  }

  // ✅ تعليم أنه تم تشغيل التطبيق من قبل
  Future<void> setAlreadyLaunched() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAlreadyLaunched, true);
  }

  // ✅ حفظ التوكين
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  // ✅ استرجاع التوكين
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // ✅ حذف التوكين (مثلاً عند تسجيل الخروج)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  Future<void> saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', user['first_name'] ?? '');
    await prefs.setString('last_name', user['last_name'] ?? '');
    await prefs.setString('gender', user['gender'] ?? '');
    await prefs.setString('dob', user['patient']?['date_of_birth'] ?? '');
  }

  Future<UserLocalModel> getUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    return UserLocalModel(
      firstName: prefs.getString('first_name') ?? '',
      lastName: prefs.getString('last_name') ?? '',
      gender: prefs.getString('gender') ?? '',
      dateOfBirth: prefs.getString('dob') ?? '',
    );
  }
}
