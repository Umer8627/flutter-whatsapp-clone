import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/color_constant.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/repo/chat_repo.dart';

class SenderMessageCard extends StatefulWidget {
  final Message message;
  final UserModel receiverUserModel;
  const SenderMessageCard(
      {super.key, required this.message, required this.receiverUserModel});

  @override
  State<SenderMessageCard> createState() => _SenderMessageCardState();
}

class _SenderMessageCardState extends State<SenderMessageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                color: Color(0xFF0f3065),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 12, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message.text,
                      style: CustomFont.regularText
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:  [
                      const   Text(
                          '12:00pm',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                       const SizedBox(width: 4),
                        StreamBuilder<bool>(
                          stream: ChatRepo.instance.isMessageRead(contactId: widget.receiverUserModel.uid, messageId: widget.message.messageId),
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }
                            log(snapshot.data.toString());
                            return snapshot.data == true
                                ? const Icon(
                                    Icons.done_all,
                                    size: 16,
                                    color: tabColor,
                                  )
                                : const Icon(
                                    Icons.done_all,
                                    size: 16,
                                    color: Colors.grey,
                                  );
                          },
                        ),
                       const  SizedBox(width: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
