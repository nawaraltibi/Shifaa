import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifaa/features/chat/data/models/chat.dart';
import '../models/device_model.dart';

class DeviceCacheRepo {
  static String _userDevicesKey(int userId) => 'devices_by_user_$userId';

  static Future<void> upsertDevicesForUser(
      int userId,
      List<DeviceModel> devices,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _userDevicesKey(userId);
    final existing = prefs.getString(key);

    Map<String, String> map = existing != null
        ? Map<String, String>.from(jsonDecode(existing))
        : {};

    for (final d in devices) {
      map['${d.id}'] = d.publicKey;
    }
    await prefs.setString(key, jsonEncode(map));
  }

  static Future<Map<int, String>> getDevicesForUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _userDevicesKey(userId);
    final str = prefs.getString(key);
    if (str == null) return {};
    final raw = Map<String, dynamic>.from(jsonDecode(str));
    return raw.map((k, v) => MapEntry(int.parse(k), v.toString()));
  }

  static Future<bool> hasDevice(int userId, int deviceId) async {
    final map = await getDevicesForUser(userId);
    return map.containsKey(deviceId);
  }

  static Future<void> updateFromChat(Chat chat) async {
    if (chat.doctor != null) {
      await clearCacheForUser(chat.doctor!.id);
    }
    if (chat.patient != null) {
      await clearCacheForUser(chat.patient!.id);
    }

    if (chat.doctor != null) {
      await upsertDevicesForUser(chat.doctor!.id, chat.doctor!.devices);
    }
    if (chat.patient != null) {
      await upsertDevicesForUser(chat.patient!.id, chat.patient!.devices);
    }
  }

  static Future<Map<int, String>> getTargetsForSending({
    required int doctorUserId,
    bool includeMyOtherDevices = true,
    int? myUserId,
    int? myDeviceId,
  }) async {
    final doctorDevices = await getDevicesForUser(doctorUserId);

    if (!includeMyOtherDevices || myUserId == null) {
      return doctorDevices;
    }

    final myDevices = await getDevicesForUser(myUserId);
    if (myDeviceId != null) {
      myDevices.remove(myDeviceId);
    }

    final merged = <int, String>{};
    merged.addAll(doctorDevices);
    merged.addAll(myDevices);
    return merged;
  }

  static Future<void> clearCacheForUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _userDevicesKey(userId);
    await prefs.remove(key);
  }
}
