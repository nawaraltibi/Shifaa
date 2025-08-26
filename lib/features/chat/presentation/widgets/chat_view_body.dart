// ⭐️ لا تنسى إضافة هذا الاستيراد في الأعلى
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart'; // ⭐️ استيراد مهم للملفات المؤقتة
// ⭐️ ---

import 'dart:convert';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shifaa/core/utils/functions/e2ee_service.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:shifaa/features/chat/data/models/message.dart';
import 'package:shifaa/features/chat/data/models/message_status.dart'; // ⭐️ استيراد مهم للحالات
import 'package:shifaa/features/chat/data/pusher/chat_pusher_service.dart';
import 'package:shifaa/features/chat/domain/repositories/chat_repo.dart';
import 'package:shifaa/features/chat/presentation/cubits/get_messages_cubit/get_messages_cubit.dart';
import 'package:shifaa/features/chat/presentation/widgets/chat_message.dart';
import 'package:shifaa/features/chat/presentation/widgets/custom_chat_app_bar.dart';
import 'package:shifaa/features/chat/presentation/widgets/message_composer.dart';

// ---------------- ChatViewBody ----------------
class ChatViewBody extends StatefulWidget {
  final int chatId;
  final String doctorName;
  final String? doctorImage;
  const ChatViewBody({
    super.key,
    required this.chatId,
    required this.doctorName,
    this.doctorImage,
  });

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final ChatPusherService _pusherService = ChatPusherService();
  late TextEditingController _messageController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollToBottom();
      _initPusher();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _disposePusher();
    super.dispose();
  }

  void _disposePusher() {
    // من المهم إلغاء الاشتراك في القناة أولاً
    _pusherService.pusher.unsubscribe(
      channelName: "presence-chat.${widget.chatId}",
    );

    // ثم قطع الاتصال بالكامل
    _pusherService.pusher.disconnect();

    print(
      "✅ Pusher channel unsubscribed and connection disconnected successfully.",
    );
  }

  void _initPusher() async {
    // التحقق من أن الويدجت لا يزال موجوداً في الشجرة قبل البدء
    if (!mounted) return;

    // الوصول إلى Cubit مرة واحدة في البداية
    final getMessagesCubit = context.read<GetMessagesCubit>();

    // --- الخطوة 1: جلب البيانات المحلية اللازمة لمرة واحدة ---
    final myUser = await SharedPrefsHelper.instance.getUserModel();
    final myUserId = myUser.id;
    final myDeviceId = await SharedPrefsHelper.instance.getMyDeviceId();
    final privateKey = await E2EE.loadPrivateKeyFromSecureStorage();

    print(
      "Pusher Init: My User ID is '$myUserId', My Device ID is '$myDeviceId'.",
    );

    // التأكد من وجود المفتاح الخاص قبل المتابعةئ
    if (privateKey == null) {
      print("❌ CRITICAL: Private key not found. Cannot decrypt messages.");
      return;
    }

    // --- الخطوة 2: تهيئة خدمة Pusher مع معالج الرسائل ---
    await _pusherService.initPusher(
      widget.chatId,
      onMessageReceived: (event) async {
        // --- الخطوة 3: معالجة الحدث عند وصول رسالة جديدة ---
        final data = jsonDecode(event.data ?? '{}');
        final msgData = data['message'] as Map<String, dynamic>?;

        if (msgData == null) {
          print("️️⚠️ Pusher event received with no message data.");
          return;
        }

        // --- الخطوة 4: تجاهل رسائلك أنت لتجنب التكرار ---
        final senderId = msgData['sender_id'];
        if (senderId == myUserId) {
          print("✅ Ignored own message from Pusher (Sender ID: $senderId).");
          return;
        }
        print(
          "⬇️ Received a new message from sender ID '$senderId'. Processing...",
        );

        // --- الخطوة 5: البحث عن مفتاح التشفير الخاص بجهازك ---
        final devicesList = msgData['devices'] as List<dynamic>? ?? [];
        final myDeviceData = devicesList.firstWhere(
              (device) => device['id'] == myDeviceId,
          orElse: () => null,
        );

        if (myDeviceData == null) {
          print(
            "❌ Decryption failed: The message was not encrypted for this device (ID: $myDeviceId).",
          );
          return;
        }

        // --- الخطوة 6: فك تشفير الرسالة ---
        try {
          // 6.1: فك تشفير مفتاح AES باستخدام مفتاحك الخاص (RSA)
          final encryptedAesKey = myDeviceData['encrypted_key'] as String;
          final encryptedAesKeyBytes = base64.decode(encryptedAesKey);
          final aesKeyBytes = E2EE.rsaDecryptWithPrivateOAEP(
            privateKey,
            encryptedAesKeyBytes,
          );
          final aesKey = Uint8List.fromList(aesKeyBytes);

          // 6.2: فك تشفير محتوى الرسالة باستخدام مفتاح AES
          final decryptedMsgData = Map<String, dynamic>.from(msgData);
          if (msgData['text'] != null) {
            final encryptedText = msgData['text'] as String;
            final decryptedText = E2EE.aesGcmDecryptFromBase64(
              aesKey,
              encryptedText,
            );
            decryptedMsgData['text'] = decryptedText;
          }
          // (يمكن إضافة منطق مماثل لفك تشفير الملفات هنا إذا لزم الأمر)

          // --- الخطوة 7: إنشاء الرسالة وإضافتها للواجهة ---
          final msg = MessageModel.fromJson(decryptedMsgData);

          // التأكد مرة أخرى من أن الويدجت لا يزال موجوداً قبل تحديث الواجهة
          if (!mounted) return;

          getMessagesCubit.addMessage(msg);
          _scrollToBottom();

          print("✅ Successfully decrypted and displayed message ID ${msg.id}.");
        } catch (e, stackTrace) {
          print("❌ CRITICAL ERROR during message decryption: $e");
          print("Stack Trace: $stackTrace");
        }
      },
    );
  }

  Future<void> _pickAndSendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      print("🕵️‍♂️ [1. PICKER] File picked successfully.");
      print("   - Path: ${file.path}");
      print("   - Exists: ${await file.exists()}");

      _sendMessage(file: file); // استدعاء الدالة العامة
    } else {
      print("❌ [1. PICKER] File picking was cancelled or failed.");
    }
  }

  // ✅✅✅ --- دالة الإرسال الجديدة والذكية --- ✅✅✅

  // في ملف chat_view_body.dart

  // ... (باقي الكود في الملف)

  // ✅✅✅ --- دالة الإرسال الجديدة التي لا تعتمد على الكاش --- ✅✅✅
  void _sendMessage({String? text, File? file, Message? messageToRetry}) async {
    final messagesCubit = context.read<GetMessagesCubit>();
    final repo = context.read<ChatRepository>();

    // --- الخطوة 1: إنشاء الرسالة المؤقتة (تبقى كما هي) ---
    final Message tempMessage;
    final tempId =
        messageToRetry?.id ?? DateTime.now().millisecondsSinceEpoch * -1;

    if (messageToRetry != null) {
      tempMessage = messageToRetry;
      messagesCubit.updateMessageStatus(tempId, MessageStatus.sending);
    } else {
      // في تطبيق المريض، المرسل هو 'patient'
      // في تطبيق الطبيب، المرسل هو 'doctor'
      final myUser = await SharedPrefsHelper.instance.getUserModel();
      tempMessage = Message(
        id: tempId,
        text: text,
        localFilePath: file?.path,
        senderRole: 'patient', // ⭐️ غيري هذه إلى 'doctor' في تطبيق الطبيب
        senderId: myUser.id,
        createdAt: DateTime.now(),
        status: MessageStatus.sending,
      );
      messagesCubit.addMessage(tempMessage);
      _messageController.clear();
      _scrollToBottom();
    }

    // --- الخطوة 2: تحضير البيانات للتشفير والإرسال ---
    try {
      // --- الخطوة 1 (الجديدة): جلب أحدث بيانات المحادثة من الـ API ---
      print("🔄 Fetching latest chat details from API before sending...");
      final latestChatResult = await repo.getChatDetails(widget.chatId);

      final Map<int, String> targets = latestChatResult.fold(
        (failure) {
          print(
            "❌ Could not fetch latest chat details. Sending will likely fail.",
          );
          return {};
        },
        (latestChat) {
          // ✅✅✅ --- هذا هو المنطق الجديد والصحيح --- ✅✅✅
          print("✅ Building targets from live API data...");
          final targetsMap = <int, String>{};

          var doctorDevices = latestChat.doctor!.devices;
          for (var device in doctorDevices) {
            print(
              '-----------------------------------------------------------------------------',
            );
            print(device.id);
          }

          // 1. أضف كل أجهزة الطبيب إلى القائمة
          if (latestChat.doctor != null) {
            for (var device in latestChat.doctor!.devices) {
              // تجاهل أي مفاتيح عامة فارغة أو غير صالحة
              if (device.publicKey.isNotEmpty && device.publicKey != 's') {
                targetsMap[device.id] = device.publicKey;
              }
            }
          }

          // 2. أضف كل أجهزة المريض إلى القائمة
          // (الـ Map سيمنع التكرار تلقائياً)
          if (latestChat.patient != null) {
            for (var device in latestChat.patient!.devices) {
              if (device.publicKey.isNotEmpty && device.publicKey != 's') {
                targetsMap[device.id] = device.publicKey;
              }
            }
          }

          print("🎯 Final targets for encryption: ${targetsMap.keys.toList()}");
          return targetsMap;
        },
      );

      // إذا لم يكن هناك أهداف، لا تكمل
      if (targets.isEmpty) {
        print("❌ No valid targets found after filtering. Aborting send.");
        messagesCubit.updateMessageStatus(tempId, MessageStatus.failed);
        return;
      }

      // --- الخطوة 2.3: التشفير (تبقى كما هي) ---
      final aesKey = E2EE.generateAESKey();
      String? encryptedText;
      File? encryptedFile;
      String? originalFileName; // ✅ 1. عرف متغير هنا للاحتفاظ باسم الملف

      if (tempMessage.text != null && tempMessage.text!.isNotEmpty) {
        encryptedText = E2EE.aesGcmEncryptToBase64(aesKey, tempMessage.text!);
      } else if (tempMessage.localFilePath != null) {
        print("🕵️‍♂️ [2. PRE-ENCRYPT] Preparing file for encryption.");
        print("   - Local Path: ${tempMessage.localFilePath}");
        final fileBytes = await File(tempMessage.localFilePath!).readAsBytes();
        final encryptedBytes = E2EE.aesGcmEncryptToBytes(aesKey, fileBytes);
        final tempDir = await getTemporaryDirectory();
        originalFileName = tempMessage.localFilePath!.split('/').last;
        final fileName = tempMessage.localFilePath!.split('/').last;
        encryptedFile = await File(
          '${tempDir.path}/$fileName.enc',
        ).writeAsBytes(encryptedBytes);
        // 🕵️‍♂️ نقطة تفتيش 3: هل تم تشفير الملف بنجاح؟
        print("🕵️‍♂️ [3. POST-ENCRYPT] File encrypted.");
        print("   - Encrypted Path: ${encryptedFile.path}");
        print("   - Encrypted Exists: ${await encryptedFile.exists()}");
        print("   - Original Name: $originalFileName");
      }

      print("🎯 Final final targets for encryption: ${targets.keys.toList()}");

      final encryptedKeysPayload = E2EE.buildEncryptedKeysPayload(
        targets: targets,
        aesKey: aesKey,
      );
      print("🕵️‍♂️ [4. REPO CALL] Calling repository's sendMessage with:");
      print("   - Text: ${encryptedText != null ? 'Present' : 'null'}");
      print("   - File: ${encryptedFile?.path ?? 'null'}");
      print("   - Original Name: ${originalFileName ?? 'null'}");
      // --- الخطوة 3: إرسال الطلب (تبقى كما هي) ---
      final result = await repo.sendMessage(
        widget.chatId,
        text: encryptedText,
        file: encryptedFile,
        originalFileName: originalFileName, // <-- لم يعد هناك خطأ
        encryptedKeysPayload: encryptedKeysPayload,
      );

      // --- الخطوة 4: معالجة النتيجة (تبقى كما هي) ---
      result.fold(
        (failure) {
          String errorMessage = 'Unknown error';
          errorMessage = failure.message;
          print("❌ Failed to send message: $errorMessage");
          messagesCubit.updateMessageStatus(tempId, MessageStatus.failed);
        },
        (sentMessage) {
          print("✅ Message sent to server. Updating UI immediately.");
          // استدعِ الدالة الجديدة لتحديث الواجهة فوراً
          messagesCubit.replaceTempMessageWithSentMessage(tempId, sentMessage);
        },
      );
    } catch (e) {
      print("❌ Exception while sending message: $e");
      messagesCubit.updateMessageStatus(tempId, MessageStatus.failed);
    }
  }

  // ... (باقي الكود في الملف)

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.hasContentDimensions) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // غيرت الـ AppBar ليكون متوافقاً مع التصميم
      body: Column(
        children: [
          CustomChatAppBar(
            chatId: widget.chatId,
            doctorName: widget.doctorName,
            // يمكنك تمرير الصورة هنا إذا كان الـ AppBar يحتاجها
            doctorImage: widget.doctorImage,
          ),
          Expanded(
            child: BlocBuilder<GetMessagesCubit, GetMessagesState>(
              builder: (context, state) {
                if (state is GetMessagesSuccess) {
                  // ✅✅✅ --- تم إصلاح الخطأ هنا --- ✅✅✅
                  final displayMessages = state.messages;
                  if (displayMessages.isEmpty) {
                    return const Center(
                      child: Text("No messages yet. Start the conversation!"),
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    itemCount: displayMessages.length,
                    itemBuilder: (context, index) {
                      final msg = displayMessages[index];
                      return ChatMessage(
                        message: msg,
                        onRetry: () {
                          // ✅✅✅ --- تم إصلاح الخطأ هنا --- ✅✅✅
                          _sendMessage(messageToRetry: msg);
                        },
                      );
                    },
                  );
                } else if (state is GetMessagesFailure) {
                  return Center(child: Text(state.error));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          buildMessageComposer(
            messageController: _messageController,
            onSendPressed: () {
              if (_messageController.text.trim().isNotEmpty) {
                _sendMessage(text: _messageController.text.trim());
              }
            },
            onAttachmentPressed: _pickAndSendFile,
          ),
        ],
      ),
    );
  }
}

// هذا الوجت يبقى كما هو
