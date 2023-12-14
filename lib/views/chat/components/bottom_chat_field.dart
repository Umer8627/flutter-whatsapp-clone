import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/constants/color_constant.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/repo/chat_repo.dart';
import 'package:whatsapp_clone/state/chat_state.dart';
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
                child: TextFormField(
                  onChanged: (val) {
                    final chatState =
                        Provider.of<ChatState>(context, listen: false);
                    if (val.trim().isNotEmpty) {
                      chatState.setSendButtonIcon(true);
                    } else {
                      chatState.setSendButtonIcon(false);
                    }
                  },
                  style: CustomFont.regularText
                      .copyWith(fontWeight: FontWeight.w500),
                  controller: messageController,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    hintStyle: CustomFont.regularText,
                    isDense: true,
                    prefixIcon: GestureDetector(
                      onTap: () {},
                      child: const Icon(Icons.emoji_emotions_outlined,
                          color: Colors.grey, size: 24),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        final chatState =
                            Provider.of<ChatState>(context, listen: false);
                        chatState.setFileIconClick(true);
                      },
                      child: const Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                )),
          ),
          const SizedBox(width: 10),
          Consumer<ChatState>(
            builder: (context, chatState, _) {
              return Container(
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: !chatState.isSendButtonIcon
                      ? null
                      : () async {
                          await ChatRepo.instance.sendTextMessage(
                            text: messageController.text,
                            receiverUserModel: widget.recieverUserModel!,
                            senderUser: context.read<UserState>().userModel,
                            context: context,
                          );
                          if (!mounted) return;
                          setState(() {
                            messageController.clear();
                          });
                        },
                  icon: Icon(
                    !chatState.isSendButtonIcon ? Icons.mic : Icons.send,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
