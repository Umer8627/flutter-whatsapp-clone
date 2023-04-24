

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/constants/color_constant.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/repo/chat_repo.dart';
import 'package:whatsapp_clone/state/user_state.dart';

class BottomChatField extends StatefulWidget {
  final UserModel? recieverUserModel;
  const BottomChatField({super.key, required this.recieverUserModel});

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.green),
                ),
                child: TextField(
                  style: CustomFont.regularText
                      .copyWith(fontWeight: FontWeight.w500),
                  controller: messageController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 15, top: 15, bottom: 15),
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    hintStyle: CustomFont.regularText,
                    isDense: true,
                    suffixIcon: Icon(
                      Icons.attach_file,
                      color: tabColor,
                      size: 24,
                    ),
                  ),
                )),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: tabColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: () async {
                log('while sending message receiverID ${widget.recieverUserModel?.uid}');
                await ChatRepo.instance.sendTextMessage(
                    text: messageController.text,
                    receiverUserModel: widget.recieverUserModel!,
                    senderUser: context.read<UserState>().userModel);
                if (!mounted) return;
                setState(() {
                  messageController.clear();
                });
              },
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
