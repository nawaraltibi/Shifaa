// ⭐️ لا تنسى إضافة هذا الاستيراد في الأعلى
import 'dart:io';
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
  const ChatViewBody({super.key, required this.chatId});

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
    super.dispose();
  }

  void _initPusher() async {
    final getMessagesCubit = context.read<GetMessagesCubit>();
    await _pusherService.initPusher(
      widget.chatId,
      onMessageReceived: (event) {
        final data = jsonDecode(event.data ?? '{}');
        final msgData = data['message'] ?? {};
        final msg = MessageModel.fromJson(msgData);
        getMessagesCubit.addMessage(msg);
        _scrollToBottom();
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
      _sendMessage(file: file); // استدعاء الدالة العامة
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

      if (tempMessage.text != null && tempMessage.text!.isNotEmpty) {
        encryptedText = E2EE.aesGcmEncryptToBase64(aesKey, tempMessage.text!);
      } else if (tempMessage.localFilePath != null) {
        final fileBytes = await File(tempMessage.localFilePath!).readAsBytes();
        final encryptedBytes = E2EE.aesGcmEncryptToBytes(aesKey, fileBytes);
        final tempDir = await getTemporaryDirectory();
        final fileName = tempMessage.localFilePath!.split('/').last;
        encryptedFile = await File(
          '${tempDir.path}/$fileName.enc',
        ).writeAsBytes(encryptedBytes);
      }

      print("🎯 Final final targets for encryption: ${targets.keys.toList()}");

      final encryptedKeysPayload = E2EE.buildEncryptedKeysPayload(
        targets: targets,
        aesKey: aesKey,
      );

      // --- الخطوة 3: إرسال الطلب (تبقى كما هي) ---
      final result = await repo.sendMessage(
        widget.chatId,
        text: encryptedText,
        file: encryptedFile,
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
          const CustomChatAppBar(),
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
