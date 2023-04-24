import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/constants/color_constant.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/repo/chat_repo.dart';
import 'package:whatsapp_clone/state/user_state.dart';
import 'package:whatsapp_clone/views/chat/components/receiver_message_card.dart';
import 'package:whatsapp_clone/views/chat/components/sender_message_card.dart';

import 'components/bottom_chat_field.dart';

class ChatRoom extends StatefulWidget {
  final UserModel userModel;
  const ChatRoom({super.key, required this.userModel});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25,
        title: Row(
          children: [
            widget.userModel.profilePic == ''
                ? const CircleAvatar(
                    radius: 20,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.userModel.profilePic),
                  ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userModel.name,
                  style: CustomFont.regularText
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                Text(
                  'Online',
                  style: CustomFont.lightText.copyWith(
                      fontWeight: FontWeight.w800,
                      color: tabColor,
                      fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<List<Message>>(
              stream: ChatRepo.instance.getChatStream(widget.userModel.uid),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No messages yet!',
                            style: CustomFont.regularText.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 16)));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (_, index) {
                      final message = snapshot.data![index];
                      if (!message.isSeen &&
                          message.receiverId ==
                              FirebaseAuth.instance.currentUser!.uid) {
                        ChatRepo.instance.setChatMessageSeen(
                            message: message, receiverModel: widget.userModel);
                      }

                      if (message.senderId ==
                          context.read<UserState>().userModel.uid) {
                        return SenderMessageCard(message: message,receiverUserModel: widget.userModel,);
                      } else {
                        return ReceiverMessageCard(text: message.text);
                      }
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }),
          const Spacer(),
          BottomChatField(recieverUserModel: widget.userModel),
        ],
      ),
    );
  }
}
