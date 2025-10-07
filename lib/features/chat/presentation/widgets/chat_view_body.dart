import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shifaa/core/utils/functions/e2ee_service.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:shifaa/features/chat/data/models/message.dart';
import 'package:shifaa/features/chat/data/models/message_status.dart';
import 'package:shifaa/features/chat/data/pusher/chat_pusher_service.dart';
import 'package:shifaa/features/chat/domain/repositories/chat_repo.dart';
import 'package:shifaa/features/chat/presentation/cubits/get_messages_cubit/get_messages_cubit.dart';
import 'package:shifaa/features/chat/presentation/widgets/chat_message.dart';
import 'package:shifaa/features/chat/presentation/widgets/custom_chat_app_bar.dart';
import 'package:shifaa/features/chat/presentation/widgets/message_composer.dart';

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
    _pusherService.pusher.unsubscribe(
      channelName: "presence-chat.${widget.chatId}",
    );
    _pusherService.pusher.disconnect();
  }

  void _initPusher() async {
    if (!mounted) return;
    final getMessagesCubit = context.read<GetMessagesCubit>();
    final myUser = await SharedPrefsHelper.instance.getUserModel();
    final myUserId = myUser.id;
    final myDeviceId = await SharedPrefsHelper.instance.getMyDeviceId();
    final privateKey = await E2EE.loadPrivateKeyFromSecureStorage();
    if (privateKey == null) return;

    await _pusherService.initPusher(
      widget.chatId,
      onMessageReceived: (event) async {
        final data = jsonDecode(event.data ?? '{}');
        final msgData = data['message'] as Map<String, dynamic>?;
        if (msgData == null) return;
        final senderId = msgData['sender_id'];
        if (senderId == myUserId) return;
        final devicesList = msgData['devices'] as List<dynamic>? ?? [];
        final myDeviceData = devicesList.firstWhere(
              (device) => device['id'] == myDeviceId,
          orElse: () => null,
        );
        if (myDeviceData == null) return;
        try {
          final encryptedAesKey = myDeviceData['encrypted_key'] as String;
          final encryptedAesKeyBytes = base64.decode(encryptedAesKey);
          final aesKeyBytes = E2EE.rsaDecryptWithPrivateOAEP(
            privateKey,
            encryptedAesKeyBytes,
          );
          final aesKey = Uint8List.fromList(aesKeyBytes);
          final decryptedMsgData = Map<String, dynamic>.from(msgData);
          if (msgData['text'] != null) {
            final encryptedText = msgData['text'] as String;
            final decryptedText = E2EE.aesGcmDecryptFromBase64(
              aesKey,
              encryptedText,
            );
            decryptedMsgData['text'] = decryptedText;
          }
          final msg = MessageModel.fromJson(decryptedMsgData);
          if (!mounted) return;
          getMessagesCubit.addMessage(msg);
          _animateToBottom();
        } catch (_) {}
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
      _sendMessage(file: file);
    }
  }

  void _sendMessage({String? text, File? file, Message? messageToRetry}) async {
    final messagesCubit = context.read<GetMessagesCubit>();
    final repo = context.read<ChatRepository>();
    final Message tempMessage;
    final tempId = messageToRetry?.id ?? DateTime.now().millisecondsSinceEpoch * -1;
    if (messageToRetry != null) {
      tempMessage = messageToRetry;
      messagesCubit.updateMessageStatus(tempId, MessageStatus.sending);
    } else {
      final myUser = await SharedPrefsHelper.instance.getUserModel();
      tempMessage = Message(
        id: tempId,
        text: text,
        localFilePath: file?.path,
        senderRole: 'patient',
        senderId: myUser.id,
        createdAt: DateTime.now(),
        status: MessageStatus.sending,
      );
      messagesCubit.addMessage(tempMessage);
      _messageController.clear();
      _animateToBottom();
    }
    try {
      final latestChatResult = await repo.getChatDetails(widget.chatId);
      final Map<int, String> targets = latestChatResult.fold(
            (failure) => {},
            (latestChat) {
          final targetsMap = <int, String>{};
          if (latestChat.doctor != null) {
            for (var device in latestChat.doctor!.devices) {
              if (device.publicKey.isNotEmpty && device.publicKey != 's') {
                targetsMap[device.id] = device.publicKey;
              }
            }
          }
          if (latestChat.patient != null) {
            for (var device in latestChat.patient!.devices) {
              if (device.publicKey.isNotEmpty && device.publicKey != 's') {
                targetsMap[device.id] = device.publicKey;
              }
            }
          }
          return targetsMap;
        },
      );
      if (targets.isEmpty) {
        messagesCubit.updateMessageStatus(tempId, MessageStatus.failed);
        return;
      }
      final aesKey = E2EE.generateAESKey();
      String? encryptedText;
      File? encryptedFile;
      String? originalFileName;
      if (tempMessage.text != null && tempMessage.text!.isNotEmpty) {
        encryptedText = E2EE.aesGcmEncryptToBase64(aesKey, tempMessage.text!);
      } else if (tempMessage.localFilePath != null) {
        final fileBytes = await File(tempMessage.localFilePath!).readAsBytes();
        final encryptedBytes = E2EE.aesGcmEncryptToBytes(aesKey, fileBytes);
        final tempDir = await getTemporaryDirectory();
        originalFileName = tempMessage.localFilePath!.split('/').last;
        final fileName = tempMessage.localFilePath!.split('/').last;
        encryptedFile = await File('${tempDir.path}/$fileName.enc').writeAsBytes(encryptedBytes);
      }
      final encryptedKeysPayload = E2EE.buildEncryptedKeysPayload(targets: targets, aesKey: aesKey);
      final result = await repo.sendMessage(
        widget.chatId,
        text: encryptedText,
        file: encryptedFile,
        originalFileName: originalFileName,
        encryptedKeysPayload: encryptedKeysPayload,
      );
      result.fold(
            (failure) => messagesCubit.updateMessageStatus(tempId, MessageStatus.failed),
            (sentMessage) => messagesCubit.replaceTempMessageWithSentMessage(tempId, sentMessage),
      );
    } catch (_) {
      messagesCubit.updateMessageStatus(tempId, MessageStatus.failed);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && _scrollController.position.hasContentDimensions) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _animateToBottom() {
    if (_scrollController.hasClients && _scrollController.position.hasContentDimensions) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomChatAppBar(
            chatId: widget.chatId,
            doctorName: widget.doctorName,
            doctorImage: widget.doctorImage,
          ),
          Expanded(
            child: BlocListener<GetMessagesCubit, GetMessagesState>(
              listener: (context, state) {
                if (state is GetMessagesSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                }
              },
              child: BlocBuilder<GetMessagesCubit, GetMessagesState>(
                builder: (context, state) {
                  if (state is GetMessagesSuccess) {
                    final displayMessages = state.messages;
                    if (displayMessages.isEmpty) {
                      return const Center(
                        child: Text("No messages yet. Start the conversation!"),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      itemCount: displayMessages.length,
                      itemBuilder: (context, index) {
                        final msg = displayMessages[index];
                        return ChatMessage(
                          message: msg,
                          onRetry: () => _sendMessage(messageToRetry: msg),
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
