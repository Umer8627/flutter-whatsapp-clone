import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/enums/message_enum.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/repo/chat_repo.dart';

class ChatState extends ChangeNotifier {
  bool isFileIconClick = false;
  bool isSendButtonIcon = false;

  void setFileIconClick(bool val) {
    isFileIconClick = val;
    notifyListeners();
  }

  void setSendButtonIcon(bool val) {
    isSendButtonIcon = val;
    notifyListeners();
  }

  Future<void> sendFileMessage({
    required File galleryImage,
    required UserModel receiverUserModel,
    required UserModel senderUser,
    required BuildContext context,
    String? caption,
  }) async {
    try {
      await ChatRepo.instance.sendFileMessage(
        messageType: MessageEnum.image,
        receiverUserModel: receiverUserModel,
        senderUser: senderUser,
        file: galleryImage,
        caption: caption,
        context: context,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  void pickImageFromCamera({required File cameraImage}) {}
}
