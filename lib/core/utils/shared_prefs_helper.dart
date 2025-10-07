import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifaa/core/models/user_model_local.dart';

class SharedPrefsHelper {
  static const String _keyAlreadyLaunched = 'alreadyLaunched';
  static const String _keyToken = 'token';
  static const String _keyPublicKey = 'publicKey';
  static const String _keyPrivateKey = 'privateKey';
  static const String _keyPublicKeySentToServer = 'publicKeySentToServer';
  static const String _keyDeviceId = 'deviceId';
  static const String _keyDeviceFingerprint = 'deviceFingerprint';
  static const String _keyDeviceName = 'deviceName';

  SharedPrefsHelper._();

  static final SharedPrefsHelper instance = SharedPrefsHelper._();

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_keyAlreadyLaunched) ?? false);
  }

  Future<void> setAlreadyLaunched() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAlreadyLaunched, true);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  Future<void> saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', user['id'] ?? 0);
    await prefs.setString('first_name', user['first_name'] ?? '');
    await prefs.setString('last_name', user['last_name'] ?? '');
    await prefs.setString('username', user['username'] ?? '');
    await prefs.setString('gender', user['gender'] ?? '');
    final patient = user['patient'] ?? {};
    await prefs.setInt('patient_id', patient['id'] ?? 0);
    await prefs.setString('date_of_birth', patient['date_of_birth'] ?? '');
    await prefs.setInt('age', patient['age'] ?? 0);
    await prefs.setString('beamsId', patient['beamsId'] ?? '');
    if (patient['weight'] != null)
      await prefs.setDouble('weight', (patient['weight'] as num).toDouble());
    if (patient['height'] != null)
      await prefs.setDouble('height', (patient['height'] as num).toDouble());
  }

  Future<UserLocalModel> getUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    return UserLocalModel(
      id: prefs.getInt('id') ?? 0,
      firstName: prefs.getString('first_name') ?? '',
      lastName: prefs.getString('last_name') ?? '',
      username: prefs.getString('username') ?? '',
      gender: prefs.getString('gender') ?? '',
      patientId: prefs.getInt('patient_id') ?? 0,
      dateOfBirth: prefs.getString('date_of_birth'),
      age: prefs.getInt('age'),
      weight: prefs.getDouble('weight'),
      height: prefs.getDouble('height'),
      beamsId: prefs.getString('beamsId') ?? '',
    );
  }

  Future<void> savePublicKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPublicKey, key);
  }

  Future<String?> getPublicKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPublicKey);
  }

  Future<void> savePrivateKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPrivateKey, key);
  }

  Future<String?> getPrivateKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPrivateKey);
  }

  Future<bool> hasKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPublicKey) != null;
  }

  Future<void> setPublicKeySentToServer(bool sent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPublicKeySentToServer, sent);
  }

  Future<bool> getPublicKeySentToServer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPublicKeySentToServer) ?? false;
  }

  Future<void> saveMyDeviceInfo({
    required int id,
    required String fingerprint,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDeviceId, id);
    await prefs.setString(_keyDeviceFingerprint, fingerprint);
    await prefs.setString(_keyDeviceName, name);
  }

  Future<int?> getMyDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyDeviceId);
  }

  Future<String?> getMyDeviceFingerprint() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDeviceFingerprint);
  }

  Future<String?> getMyDeviceName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDeviceName);
  }

  Future<void> clearMyDeviceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDeviceId);
    await prefs.remove(_keyDeviceFingerprint);
    await prefs.remove(_keyDeviceName);
  }
}
