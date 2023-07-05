import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/enums/message_enum.dart';
import 'package:whatsapp_clone/state/chat_state.dart';
import 'package:whatsapp_clone/utills/snippets.dart';
import 'package:whatsapp_clone/views/widgets/custom_textfield.dart';
import '../../../constants/color_constant.dart';
import '../../../models/user_model.dart';
import '../../../state/user_state.dart';

class ShowSelectFile extends StatefulWidget {
  final File selectFile;
  final MessageEnum type;
  final UserModel userModel;
  const ShowSelectFile(
      {super.key,
      required this.selectFile,
      required this.type,
      required this.userModel});

  @override
  State<ShowSelectFile> createState() => _ShowSelectFileState();
}

class _ShowSelectFileState extends State<ShowSelectFile> {
  final captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(),
        Image.file(widget.selectFile, height: 500,width: double.infinity,fit: BoxFit.cover,),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: CustomTextfield(
                  controller: captionController,
                  hintText: "Add Caption",
                  prefixIcon: Icons.image_outlined,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: () async {
                    try {
                      final chatState =
                          Provider.of<ChatState>(context, listen: false);
                      await chatState.sendFileMessage(
                        galleryImage: widget.selectFile,
                        receiverUserModel: widget.userModel,
                        senderUser: context.read<UserState>().userModel,
                        caption: captionController.text,
                        context: context
                      );
                      if (!mounted) return;
                      pop(context);
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ]),
    );
  }
}


/*
Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: LoaderButton(
              radius: 16,
              btnText: 'Send',
              onTap: () async {
               
              }),
        )

*/ 