import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/color_constant.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/repo/chat_repo.dart';
import 'package:whatsapp_clone/utills/snippets.dart';
import 'package:whatsapp_clone/views/chat/components/custom_painter.dart';
import 'package:whatsapp_clone/views/chat/components/display_message_type.dart';

class SenderMessageCard extends StatefulWidget {
  final Message message;
  final UserModel receiverUserModel;

  const SenderMessageCard({
    super.key,
    required this.message,
    required this.receiverUserModel,
  });

  @override
  State<SenderMessageCard> createState() => _SenderMessageCardState();
}

class _SenderMessageCardState extends State<SenderMessageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0f3065),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(19),
                        bottomLeft: Radius.circular(19),
                        bottomRight: Radius.circular(19),
                      ),
                    ),
                    child: DisplayMessageWithType(message: widget.message)),
              ),
              CustomPaint(
                  painter: Triangle(
                const Color(0xFF0f3065),
              )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                standardFormatTime(widget.message.timeSent),
                style: CustomFont.lightText
                    .copyWith(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              widget.message.isuploaded == false
                  ? const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey,
                    )
                  : StreamBuilder<bool>(
                      stream: ChatRepo.instance.isMessageRead(
                          contactId: widget.receiverUserModel.uid,
                          messageId: widget.message.messageId),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Icon(
                                Icons.done_all,
                                size: 16,
                                color: tabColor,
                              );
                        }

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
              const SizedBox(width: 4),
            ],
          ),
        ],
      ),
    );
  }
}
