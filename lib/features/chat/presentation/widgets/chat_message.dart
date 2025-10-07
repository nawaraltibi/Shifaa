import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:shifaa/core/utils/app_colors.dart';
import 'package:shifaa/core/utils/functions/e2ee_service.dart';
import 'package:shifaa/core/utils/functions/crypto_helper.dart';
import 'package:shifaa/features/chat/data/models/message.dart';
import 'package:shifaa/features/chat/data/models/message_status.dart';
import 'dart:convert';
import 'dart:typed_data';

import '../../../../core/utils/shared_prefs_helper.dart';


class ChatMessage extends StatelessWidget {
  final Message message;
  final VoidCallback onRetry;

  const ChatMessage({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final bool isMine = message.senderRole == 'patient';

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: isMine ? AppColors.primaryAppColor : const Color(0xFFF0F5F9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: isMine ? Radius.circular(16.r) : Radius.circular(4.r),
              bottomRight: isMine
                  ? Radius.circular(4.r)
                  : Radius.circular(16.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMessageContent(context, isMine),
              SizedBox(height: 4.h),
              _buildTimestampAndStatus(context, isMine),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isMine) {
    final textColor = isMine ? Colors.white : Colors.black87;

    final isImage =
        message.file?.toLowerCase().endsWith('.jpg') == true ||
        message.file?.toLowerCase().endsWith('.jpeg') == true ||
        message.file?.toLowerCase().endsWith('.png') == true;

    final isLocalImage =
        message.localFilePath?.toLowerCase().endsWith('.jpg') == true ||
        message.localFilePath?.toLowerCase().endsWith('.jpeg') == true ||
        message.localFilePath?.toLowerCase().endsWith('.png') == true;

    if (isImage || isLocalImage) {
      return _buildImageMessage();
    }

    if (message.file != null || message.localFilePath != null) {
      return _buildFileMessage(context, textColor);
    }

    return Text(
      message.text ?? '',
      style: TextStyle(color: textColor, fontSize: 15.sp),
    );
  }

  Widget _buildImageMessage() {
    if (message.localFilePath != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(
              File(message.localFilePath!),
              fit: BoxFit.cover,
              width: 200.w,
              height: 200.w,
            ),
          ),
          if (message.status == MessageStatus.sending)
            const CircularProgressIndicator(color: Colors.white),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Image.network(
        message.file!,
        fit: BoxFit.cover,
        width: 200.w,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut,
            child: child,
          );
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: 200.w,
            height: 200.w,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 200.w,
            height: 200.w,
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, color: Colors.red),
          );
        },
      ),
    );
  }

  Widget _buildFileMessage(BuildContext context, Color textColor) {
    final fileName =
        message.localFilePath?.split('/').last ??
        message.file?.split('/').last ??
        'File';
    return GestureDetector(
      onTap: () async {

        final progressNotifier = ValueNotifier<int>(0);

        // show dialog
        showProgressDialog(context, progressNotifier);

        print("Opening file: ${message.file ?? message.localFilePath}");

        final myDeviceId = await SharedPrefsHelper.instance.getMyDeviceId();

        EncryptedKeyTarget? me;
        me = message.encryptedKeys.firstWhere(
              (keyTarget) => keyTarget.deviceId == myDeviceId,
        );

        final priv = await E2EE.loadPrivateKeyFromSecureStorage();

        if(priv == null){
          print('private key is null');
          return;
        }

        Uint8List? aesKey;
        aesKey = E2EE.rsaDecryptWithPrivateOAEP(priv, base64.decode(me.encryptedKey));

        var fileUrl = message.file;

        if(fileUrl == null){
          print('message does not have a file');
          return;
        }

        print("AES key length: ${aesKey.length}");


        final file = await downloadDecryptAndOpenExternal(
            fileUrl,
            aesKey,
            (received, total) {
              if (total == null) {
                // unknown total: show indeterminate or set to -1
                progressNotifier.value = 0;
              } else {
                final pct = ((received / total) * 100).round();
                progressNotifier.value = pct;
              }
            }
        );

        Navigator.of(context, rootNavigator: true).pop();

        if(file == null){
          print('file could not open');
        }

      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insert_drive_file,
              color: textColor.withOpacity(0.8),
              size: 32.w,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                fileName,
                style: TextStyle(color: textColor, fontSize: 14.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (message.status == MessageStatus.sending)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: textColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimestampAndStatus(BuildContext context, bool isMine) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}',
          style: TextStyle(
            color: isMine ? Colors.white70 : Colors.black54,
            fontSize: 11.sp,
          ),
        ),
        if (isMine) ...[SizedBox(width: 5.w), _buildStatusIcon()],
      ],
    );
  }

  Widget _buildStatusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return SizedBox(
          width: 15.w,
          height: 15.w,
          child: const CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Colors.white70,
          ),
        );
      case MessageStatus.sent:
        return Icon(Icons.check, size: 16.w, color: Colors.white70);
      case MessageStatus.failed:
        return GestureDetector(
          onTap: onRetry,
          child: Icon(
            Icons.error_outline,
            size: 16.w,
            color: Colors.red.shade300,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
