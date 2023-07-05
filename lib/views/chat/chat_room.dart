import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/repo/chat_repo.dart';
import 'package:whatsapp_clone/state/user_state.dart';
import 'package:whatsapp_clone/utills/snippets.dart';
import 'package:whatsapp_clone/views/chat/components/receiver_message_card.dart';
import 'package:whatsapp_clone/views/chat/components/send_file_option_widget.dart';
import 'package:whatsapp_clone/views/chat/components/sender_message_card.dart';
import '../../state/chat_state.dart';
import '../../state/internet_state.dart';
import 'components/bottom_chat_field.dart';
import 'components/user_appbar.dart';

class ChatRoom extends StatefulWidget {
  final UserModel userModel;
  const ChatRoom({super.key, required this.userModel});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    openBox();
  }

  openBox() async {
    await Hive.openBox(widget.userModel.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final chatState = Provider.of<ChatState>(context, listen: false);
        chatState.setFileIconClick(false);
      },
      child: Scaffold(
        appBar: UserAppBar(userModel: widget.userModel),
        body: Stack(
          children: [
            context.watch<InternetState>().isInternet
                ? StreamBuilder<List<Message>>(
                    stream:
                        ChatRepo.instance.getChatStream(widget.userModel.uid),
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          messageController.jumpTo(
                              messageController.position.maxScrollExtent);
                        });
                        var messages = Hive.box(widget.userModel.uid);
                        for (var i = 0; i < snapshot.data!.length; i++) {
                          messages.put(
                              snapshot.data?[i].messageId,
                              snapshot.data?[i]
                                  .copyWith(isuploaded: true)
                                  .toMap());
                        }

                        return ValueListenableBuilder(
                            valueListenable:
                                Hive.box(widget.userModel.uid).listenable(),
                            builder: (context, box, _) {
                              List<Message> messages = box.values
                                  .map((e) => Message.fromMap(e))
                                  .toList();
                              messages.sort(
                                  (a, b) => a.timeSent.compareTo(b.timeSent));
                              return Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      controller: messageController,
                                      itemCount: messages.length,
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemBuilder: (_, index) {
                                        final message = messages[index];
                                        if (!message.isSeen &&
                                            message.receiverId ==
                                                FirebaseAuth.instance
                                                    .currentUser!.uid) {
                                          ChatRepo.instance.setChatMessageSeen(
                                              message: message,
                                              receiverModel: widget.userModel);
                                        }
                                        if (message.senderId ==
                                            context
                                                .read<UserState>()
                                                .userModel
                                                .uid) {
                                          return SenderMessageCard(
                                            message: message,
                                            receiverUserModel: widget.userModel,
                                          );
                                        } else {
                                          return ReceiverMessageCard(
                                            message: message,
                                            receiverUserModel: widget.userModel,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  BottomChatField(
                                      recieverUserModel: widget.userModel),
                                ],
                              );
                            });
                      }
                    })
                : ValueListenableBuilder(
                    valueListenable:
                        Hive.box(widget.userModel.uid).listenable(),
                    builder: (context, box, _) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        messageController
                            .jumpTo(messageController.position.maxScrollExtent);
                      });
                      List<Message> messages =
                          box.values.map((e) => Message.fromMap(e)).toList();
                      messages.sort((a, b) => a.timeSent.compareTo(b.timeSent));
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: messageController,
                              itemCount: messages.length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (_, index) {
                                final message = messages[index];

                                print(message.isuploaded);
                                if (!message.isSeen &&
                                    message.receiverId ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
                                  ChatRepo.instance.setChatMessageSeen(
                                      message: message,
                                      receiverModel: widget.userModel);
                                }
                                if (message.senderId ==
                                    context.read<UserState>().userModel.uid) {
                                  return SenderMessageCard(
                                    message: message,
                                    receiverUserModel: widget.userModel,
                                  );
                                } else {
                                  return ReceiverMessageCard(
                                    message: message,
                                    receiverUserModel: widget.userModel,
                                  );
                                }
                              },
                            ),
                          ),
                          BottomChatField(recieverUserModel: widget.userModel),
                        ],
                      );
                    }),
            Consumer<ChatState>(builder: (context, chatState, child) {
              return chatState.isFileIconClick
                  ? Positioned(
                      bottom: 70,
                      right: 10,
                      left: 10,
                      child: SendFileOptionWidget(
                        userModel: widget.userModel,
                      ))
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
