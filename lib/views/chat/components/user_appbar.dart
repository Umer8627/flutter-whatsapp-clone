import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/repo/chat_repo.dart';
import 'package:whatsapp_clone/utills/snippets.dart';

import '../../../constants/color_constant.dart';
import '../../../constants/theme_constant.dart';
import '../../../models/user_model.dart';
import '../../../state/internet_state.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel userModel;

  const UserAppBar({Key? key, required this.userModel}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: StreamBuilder<UserModel?>(
        stream: ChatRepo.instance.getChatUserById(userModel.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Handle error case
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for data
            return Container();
          }

          final userModel = snapshot.data;

          return Row(
            children: [
              if (context.watch<InternetState>().isInternet)
                userModel?.profilePic == ''
                    ? const CircleAvatar(
                        radius: 20,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(userModel!.profilePic),
                      ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userModel?.name ?? '',
                    style: CustomFont.regularText
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  Text(
                    userModel!.isonline ? 'Online' : 'Offline',
                    style: CustomFont.lightText.copyWith(
                        fontWeight: FontWeight.w800,
                        color: tabColor,
                        fontSize: 10),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
