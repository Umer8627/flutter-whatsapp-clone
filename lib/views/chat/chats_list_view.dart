import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/constants/color_constant.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/models/contact_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/repo/auth_repo.dart';
import 'package:whatsapp_clone/repo/chat_repo.dart';
import 'package:whatsapp_clone/state/user_state.dart';
import 'package:whatsapp_clone/utills/snippets.dart';
import 'package:whatsapp_clone/views/chat/chat_room.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ContactModel>>(
        stream: ChatRepo.instance.getContactedChats(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString(),
                  style: CustomFont.regularText),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.hexagonDots(
                    color: tabColor, size: 50));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Chat Found', style: CustomFont.regularText),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                ContactModel contact = snapshot.data![index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: backgroundColor,
                    elevation: 10,
                    child: InkWell(
                      onTap: () async {
                        UserModel? model = await AuthRepo.instance
                            .getUserDetail(contact.contactId);
                        if (!mounted) return;
                        push(context, ChatRoom(userModel: model!));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            contact.profilePic,
                          ),
                        ),
                        title: Text(
                          contact.name,
                          style: CustomFont.regularText
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Row(
                          children: [
                            if (contact.isSenderIsCurrentUser)
                              StreamBuilder<bool>(
                                stream:
                                    ChatRepo.instance.isMessageRead(contactId: contact.contactId,messageId: contact.lastMessageSentId),
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
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                contact.lastMessage,
                                overflow: TextOverflow.ellipsis,
                                style: CustomFont.lightText
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '8:45 PM',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (!contact.isSenderIsCurrentUser)
                              StreamBuilder<int>(
                                  stream: ChatRepo.instance
                                      .getUnseenMessagesCount(contact),
                                  builder: (_, snapshot) {
                                    return snapshot.data == 0
                                        ? const SizedBox.shrink()
                                        : CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.green,
                                            child: Text(
                                              snapshot.data.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                  })
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
