// ChatPusherService.dart

import 'dart:convert'; // Import this for jsonDecode

import 'package:dio/dio.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../core/api/end_ponits.dart';
import '../../../../core/utils/shared_prefs_helper.dart';

class ChatPusherService {
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  Future<void> initPusher(
      int chatId, {
        required Function(PusherEvent event) onMessageReceived,
      }) async {
    await pusher.init(
      apiKey: "e00c03ce2ed4372ed592",
      cluster: "eu",
      authEndpoint: "${EndPoint.baseUrl}/broadcasting/auth",
      onAuthorizer: (channelName, socketId, options) async {
        final token = await SharedPrefsHelper.instance.getToken();
        final dio = Dio();

        try {
          final response = await dio.post(
            "https://shifaa-backend.onrender.com/broadcasting/auth",
            data: {'channel_name': channelName, 'socket_id': socketId},
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
            ),
          );

          print(
            "✅ Dio Auth Response: ${response.statusCode} => ${response.data}",
          );
          return response.data;
        } catch (e) {
          print("❌ Dio Auth Error: $e");
          return {
            'headers': {'Authorization': 'Bearer $token'},
          };
        }
      },
      onEvent: (event) {
        print("📡 Global Event: ${event.eventName} | Data: ${event.data}");
      },
    );

    await pusher.connect();

    await pusher.subscribe(
      channelName: "presence-chat.$chatId",
      onSubscriptionSucceeded: (data) {
        print("📡 Subscribed to chat.$chatId");
      },
      onSubscriptionError: (message, e) {
        print("❌ Subscription to chat.$chatId failed: $message, error: $e");
      },
      onEvent: (event) {
        if (event.eventName == "message.sent") {
          onMessageReceived(event);
        }
        print("📡 Channel Event: ${event.eventName} | Data: ${event.data}");
      },
    );
  }
}