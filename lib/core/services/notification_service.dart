import 'package:pusher_beams/pusher_beams.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart';

import '../models/user_model_local.dart';

class NotificationService {
  static Future<String?> _getUserId() async {
    final sharedPref = SharedPrefsHelper.instance;
    UserLocalModel user = await sharedPref.getUserModel();
    final beamsId = user.beamsId;
    print ('beamsId: ${beamsId}');
    return beamsId;
  }

  static Future<String?> _getAuthToken() async {
    // 3. استخدم الكلاس الذي بنيته لجلب التوكن
    return await SharedPrefsHelper.instance.getToken();
  }

  static const _instanceId = '779f8602-f480-4c8a-a429-29f3bd06b930';
  static Future<void> init() async {
    try {
      print('🔄 Initializing Pusher Beams...');

      await PusherBeams.instance.start(_instanceId);
      print('✅ Pusher Beams instance started successfully');
      await PusherBeams.instance.addDeviceInterest('debug-hello');
      await PusherBeams.instance.addDeviceInterest('all');
      print('✅ Subscribed to debug channel');
      _listenForNotifications();
      print('✅ Notification listeners configured');
    } catch (e, stackTrace) {
      print('❌ Error initializing Pusher Beams: $e');
      print('Stack trace: $stackTrace');
      // You might want to handle this error in your app's UI
    }
  }

  static void _listenForNotifications() {
    PusherBeams.instance.onMessageReceivedInTheForeground((notification) {
      print('📬 New notification received:');
      final Map<String, dynamic> notificationData = Map<String, dynamic>.from(
        notification,
      );
      final title = notificationData['title'] as String?;
      final body = notificationData['body'] as String?;
      final data = notificationData['data'] as Map<String, dynamic>?;
      print('Title: $title');
      print('Body: $body');
      print('Additional Data: $data');
    });
  }

  static Future<void> login() async {
    try {
      print('🔄 Starting user authentication for notifications...');

      final userId = await _getUserId();
      if (userId == null || userId.isEmpty) {
        print('❌ Authentication failed: No user ID available');
        return;
      }

      final authToken = await _getAuthToken();
      if (authToken == null || authToken.isEmpty) {
        print('❌ Authentication failed: Token is null or empty.');
        return;
      }
      final beamsAuthProvider = BeamsAuthProvider()
        ..authUrl = 'https://shifaa-backend.onrender.com/api/beams-token'
        ..headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        }
        ..queryParams = {}
        ..credentials = 'omit';

      print('🔄 Associating device with user ID: $userId');
      await PusherBeams.instance.setUserId(userId, beamsAuthProvider, (error) {
        if (error != null) {
          print('❌ Failed to associate device with user: $error');
        } else {
          print('✅ Successfully authenticated user with Pusher Beams, id: ${userId}');
        }
      });
    } catch (e, stackTrace) {
      print('❌ Error during notification login: $e');
      print('Stack trace: $stackTrace');
    }
  }

  static Future<void> logout() async {
    try {
      print('🔄 Logging out user from notification service...');

      await PusherBeams.instance.clearDeviceInterests();
      print('✅ Cleared device interests');

      await PusherBeams.instance.clearAllState();
      print('✅ Cleared all Pusher Beams state');

      await PusherBeams.instance.start(_instanceId);
      print('✅ Reinitialized Pusher Beams for public notifications');

      await PusherBeams.instance.addDeviceInterest('debug-hello');
      print('✅ Resubscribed to debug channel');
    } catch (e, stackTrace) {
      print('❌ Error during notification logout: $e');
      print('Stack trace: $stackTrace');
    }
  }
}
