import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/enums/message_enum.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/state/chat_state.dart';
import 'package:whatsapp_clone/utills/snippets.dart';
import 'package:whatsapp_clone/views/chat/components/show_select_file.dart';

import '../../../constants/color_constant.dart';
import '../../widgets/circle_icon_container.dart';

class SendFileOptionWidget extends StatefulWidget {
  final UserModel userModel;
  const SendFileOptionWidget({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<SendFileOptionWidget> createState() => _SendFileOptionWidgetState();
}

class _SendFileOptionWidgetState extends State<SendFileOptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: mobileChatBoxColor,
        ),
        child: Consumer<ChatState>(builder: (context, chatState, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CircleIconContainer(
                        onTap: () {},
                        color: appPurpleColor,
                        icon: Icons.file_copy_outlined,
                        iconColor: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Document',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      CircleIconContainer(
                        onTap: () {},
                        color: appGreenColor,
                        icon: Icons.camera_alt_outlined,
                        iconColor: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Camera',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      CircleIconContainer(
                        onTap: () async {
                          File? galleryImage = await pickImage(
                              context: context,
                              imageSource: ImageSource.gallery);
                          if (galleryImage != null) {
                            if (!mounted) return;
                            push(
                                context,
                                ShowSelectFile(
                                    userModel: widget.userModel,
                                    selectFile: galleryImage,
                                    type: MessageEnum.gif));
                            chatState.setFileIconClick(false);
                          }
                        },
                        color: appPinkColor,
                        icon: Icons.image_outlined,
                        iconColor: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Gallery',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
